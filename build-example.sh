#!/bin/bash
set -e

# Be in control of our location
cd $(dirname ${0})

# Set the required bits into SSM
extras/set_ssm.sh

# Make a temporrart virtualenv
food=$(date +%s)
virtualenv /tmp/${food}
. /tmp/${food}/bin/activate
pip install -Ur deployment/requirements.txt

# Build the stacks
bumpversion patch
(cd vpc; stackility upsert -i config.ini)
(cd iam/deploy; stackility upsert -i config.ini)
(cd iam/project; stackility upsert -i config.ini)
(cd deployment/code_pipeline/; stackility upsert -i config.ini)
