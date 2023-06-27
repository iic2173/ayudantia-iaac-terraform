terraform {
  # The backend defines where we want to store our state, default is "local"
  # backend "s3" specifies that we want to store our state in an S3 bucket
  # Storing in s3 is recommended for production because we can easily share the state
  # with other developers and machines
  backend "s3" {
    bucket = "terraform-state-bucket-iic2173-ayudantia"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
