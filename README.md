# ALGM Drutiny build docker action

This action builds a Drutiny phar file, made up of our packages and the latest Drutiny version.

## Inputs

### `tag-ref`

**Required** The tag version for the phar build. Default `"latest"`.

## Outputs

### `phar`

The Phar file.

## Example usage

uses: actions/drutiny-build-docker-action@v1
with:
  tag-ref: 'v1.0.0'


## Local dev testing

To docker build locally, try:

`docker build -t test-gh-action . && docker run -i -t --name=test-gh-action test-gh-action "TEST" "bomoko/lagoon-formatter:dev-master" "bomoko/algm_drutiny_profile vcs https://github.com/AmazeeLabs/algm_drutiny.git"`

To run container with args again:
`docker run -i -t --name=test-gh-action test-gh-action "TEST" "bomoko/lagoon-formatter:dev-master" "bomoko/algm_drutiny_profile vcs https://github.com/AmazeeLabs/algm_drutiny.git"`
