resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.roboshop.vpc_id
}

# we will get tuple so we will convert into list by using join function vid 32 1:13:13
resource "aws_ssm_parameter" "public_subnets_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnets_ids"
  type  = "StringList"
  value = join(",",module.roboshop.public_subnet_ids)
}
# we did this block for debugging purpose
# output "public_subnet_ids" {
#   value = module.roboshop.public_subnet_ids
# }

# we did this block for debugging purpose
output "private_subnets_ids" {
  value = module.roboshop.private_subnet_ids
}
# observe the variable names carefully
# we are getting private_subnet_ids,database_subnet_ids 
# since these are stringList we are processing them to a list and 
# uploading it into ssm parameters store (name of ssm parameter store variable is plural)
resource "aws_ssm_parameter" "private_subnets_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnets_ids"
  type  = "StringList"
  value = join(",",module.roboshop.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnets_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnets_ids"
  type  = "StringList"
  value = join(",",module.roboshop.database_subnet_ids)
}
