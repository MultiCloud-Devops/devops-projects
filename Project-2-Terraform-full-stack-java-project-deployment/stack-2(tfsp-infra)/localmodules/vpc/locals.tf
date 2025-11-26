locals {
  public_subnet_count  = 2
  private_subnet_count = 2

  az_names = data.aws_availability_zones.azs.names
}