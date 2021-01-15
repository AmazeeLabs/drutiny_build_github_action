#!/bin/bash

# args
# $1 :: ${{ inputs.tag-reg }}
# $2 :: ${{ inputs.composer-packages }}
# $3 :: ${{ inputs.composer-repos }}

# Store args
tag=$(echo $1)
echo "Tag: '$tag'"

composer_packages=$(echo $2)
echo "Composer packages: '$composer_packages'"
IFS=', ' read -r -a packages_array <<EOF
$composer_packages
EOF

composer_repos=$(echo $3)
echo "Composer repos: '$composer_repos'"
IFS=';' read -r -a repo_array <<EOF
$composer_repos
EOF

# Clean up
rm -rf ./drutiny
composer clearcache

# Checkout latest Drutiny project
git clone --depth=2 https://github.com/drutiny/drutiny.git drutiny
cd ./drutiny

# Gthub rate limiting may get reached - using GH Oauth token will prevent issue.
if [ -n "$COMPOSER_TOKEN" ]; then
  composer -q global config github-oauth.github.com "$COMPOSER_TOKEN"
fi

# Composer install Drutiny
composer install --no-interaction --no-progress --no-suggest --no-dev --ignore-platform-reqs

# Include any repo definitions
for repo in "${repo_array[@]}"
do
  echo "composer config repositories.$repo"
  composer config repositories.$repo
done

# Include ALGM Drutiny magic packages
for package in "${packages_array[@]}"
do
  composer require $package --ignore-platform-reqs --no-suggest --no-interaction
done

# Build phar
./bin/build_phar $tag

# Rename phar to algm_drutiny_<tag>.phar
find . -type f -name 'drutiny*.phar' -execdir mv {} "algm_drutiny_$tag.phar" \;
phar_file=$(find . -type f -name '*drutiny*.phar')
echo $phar_file

# Test its runnning
./algm_drutiny*.phar profile:list && ./algm_drutiny*.phar policy:list
drutiny_result=$?
if [ $drutiny_result -eq 0 ]; then
  echo "Successfully ran tests."
else
  echo "Tests failed"
  exit 1
fi

# Store output
echo ::set-output name=phar::$phar_file
