# Changelog

## [1.16.3](https://github.com/isceco/github-workflows/compare/v1.16.2...v1.16.3) (2026-09-04)


### Bug Fixes

* do not treat test fixtures as consumer visible ([#37](https://github.com/isceco/github-workflows/issues/37)) ([67ea390](https://github.com/isceco/github-workflows/commit/67ea39045e380923e216aea9ad6425f46716ccf7))

## [1.16.2](https://github.com/isceco/github-workflows/compare/v1.16.1...v1.16.2) (2026-09-01)


### Bug Fixes

* do not test the oidc role secret in a step condition ([#35](https://github.com/isceco/github-workflows/issues/35)) ([f1a0f16](https://github.com/isceco/github-workflows/commit/f1a0f16b775ab9c729c35d96e018885a72997a82))

## [1.16.1](https://github.com/isceco/github-workflows/compare/v1.16.0...v1.16.1) (2026-09-01)


### Bug Fixes

* bump bridgecrewio/checkov-action ([58f964d](https://github.com/isceco/github-workflows/commit/58f964de9a0ed0b359d074f39f1c6e16ee1f3d41))
* bump bridgecrewio/checkov-action from 12.3119.0 to 12.3121.0 in the actions-minor-and-patch group ([#31](https://github.com/isceco/github-workflows/issues/31)) ([58f964d](https://github.com/isceco/github-workflows/commit/58f964de9a0ed0b359d074f39f1c6e16ee1f3d41))

## [1.16.0](https://github.com/isceco/github-workflows/compare/v1.15.1...v1.16.0) (2026-09-01)


### Features

* authenticate to AWS and ECR in the terraform-test job ([#32](https://github.com/isceco/github-workflows/issues/32)) ([1ada045](https://github.com/isceco/github-workflows/commit/1ada045a9c224a556836276296cb8d03bbf04051))

## [1.15.1](https://github.com/isceco/github-workflows/compare/v1.15.0...v1.15.1) (2026-08-28)


### Bug Fixes

* honour release-please-config.json when a repository ships one ([#29](https://github.com/isceco/github-workflows/issues/29)) ([f50218b](https://github.com/isceco/github-workflows/commit/f50218b0452910bad9f584afc0bc331a06f7d2be))

## [1.15.0](https://github.com/isceco/github-workflows/compare/v1.14.2...v1.15.0) (2026-08-28)


### Features

* run tofu test when a repository has tests ([#27](https://github.com/isceco/github-workflows/issues/27)) ([e33459b](https://github.com/isceco/github-workflows/commit/e33459b68785a1ad3e0e85e36d7744b667cdf13c))

## [1.14.2](https://github.com/isceco/github-workflows/compare/v1.14.1...v1.14.2) (2026-08-28)


### Bug Fixes

* render module docs as a table so an OCI source reads correctly ([#25](https://github.com/isceco/github-workflows/issues/25)) ([cdd5aee](https://github.com/isceco/github-workflows/commit/cdd5aee3177c0f61189b64cc4659c6b362dff3be))

## [1.14.1](https://github.com/isceco/github-workflows/compare/v1.14.0...v1.14.1) (2026-08-27)


### Bug Fixes

* stop the reporting steps from deciding the build outcome ([#23](https://github.com/isceco/github-workflows/issues/23)) ([b5e6996](https://github.com/isceco/github-workflows/commit/b5e69966a59730e4b62ff24a2ddfb1754ac499f9))

## [1.14.0](https://github.com/isceco/github-workflows/compare/v1.13.1...v1.14.0) (2026-08-27)


### Features

* gate lint and security on severity instead of finding count ([#21](https://github.com/isceco/github-workflows/issues/21)) ([09afec3](https://github.com/isceco/github-workflows/commit/09afec31d915b6797e5a177ea3df7baccb5668a0))

## [1.13.1](https://github.com/isceco/github-workflows/compare/v1.13.0...v1.13.1) (2026-08-25)


### Bug Fixes

* release dependency bumps so consumers receive them ([73e3942](https://github.com/isceco/github-workflows/commit/73e39422cda4c353c9540942ffa5660d804b1c58))

## [1.13.0](https://github.com/isceco/github-workflows/compare/v1.12.2...v1.13.0) (2026-08-25)


### Features

* drop the external push action and pin the rest to commits ([117375e](https://github.com/isceco/github-workflows/commit/117375eb82c400d36dc4098b81c9f99545f7511d))

## [1.12.2](https://github.com/isceco/github-workflows/compare/v1.12.1...v1.12.2) (2026-08-25)


### Bug Fixes

* bump the last two actions off Node 20 ([cc89944](https://github.com/isceco/github-workflows/commit/cc8994475107e8b0fe0b9569e29492d943e069c2))

## [1.12.1](https://github.com/isceco/github-workflows/compare/v1.12.0...v1.12.1) (2026-08-25)


### Bug Fixes

* skip the app token step when no app is configured ([de758b8](https://github.com/isceco/github-workflows/commit/de758b8d125854fd4a47ae0396f2011014262752))

## [1.12.0](https://github.com/isceco/github-workflows/compare/v1.11.0...v1.12.0) (2026-08-25)


### Features

* render Checkov findings into the run summary ([342174e](https://github.com/isceco/github-workflows/commit/342174ef04379ca0103772b3fb98583d83c84360))

## [1.11.0](https://github.com/isceco/github-workflows/compare/v1.10.0...v1.11.0) (2026-08-25)


### Features

* allow Checkov to report without failing ([14d9e1c](https://github.com/isceco/github-workflows/commit/14d9e1cd8450fe70ee292c097a4ec867eccbbd5e))

## [1.10.0](https://github.com/isceco/github-workflows/compare/v1.9.0...v1.10.0) (2026-08-25)


### Features

* add a reusable conventional pull request check ([fe2d13a](https://github.com/isceco/github-workflows/commit/fe2d13ac766ad5d3a3273eaea9c7b94f1009b848))


### Bug Fixes

* comment a usable module source, not the push reference ([054d1fc](https://github.com/isceco/github-workflows/commit/054d1fcd7a532441d136c723263ac236593d63d9))

## [1.9.0](https://github.com/isceco/github-workflows/compare/v1.8.0...v1.9.0) (2026-08-25)


### Features

* publish a preview artifact for pull requests ([46e96e2](https://github.com/isceco/github-workflows/commit/46e96e21ad06a8dbb73021e95c88a2d2642900de))

## [1.8.0](https://github.com/isceco/github-workflows/compare/v1.7.0...v1.8.0) (2026-08-24)


### Features

* notify the documentation repository after a publish ([57efb3a](https://github.com/isceco/github-workflows/commit/57efb3aad993590649f90e10abf4bb24352a178c))

## [1.7.0](https://github.com/isceco/github-workflows/compare/v1.6.0...v1.7.0) (2026-08-24)


### Features

* prefer a module metadata file for descriptions ([198a220](https://github.com/isceco/github-workflows/commit/198a2201d71da4807f243a254ce76402b6483e92))

## [1.6.0](https://github.com/isceco/github-workflows/compare/v1.5.1...v1.6.0) (2026-08-24)


### Features

* read repository descriptions via a GitHub App token ([616b3b5](https://github.com/isceco/github-workflows/commit/616b3b5b15c78e76e969fa61822a9a7597efa87c))

## [1.5.1](https://github.com/isceco/github-workflows/compare/v1.5.0...v1.5.1) (2026-08-21)


### Bug Fixes

* pin the per-module snippet to the newest version ([30d7060](https://github.com/isceco/github-workflows/commit/30d70605d0c51880d56c497e6234c16b7aa3cac9))

## [1.5.0](https://github.com/isceco/github-workflows/compare/v1.4.0...v1.5.0) (2026-08-21)


### Features

* add reusable update_module_catalog workflow ([0d9520f](https://github.com/isceco/github-workflows/commit/0d9520f0f63324f68cf467687c19431c5f18fb30))


### Bug Fixes

* pin checkov-action to a commit instead of master ([820423f](https://github.com/isceco/github-workflows/commit/820423f9b0898fdc01a3234a955c880fb487b5a6))

## [1.4.0](https://github.com/isceco/github-workflows/compare/v1.3.0...v1.4.0) (2026-08-19)


### Features

* bump upload-artifact, app-token, buildx and setup-opentofu ([9e18378](https://github.com/isceco/github-workflows/commit/9e18378c0f38861312c4045654df4a0f29ec2357))


### Bug Fixes

* bump checkout to v7 and configure-aws-credentials to v6 ([f96b7cf](https://github.com/isceco/github-workflows/commit/f96b7cf63e693aed4759576c30f8ea5a36623497))

## [1.3.0](https://github.com/isceco/github-workflows/compare/v1.2.0...v1.3.0) (2026-08-19)


### Features

* add reusable publish_tofu_module workflow ([54993e3](https://github.com/isceco/github-workflows/commit/54993e3843a1550976c25633543f83e98e541e63))

## [1.2.0](https://github.com/isceco/github-workflows/compare/v1.1.0...v1.2.0) (2026-07-09)


### Features

* add reusable docker build scan and push workflow ([063cb7f](https://github.com/isceco/github-workflows/commit/063cb7f3991e735ba4e5cc0e800da1bd40433d78))

## [1.1.0](https://github.com/isceco/github-workflows/compare/v1.0.1...v1.1.0) (2026-07-09)


### Features

* add shared copy_ecr_image, ecs_smoke_test, update_infra_tfvars composite actions ([7f3dda9](https://github.com/isceco/github-workflows/commit/7f3dda96e3d54a99de025c34fe9e9a7b39d44378))

## [1.0.1](https://github.com/isceco/github-workflows/compare/v1.0.0...v1.0.1) (2026-07-09)


### Bug Fixes

* updates ([9e61d08](https://github.com/isceco/github-workflows/commit/9e61d085ac712babcf0da53bbab1457c6982cca2))

## 1.0.0 (2026-07-09)


### Features

* init reusable workflows ([3a9454e](https://github.com/isceco/github-workflows/commit/3a9454e24d61a13f875392f55143e36c4146234d))
