#!/bin/bash

git clone --depth 1 https://github.com/jncraton/project-template.git
mv project-template/* .
rm -rf project-template
rm -f readme.md
touch readme.md