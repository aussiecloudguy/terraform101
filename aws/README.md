# AWS Samples

This folder contains a a number of samples for AWS provider that create resources. This sample list is growing:

* Simple VPC with subnets
* IP Address Management 
* VPC With IP Address Management
* Windows Server with Remote Desktop Port opened in Security Group
* Linux Server with SSH Port opened in Security Group

This is an example of a [Terraform](https://www.terraform.io/) file on AWS (Amazon Web Services).

## Requirements

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [AWS (Amazon Web Services)](http://aws.amazon.com/) account.
* It uses the Terraform AWS Provider that interacts with the many resources supported by AWS through its APIs.
* This code was written for Terraform 0.13.x+.
* This code was written for AWS Provider version Terraform 5.86.x+.


## Using the samples

* Configure your AWS access keys.

  **Important:** For security, it is strongly recommend that you use IAM users instead of the root account for AWS access. 

  Setting your credentials for use by Terraform can be done in a number of ways, but here are the recommended approaches:

  * The default credentials file
  
    Set credentials in the AWS credentials profile file on your local system, located at:

    `~/.aws/credentials` on Linux, macOS, or Unix

    `C:\Users\USERNAME\.aws\credentials` on Windows

    This file should contain lines in the following format:

    ```bash
    [default]
    aws_access_key_id = <your_access_key_id>
    aws_secret_access_key = <your_secret_access_key>
    ```
    Substitute your own AWS credentials values for the values `<your_access_key_id>` and `<your_secret_access_key>`.

  * Environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
  
    Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

    To set these variables on Linux, macOS, or Unix, use `export`:

    ```bash
    export AWS_ACCESS_KEY_ID=<your_access_key_id>
    export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    ```

    To set these variables on Windows, use `set`:

    ```bash
    set AWS_ACCESS_KEY_ID=<your_access_key_id>
    set AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
    ```

* Initialize working directory.

  The first command that should be run after writing a new Terraform configuration is the `terraform init` command in order to initialize a working directory containing Terraform configuration files. It is safe to run this command multiple times.

  ```bash
  terraform init
  ```

* Rename the terraform.tfvars.sample file to terraform.tfvars

* Edit the terraform.tfvars file to your liking.

* Validate the changes.

  Run command:

  ```bash
  terraform plan
  ```

* Deploy the changes.

  Run command:

  ```bash
  terraform apply
  ```

* Test the deploy.

  When the `terraform apply` command completes, use the AWS console, you should see the new new VPC, subnets and route table, and all the resources created with the `terraform-example` tag.

* Clean up the resources created.

  When you have finished, run command:

  ```bash
  terraform destroy
  ```

  `NOTE:` like with Cloudformation, terraform cannot destroy a non empty VPC so if resources are created in this VPC from another example terraform deployment or manually they will need to be deleted first.