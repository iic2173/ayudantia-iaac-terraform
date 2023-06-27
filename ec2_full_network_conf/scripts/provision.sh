#! /bin/bash

. ./scripts/01_check_arguments.sh
. ./scripts/02_load_functions.sh

WORKDIR=$(pwd)
TERRAFORM_DIR="$WORKDIR/terraform"
cd "$TERRAFORM_DIR" || { echo "Error: Unable to navigate to $TERRAFORM_DIR"; exit 1; }

terraform_workspace
terraform_init
terraform_validate
terraform_destroy
terraform_plan
terraform_apply

terraform graph -type=plan | dot -Tsvg > ../docs/graph.svg
terraform graph -type=plan | dot -Tpng > ../docs/graph.png
