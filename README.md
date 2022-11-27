# Certified Kubernetes Application Developer Infrastructure

This Terraform repository was created to automatically provision the infrastructure required to complete labs offered by The Linux Foundation: Kubernetes for Developers (LFD259). 

In order to use this repository, you must first install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli), the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), and [create a named profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-profiles).

## Instructions
Create a file named `terraform.tfvars` in the root of this repository, and populate it with [input variable](variables.tf) values.
Here is an example of what the file could look like:
```markdown
profile = "account"
region = "us-west-2"
lab_solution_url = "https://training.linuxfoundation.org/cm/LFD259/LFD259_V2022-11-23_SOLUTIONS.tar.xz"
lab_solution_username = "XXXXXX"
lab_solution_password = "XXXXXX"
enable_registry = true
```

To provision the infrastructure, run `terraform apply -auto-approve`.
When you are finished and no longer need the infrastructure, run `terraform destroy -auto-approve`.

On average, it takes the control plane less than 4 minutes to fully provision, and the worker node less than 2 minutes.

## Troubleshooting
The module will output the commands required to SSH into the worker and controlPlane nodes.
Once connected, you can review the cloud-init logs to determine when the scripts finish running, and whether an error occurred.
```shell
tail -f /var/log/cloud-init-output.log
```

Verify whether the cluster is operational by running `kubectl get nodes` on the controlPlane.
Both nodes should be in a "Ready" state.

The `cloudinit_config` [output values](outputs.tf) show what is being passed to cloud-init.
Alternatively, the generated cloud-init scripts can be found on the server in the `/var/lib/cloud/instance/scripts` directory.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                     | Version  |
|--------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.3.3 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | ~> 4.26  |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement_cloudinit) | ~> 2.2   |
| <a name="requirement_local"></a> [local](#requirement_local)             | ~> 2.2   |
| <a name="requirement_tls"></a> [tls](#requirement_tls)                   | ~> 3.3   |

## Providers

| Name                                                               | Version |
|--------------------------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws)                   | 4.26.0  |
| <a name="provider_cloudinit"></a> [cloudinit](#provider_cloudinit) | 2.2.0   |
| <a name="provider_local"></a> [local](#provider_local)             | 2.2.3   |
| <a name="provider_tls"></a> [tls](#provider_tls)                   | 3.3.0   |

## Modules

| Name                                                                          | Source                   | Version |
|-------------------------------------------------------------------------------|--------------------------|---------|
| <a name="module_control_plane"></a> [control_plane](#module_control_plane)    | ./modules/ec2            | n/a     |
| <a name="module_infrastructure"></a> [infrastructure](#module_infrastructure) | ./modules/infrastructure | n/a     |
| <a name="module_worker_node"></a> [worker_node](#module_worker_node)          | ./modules/ec2            | n/a     |

## Resources

| Name                                                                                                                          | Type        |
|-------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)                      | resource    |
| [local_sensitive_file.pem_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource    |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)                | resource    |
| [cloudinit_config.controlPlane](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config)  | data source |
| [cloudinit_config.workerNode](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config)    | data source |

## Inputs

| Name                                                                                             | Description                                                          | Type     | Default | Required |
|--------------------------------------------------------------------------------------------------|----------------------------------------------------------------------|----------|---------|:--------:|
| <a name="input_enable_registry"></a> [enable_registry](#input_enable_registry)                   | Whether or not to automatically configure a local registry (Lab 3.2) | `bool`   | `false` |    no    |
| <a name="input_lab_solution_password"></a> [lab_solution_password](#input_lab_solution_password) | Password to access the lab solution archive.                         | `string` | n/a     |   yes    |
| <a name="input_lab_solution_url"></a> [lab_solution_url](#input_lab_solution_url)                | URL to the lab solution archive.                                     | `string` | n/a     |   yes    |
| <a name="input_lab_solution_username"></a> [lab_solution_username](#input_lab_solution_username) | Username to access the lab solution archive.                         | `string` | n/a     |   yes    |
| <a name="input_profile"></a> [profile](#input_profile)                                           | Profile name for AWS provider authentication.                        | `string` | n/a     |   yes    |
| <a name="input_region"></a> [region](#input_region)                                              | Default region for AWS provider.                                     | `string` | n/a     |   yes    |

## Outputs

| Name                                                                                                                       | Description                                               |
|----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| <a name="output_cloudinit_config_controlPlane"></a> [cloudinit_config_controlPlane](#output_cloudinit_config_controlPlane) | Cloud-init config for the Control Plane                   |
| <a name="output_cloudinit_config_workerNode"></a> [cloudinit_config_workerNode](#output_cloudinit_config_workerNode)       | Cloud-init config for the Worker Node                     |
| <a name="output_ssh_control_plane"></a> [ssh_control_plane](#output_ssh_control_plane)                                     | Command to SSH into the Control Plane using its Public IP |
| <a name="output_ssh_worker_node"></a> [ssh_worker_node](#output_ssh_worker_node)                                           | Command to SSH into the Worker Node using its Public IP   |
<!-- END_TF_DOCS -->