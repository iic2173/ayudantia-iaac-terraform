function terraform_exit() {
    terraform workspace select default
    exit 1
}

function terraform_workspace() {
    echo "terraform workspace new $ENV"
    terraform workspace new $ENV
    echo "terraform workspace select $ENV"
    terraform workspace select $ENV
}

function terraform_init() {
    echo "terraform init"
    (
    set -e
    terraform init
    )
    if [ $? -ne 0 ]; then
        echo "terraform init failed, retrying with -reconfigure"
        echo "terraform init -reconfigure"
        terraform init -reconfigure
    fi
}

function terraform_validate() {
    echo "terraform validate"
    (
    set -e
    terraform validate
    )
    if [ $? -ne 0 ]; then
        echo "terraform validate failed, exiting"
        exit 1
    fi
}

function terraform_plan() {
    echo "terraform plan"
    (
    set -e
    terraform plan
    )
    if [ $? -ne 0 ]; then
        terraform_exit
    fi
}

function terraform_apply() {
    echo "terraform apply -auto-approve"
    terraform apply -auto-approve
}

function terraform_destroy() {
    if [ "$DESTROY" = "true" ]; then
        echo "terraform destroy -auto-approve"
        terraform destroy -auto-approve
        terraform_exit
    fi
}
