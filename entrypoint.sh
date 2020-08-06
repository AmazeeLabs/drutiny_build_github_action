#!/bin/sh -l

# Checkout latest Drutiny project
git clone --depth=2 https://github.com/drutiny/drutiny.git drutiny
cd ./drutiny

# Composer install
composer install --no-interaction --no-progress --no-suggest --no-dev

# Include algm drutiny magic packages
# TODO: make sure this is actually right ALSO
# this is the actual repo that we're interested in releasing, so if there are
# any tags we can pass via GH Actions to make this specific, do it here.
composer require bomoko/algm_drutiny_profile:dev-master
composer require bomoko/lagoon-formatter:dev-master

# Build phar
TAG = $1
echo "Tag: ${TAG}"

./bin/build_phar ${TAG}
ls

# @TODO: Rename phar to maybe algm_drutiny_<tag>.phar
phar_file="./drutiny${TAG}.phar"
echo $phar_file

# Test its runnning
./drutiny*.phar profile:list
DRUTINY_RESULT=$?
if [ $DRUTINY_RESULT -eq 0 ]; then
  echo "Successfully ran tests"
else
  echo "Tests failed"
  exit 1
fi

# Store output
echo ::set-output name=phar::$phar_file
