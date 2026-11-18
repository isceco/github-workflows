# to find Dependabot pull requests across GitHub organization, check whether they contain only GitHub Actions patch updates, and enable auto-merge for eligible PRs.
"""Fail-closed organization-wide Dependabot GitHub Actions patch auto-merge."""
import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

SEMVER = re.compile(r'^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$')
REF = re.compile(r'^(?P<indent>\s*(?:-\s*)?uses:\s*)(?P<repo>[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+(?:/\.github/workflows/[A-Za-z0-9_.-]+\.ya?ml)?|[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/[A-Za-z0-9_./-]+)@(?P<version>v?\d+\.\d+\.\d+)(?P<tail>\s*(?:#.*)?)$')
# Only simple, explicit SemVer tags are auto-merged. SHA pins are deliberately excluded.
HUNK = re.compile(r'^@@ ')


def patch_only(patch):
    """Only changed `uses:` references; no other lines or file changes."""
    if not patch or not HUNK.search(patch):
        return False
    old, new = [], []
    pairs = 0
    def check_pair():
        nonlocal pairs
        if not old and not new:
            return True
        if len(old) != 1 or len(new) != 1:
            return False
        a, b = REF.fullmatch(old[0]), REF.fullmatch(new[0])
        if not a or not b or a['indent'] != b['indent'] or a['repo'] != b['repo'] or a['tail'] != b['tail']:
            return False
        x, y = SEMVER.fullmatch(a['version']), SEMVER.fullmatch(b['version'])
        if not x or not y:
            return False
        av, bv = tuple(map(int, x.groups())), tuple(map(int, y.groups()))
        if av[:2] != bv[:2] or bv[2] <= av[2]:
            return False
        pairs += 1
        return True
    for line in patch.splitlines():
        if line.startswith('@@'):
            if not check_pair():
                return False
            old, new = [], []
        elif line.startswith(('--- ', '+++ ', '\\')):
            continue
        elif line.startswith('-'):
            old.append(line[1:])
        elif line.startswith('+'):
            new.append(line[1:])
        elif line.startswith(' '):
            if not check_pair():
                return False
            old, new = [], []
        else:
            return False
    return check_pair() and pairs > 0


def eligible_files(files):
    if not files:
        return False
    for f in files:
        path = f.get('filename', '')
        if not (path.startswith('.github/workflows/') and path.endswith(('.yml', '.yaml')) or
                path.startswith('.github/actions/') and path.endswith(('/action.yml', '/action.yaml'))):
            return False
        if f.get('status') != 'modified' or not patch_only(f.get('patch')):
            return False
    return True


class API:
    def __init__(self, token):
        self.token = token
    def get(self, path):
        url = 'https://api.github.com' + path
        req = urllib.request.Request(url, headers={'Authorization': 'Bearer ' + self.token,
            'Accept': 'application/vnd.github+json', 'X-GitHub-Api-Version': '2022-11-28',
            'User-Agent': 'dependabot-patch-automerge'})
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.load(resp)
    def pages(self, path, collection=None):
        page = 1
        while True:
            join = '&' if '?' in path else '?'
            data = self.get(f'{path}{join}per_page=100&page={page}')
            if collection is not None:
                data = data.get(collection) if isinstance(data, dict) else None
            if not isinstance(data, list):
                raise RuntimeError('Unexpected pagination response')
            yield from data
            if len(data) < 100:
                break
            page += 1


def has_required_checks(api, full_name, branch):
    repo = urllib.parse.quote(full_name, safe='/')
    branch = urllib.parse.quote(branch, safe='')
    # Effective rules include organization rulesets. Never interpret API errors as no rules.
    rules = api.get(f'/repos/{repo}/rules/branches/{branch}')
    if any(r.get('type') == 'required_status_checks' for r in rules):
        return True
    try:
        protection = api.get(f'/repos/{repo}/branches/{branch}/protection/required_status_checks')
        return bool(protection.get('contexts') or protection.get('checks'))
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return False
        raise


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--apply', action='store_true', help='Enable auto-merge (default: dry-run)')
    parser.add_argument('--org', required=True)
    args = parser.parse_args()
    token = os.environ.get('GH_TOKEN')
    if not token:
        parser.error('GH_TOKEN missing')
    api = API(token)
    total, eligible, errors = 0, 0, 0
    for repo in api.pages('/installation/repositories', collection='repositories'):
        if repo.get('owner', {}).get('login', '').lower() != args.org.lower() or repo.get('archived') or repo.get('disabled'):
            continue
        full = repo['full_name']
        try:
            details = api.get('/repos/' + full)
            if not details.get('allow_auto_merge'):
                print(f'SKIP {full}: auto-merge disabled')
                continue
            for pr in api.pages(f'/repos/{full}/pulls?state=open'):
                if pr.get('user', {}).get('login') != 'dependabot[bot]' or pr.get('draft'):
                    continue
                total += 1
                num = pr['number']
                try:
                    if pr.get('head', {}).get('repo', {}).get('full_name') != full:
                        print(f'SKIP {full}#{num}: external head repository')
                        continue
                    if pr.get('base', {}).get('ref') != details.get('default_branch'):
                        print(f'SKIP {full}#{num}: non-default target')
                        continue
                    files = list(api.pages(f'/repos/{full}/pulls/{num}/files'))
                    if not eligible_files(files):
                        print(f'SKIP {full}#{num}: not verifiable patch-only Actions update')
                        continue
                    if not has_required_checks(api, full, pr['base']['ref']):
                        print(f'SKIP {full}#{num}: no enforced required status checks')
                        continue
                    eligible += 1
                    print(f'{"APPLY" if args.apply else "DRY-RUN"} {full}#{num}: eligible', flush=True)
                    if args.apply:
                        # CLI requests native auto-merge; does not force merge or bypass checks.
                        import subprocess
                        subprocess.run(['gh', 'pr', 'merge', str(num), '--repo', full, '--auto', '--squash'],
                                       env=os.environ.copy(), check=True)
                except Exception as exc:
                    errors += 1
                    print(f'ERROR {full}#{num}: {exc}', file=sys.stderr)
        except Exception as exc:
            errors += 1
            print(f'ERROR {full}: {exc}', file=sys.stderr)
    print(f'SUMMARY Dependabot PRs={total} eligible={eligible} errors={errors} mode={"apply" if args.apply else "dry-run"}')
    if errors:
        sys.exit(1)


if __name__ == '__main__':
    main()
