<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name                                             | Version |
|--------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                      | Type        |
|-----------------------------------------------------------------------------------------------------------|-------------|
| [aws_instance.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource    |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)      | data source |

## Inputs

| Name                                                                                       | Description                                    | Type        | Default | Required |
|--------------------------------------------------------------------------------------------|------------------------------------------------|-------------|---------|:--------:|
| <a name="input_aws_key_pair"></a> [aws_key_pair](#input_aws_key_pair)                      | AWS Key Pair                                   | `string`    | n/a     |   yes    |
| <a name="input_aws_security_groups"></a> [aws_security_groups](#input_aws_security_groups) | AWS Security Groups                            | `list(any)` | n/a     |   yes    |
| <a name="input_aws_subnet_id"></a> [aws_subnet_id](#input_aws_subnet_id)                   | AWS Subnet ID                                  | `string`    | n/a     |   yes    |
| <a name="input_cloudinit_config"></a> [cloudinit_config](#input_cloudinit_config)          | cloudinit_config to apply to the Control Plane | `string`    | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                              | Tags                                           | `map(any)`  | `{}`    |    no    |

## Outputs

| Name                                                              | Description                     |
|-------------------------------------------------------------------|---------------------------------|
| <a name="output_private_ip"></a> [private_ip](#output_private_ip) | Private IP for the ec2 instance |
| <a name="output_public_ip"></a> [public_ip](#output_public_ip)    | Public IP for the ec2 instance  |
<!-- END_TF_DOCS -->