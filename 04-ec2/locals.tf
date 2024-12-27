locals {
    ec2_name = "${var.project_name}-${var.environment}"
    database_subnet_id = element(split(",",data.aws_ssm_parameter.database_subnets_ids.value) , 0)
    #above line will split the stringList sperated by , to list and element() will get 1st element from list 
    # if you dont clealy metion .value you wont get the value since its an object you will see error
    private_subnet_id = element(split(",",data.aws_ssm_parameter.private_subnets_ids.value) , 0)
    public_subnet_id = element(split(",",data.aws_ssm_parameter.public_subnets_ids.value) , 0)

}