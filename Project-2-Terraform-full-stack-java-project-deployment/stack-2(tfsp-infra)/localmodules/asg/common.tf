#--------------------------
# Instance Key Pair
#-------------------------
resource "aws_key_pair" "tfsp_be_key" {
  key_name   = "tfsp-${var.envname}-key"
  public_key = file("${path.module}/includes/my_pub_key.pub")
}

#-------------------------------------
# IAM Role and Instance Profile
#-------------------------------------

resource "aws_iam_instance_profile" "be_lt_instance_profile" {
  name = "tfsp-${var.envname}-be-instance-profile"
  role = aws_iam_role.tfsp_be_instance_role.name
}