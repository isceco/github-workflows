#!/bin/bash
# Execute the shell bodies of terraform.yml's reporting steps against fixed inputs.
#
# Why this exists: GitHub runs step scripts as "bash -e {0}", and these scripts add
# "set -o pipefail". Under that combination a grep that matches nothing aborts the step
# with no output and no explanation, which is how a Trivy run with zero findings came to
# fail a job that was configured not to block on findings at all. The bug was invisible
# to every check we had, because the yaml is valid, the python parsers are correct in
# isolation, and a permissive interactive shell runs the same script happily.
#
# So the rule these tests encode is: the reporting plumbing must never be what decides
# the outcome. Only an explicitly captured tool exit code may do that.
#
# Usage: tests/test_steps.sh    (needs bash, ruby, python3)

set -u

SP="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$SP/.." && pwd)"
BUILD="$SP/.build"
rm -rf "$BUILD" && mkdir -p "$BUILD"

ruby -ryaml -e '
wf = YAML.load_file(ARGV[0])
out = ARGV[1]
{
  "terraform-lint"     => {"Run TFLint" => "step_tflint_run.sh", "TFLint findings" => "step_tflint.sh"},
  "terraform-security" => {"Trivy findings" => "step_trivy.sh"},
}.each do |job, steps|
  steps.each do |name, file|
    s = wf["jobs"][job]["steps"].find { |x| x["name"] == name } or abort "missing step: #{name}"
    File.write(File.join(out, file), s["run"])
  end
end
' "$REPO/.github/workflows/terraform.yml" "$BUILD" || exit 1

PASS=0
FAIL=0

run_case() {
  local desc="$1" script="$2" want="$3"
  shift 3
  local dir
  dir=$(mktemp -d "${TMPDIR:-/tmp}/wfstep.XXXXXX")
  export RUNNER_TEMP="$dir"
  export GITHUB_STEP_SUMMARY="$dir/summary.md"
  export GITHUB_OUTPUT="$dir/output.txt"
  export ANNOTATIONS="$dir/annotations.txt"
  : > "$GITHUB_STEP_SUMMARY"
  : > "$GITHUB_OUTPUT"

  "$@"  # fixture setup for this case

  local out got
  # bash -e is what the runner uses; the script supplies its own pipefail
  out=$(bash -e "$BUILD/$script" 2>&1)
  got=$?

  if [ "$got" = "$want" ]; then
    printf "  ok    %-46s exit=%s\n" "$desc" "$got"
    PASS=$((PASS + 1))
  else
    printf "  FAIL  %-46s exit=%s want=%s\n" "$desc" "$got" "$want"
    printf "        stdout:  %s\n" "$(echo "$out" | head -3 | tr '\n' ' ')"
    printf "        summary: %s\n" "$(head -3 "$GITHUB_STEP_SUMMARY" | tr '\n' ' ')"
    FAIL=$((FAIL + 1))
  fi
  rm -rf "$dir"
}

trivy_none() { echo '{"Results":[]}' > "$RUNNER_TEMP/trivy.json"; }
trivy_missing() { :; }
trivy_malformed() { echo 'not json' > "$RUNNER_TEMP/trivy.json"; }
trivy_high() { cp "$SP/fixtures/trivy-high.json" "$RUNNER_TEMP/trivy.json"; }
trivy_medium() { cp "$SP/fixtures/trivy-medium.json" "$RUNNER_TEMP/trivy.json"; }

echo ""
echo "Trivy findings   (FAIL_SEVERITY=HIGH,CRITICAL)"
export FAIL_SEVERITY="HIGH,CRITICAL"

export SOFT_FAIL=true
run_case "soft: no findings" step_trivy.sh 0 trivy_none
run_case "soft: findings at the gating severity" step_trivy.sh 0 trivy_high
run_case "soft: findings below the gate" step_trivy.sh 0 trivy_medium
run_case "soft: report missing" step_trivy.sh 0 trivy_missing
run_case "soft: report malformed" step_trivy.sh 1 trivy_malformed

export SOFT_FAIL=false
run_case "hard: no findings" step_trivy.sh 0 trivy_none
run_case "hard: findings at the gating severity" step_trivy.sh 1 trivy_high
run_case "hard: findings below the gate" step_trivy.sh 0 trivy_medium
run_case "hard: report missing" step_trivy.sh 0 trivy_missing
run_case "hard: report malformed" step_trivy.sh 1 trivy_malformed

tflint_none() { echo '{"issues":[],"errors":[]}' > "$RUNNER_TEMP/tflint.json"; }
tflint_warn() { cp "$SP/fixtures/tflint-warn.json" "$RUNNER_TEMP/tflint.json"; }
tflint_err() { cp "$SP/fixtures/tflint-err.json" "$RUNNER_TEMP/tflint.json"; }
tflint_missing() { :; }
tflint_malformed() { echo 'not json' > "$RUNNER_TEMP/tflint.json"; }

echo ""
echo "TFLint findings"

export TFLINT_EXIT=0
run_case "exit 0: no issues" step_tflint.sh 0 tflint_none
run_case "exit 0: warnings and infos only" step_tflint.sh 0 tflint_warn
export TFLINT_EXIT=2
run_case "exit 2: issues at error severity" step_tflint.sh 1 tflint_err
export TFLINT_EXIT=1
run_case "exit 1: tflint itself failed" step_tflint.sh 1 tflint_missing
export TFLINT_EXIT=0
run_case "exit 0: report malformed" step_tflint.sh 1 tflint_malformed
export TFLINT_EXIT=""
run_case "exit absent: run step aborted" step_tflint.sh 1 tflint_warn

echo ""
echo "passed: $PASS   failed: $FAIL"
rm -rf "$BUILD"
[ "$FAIL" -eq 0 ]
