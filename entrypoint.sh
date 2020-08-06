#!/bin/sh -l

# args
# $1 :: ${{ inputs.tag-reg }}
# $2 :: ${{ inputs.composer-packages }}

# Store args
tag=$(echo $1)
echo "Tag: '$tag'"

composer_packages=$(echo $2)
echo "Composer packages: '$composer_packages'"
IFS=', ' read -r -a packages_array <<EOF
  $composer_packages
EOF

# Checkout latest Drutiny project
git clone --depth=2 https://github.com/drutiny/drutiny.git drutiny
cd ./drutiny

# Composer install
composer install --no-interaction --no-progress --no-suggest --no-dev

# Include algm drutiny magic packages
for package in "${packages_array[@]}"
do
    composer require $package
done

# Build phar
./bin/build_phar $tag

# @TODO: Rename phar to maybe algm_drutiny_<tag>.phar
phar_file="./drutiny$tag.phar"
echo $phar_file

# Test its runnning
./drutiny*.phar profile:list
drutiny_result=$?
if [ $drutiny_result -eq 0 ]; then
  echo "Successfully ran tests."
else
  echo "Tests failed"
  exit 1
fi

# Store output
echo ::set-output name=phar::$phar_file
