#!/bin/bash

# Checkout the template to the project-template subdir
git clone --depth 1 https://github.com/jncraton/project-template.git

# Move the files from the template here
mv project-template/* .
mv project-template/.travis.yml .
mv project-template/.gitignore .

# Get rid of the subdir
rm -rf project-template

# Remove extra files
rm -f new.sh

# Truncate the readme
rm -f readme.md
touch readme.md

# Create a new repo here
git init
git add * .gitignore .travis.yml
git commit -a -m "Initial commit"
