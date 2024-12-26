module "roboshop" {
    # source = "../../tarraform-aws-vpc"
    # changing source to git
    source = "git::https://github.com/Pramodcodes/tarraform-aws-vpc.git?ref=main"
    project_name = var.project_name
    project_environment = var.project_environment
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags
    
    # subnet creation
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr = var.database_subnet_cidr
    is_peering_required = var.is_peering_required
}
