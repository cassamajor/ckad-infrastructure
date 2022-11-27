# Lab 2 - Deploy a new cluster

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

| Name                                                                                                                                                        | Type     |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_internet_gateway.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                               | resource |
| [aws_route_table_association.public_route_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.insecure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                   | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                     | resource |
| [aws_vpc.ckad](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                             | resource |

## Inputs

No inputs.

## Outputs

| Name                                                                                   | Description                  |
|----------------------------------------------------------------------------------------|------------------------------|
| <a name="output_name"></a> [name](#output_name)                                        | The name of the VPC          |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id) | The ID of the Security Group |
| <a name="output_subnet_id"></a> [subnet_id](#output_subnet_id)                         | The ID of the public subnet  |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block)          | The CIDR block of the VPC    |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                                  | The ID of the VPC            |
<!-- END_TF_DOCS -->