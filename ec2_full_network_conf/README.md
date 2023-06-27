# Terraform

## Variables

We can inject variables using the block:
```
variable "variable_name" {
  description   = "Description"
  type          = TYPE
  default       = "DEFAULT_VALUE"
}
```

## Environments

To be able to use this project to deploy multiple environments (such as dev, stage, prod) using only the same terraform, we have to use `terraform workspace`.

By default, the workspace used is `default`, this can be checked using `terraform workspace list` or `terraform workspace show`.

A workspace isolates the states that is "looking", so different workspaces will deploy different instances.

To create new workspaces 