module "network" {
  source = "./modules/network"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "ecr" {
  source = "./modules/ecr"
  name   = "demo-app-new-relic-app"
}

module "monitoring" {
  source       = "./modules/monitoring"
  cluster_name = module.fargate.cluster_name # Passando o nome do cluster do output do fargate
}

module "fargate" {
  source = "./modules/fargate"

  # Passando IDs de rede (corrigidos)
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  security_group_id  = module.security.security_group_id
  ecr_image_url      = "${module.ecr.repository_url}:latest"
  execution_role_arn = module.iam.ecs_execution_role_arn
}



/* # Modulo para atender a etapa 1 e 2
module "compute_ec2" {
  source           = "./modules/compute_ec2"
  subnet_id        = module.network.public_subnet_ids[0] # Usa a primeira subnet pública para o EC2 de teste
  security_group_id = module.security.security_group_id
  instance_profile = module.iam.ec2_instance_profile
  key_name         = "demo-app-new-relic-key"
}
*/
