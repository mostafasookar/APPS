#!/bin/bash
{
  # GitHub Workflows
  echo "### .github/workflows/checks.yml ###"; cat .github/workflows/checks.yml;
  echo -e "\n### .github/workflows/deploy.yml ###"; cat .github/workflows/deploy.yml;
  echo -e "\n### .github/workflows/destroy.yml ###"; cat .github/workflows/destroy.yml;
  echo -e "\n### .github/workflows/test-and-lint.yml ###"; cat .github/workflows/test-and-lint.yml;

  # Terraform Directory
  echo -e "\n### terraform/backend.tf ###"; cat terraform/backend.tf;
  echo -e "\n### terraform/locals.tf ###"; cat terraform/locals.tf;
  echo -e "\n### terraform/main.tf ###"; cat terraform/main.tf;
  echo -e "\n### terraform/outputs.tf ###"; cat terraform/outputs.tf;
  echo -e "\n### terraform/variables.tf ###"; cat terraform/variables.tf;
  echo -e "\n### terraform/versions.tf ###"; cat terraform/versions.tf;
  echo -e "\n### terraform/terraform.tfvars ###"; cat terraform/terraform.tfvars;

  # pgadmin Directory
  echo -e "\n### pgadmin/backend.tf ###"; cat pgadmin/backend.tf;
  echo -e "\n### pgadmin/locals.tf ###"; cat pgadmin/locals.tf;
  echo -e "\n### pgadmin/main.tf ###"; cat pgadmin/main.tf;
  echo -e "\n### pgadmin/outputs.tf ###"; cat pgadmin/outputs.tf;
  echo -e "\n### pgadmin/variables.tf ###"; cat pgadmin/variables.tf;
  echo -e "\n### pgadmin/terraform.tfvars ###"; cat pgadmin/terraform.tfvars;

  # marquez Directory
  echo -e "\n### marquez/backend.tf ###"; cat marquez/backend.tf;
  echo -e "\n### marquez/locals.tf ###"; cat marquez/locals.tf;
  echo -e "\n### marquez/main.tf ###"; cat marquez/main.tf;
  echo -e "\n### marquez/outputs.tf ###"; cat marquez/outputs.tf;
  echo -e "\n### marquez/variables.tf ###"; cat marquez/variables.tf;
  echo -e "\n### marquez/terraform.tfvars ###"; cat marquez/terraform.tfvars;

  # APP-modules Directory
  echo -e "\n### APP-modules/alb/locals.tf ###"; cat APP-modules/alb/locals.tf;
  echo -e "\n### APP-modules/alb/main.tf ###"; cat APP-modules/alb/main.tf;
  echo -e "\n### APP-modules/alb/outputs.tf ###"; cat APP-modules/alb/outputs.tf;
  echo -e "\n### APP-modules/alb/variables.tf ###"; cat APP-modules/alb/variables.tf;

  echo -e "\n### APP-modules/autoscaling/locals.tf ###"; cat APP-modules/autoscaling/locals.tf;
  echo -e "\n### APP-modules/autoscaling/main.tf ###"; cat APP-modules/autoscaling/main.tf;
  echo -e "\n### APP-modules/autoscaling/outputs.tf ###"; cat APP-modules/autoscaling/outputs.tf;
  echo -e "\n### APP-modules/autoscaling/variables.tf ###"; cat APP-modules/autoscaling/variables.tf;

  echo -e "\n### APP-modules/cloudwatch/locals.tf ###"; cat APP-modules/cloudwatch/locals.tf;
  echo -e "\n### APP-modules/cloudwatch/main.tf ###"; cat APP-modules/cloudwatch/main.tf;
  echo -e "\n### APP-modules/cloudwatch/outputs.tf ###"; cat APP-modules/cloudwatch/outputs.tf;
  echo -e "\n### APP-modules/cloudwatch/variables.tf ###"; cat APP-modules/cloudwatch/variables.tf;

  echo -e "\n### APP-modules/codedeploy/locals.tf ###"; cat APP-modules/codedeploy/locals.tf;
  echo -e "\n### APP-modules/codedeploy/main.tf ###"; cat APP-modules/codedeploy/main.tf;
  echo -e "\n### APP-modules/codedeploy/outputs.tf ###"; cat APP-modules/codedeploy/outputs.tf;
  echo -e "\n### APP-modules/codedeploy/variables.tf ###"; cat APP-modules/codedeploy/variables.tf;

  echo -e "\n### APP-modules/ecr/locals.tf ###"; cat APP-modules/ecr/locals.tf;
  echo -e "\n### APP-modules/ecr/main.tf ###"; cat APP-modules/ecr/main.tf;
  echo -e "\n### APP-modules/ecr/outputs.tf ###"; cat APP-modules/ecr/outputs.tf;
  echo -e "\n### APP-modules/ecr/variables.tf ###"; cat APP-modules/ecr/variables.tf;

  echo -e "\n### APP-modules/ecs/locals.tf ###"; cat APP-modules/ecs/locals.tf;
  echo -e "\n### APP-modules/ecs/main.tf ###"; cat APP-modules/ecs/main.tf;
  echo -e "\n### APP-modules/ecs/outputs.tf ###"; cat APP-modules/ecs/outputs.tf;
  echo -e "\n### APP-modules/ecs/variables.tf ###"; cat APP-modules/ecs/variables.tf;

  echo -e "\n### APP-modules/efs/locals.tf ###"; cat APP-modules/efs/locals.tf;
  echo -e "\n### APP-modules/efs/main.tf ###"; cat APP-modules/efs/main.tf;
  echo -e "\n### APP-modules/efs/outputs.tf ###"; cat APP-modules/efs/outputs.tf;
  echo -e "\n### APP-modules/efs/variables.tf ###"; cat APP-modules/efs/variables.tf;

  echo -e "\n### APP-modules/iam/locals.tf ###"; cat APP-modules/iam/locals.tf;
  echo -e "\n### APP-modules/iam/main.tf ###"; cat APP-modules/iam/main.tf;
  echo -e "\n### APP-modules/iam/outputs.tf ###"; cat APP-modules/iam/outputs.tf;
  echo -e "\n### APP-modules/iam/variables.tf ###"; cat APP-modules/iam/variables.tf;

  echo -e "\n### APP-modules/secrets/locals.tf ###"; cat APP-modules/secrets/locals.tf;
  echo -e "\n### APP-modules/secrets/main.tf ###"; cat APP-modules/secrets/main.tf;
  echo -e "\n### APP-modules/secrets/outputs.tf ###"; cat APP-modules/secrets/outputs.tf;
  echo -e "\n### APP-modules/secrets/variables.tf ###"; cat APP-modules/secrets/variables.tf;

  echo -e "\n### APP-modules/security_groups/locals.tf ###"; cat APP-modules/security_groups/locals.tf;
  echo -e "\n### APP-modules/security_groups/main.tf ###"; cat APP-modules/security_groups/main.tf;
  echo -e "\n### APP-modules/security_groups/outputs.tf ###"; cat APP-modules/security_groups/outputs.tf;
  echo -e "\n### APP-modules/security_groups/variables.tf ###"; cat APP-modules/security_groups/variables.tf;

  echo -e "\n### APP-modules/service_discovery/locals.tf ###"; cat APP-modules/service_discovery/locals.tf;
  echo -e "\n### APP-modules/service_discovery/main.tf ###"; cat APP-modules/service_discovery/main.tf;
  echo -e "\n### APP-modules/service_discovery/outputs.tf ###"; cat APP-modules/service_discovery/outputs.tf;
  echo -e "\n### APP-modules/service_discovery/variables.tf ###"; cat APP-modules/service_discovery/variables.tf;

  echo -e "\n### APP-modules/vpc_endpoints/locals.tf ###"; cat APP-modules/vpc_endpoints/locals.tf;
  echo -e "\n### APP-modules/vpc_endpoints/main.tf ###"; cat APP-modules/vpc_endpoints/main.tf;
  echo -e "\n### APP-modules/vpc_endpoints/outputs.tf ###"; cat APP-modules/vpc_endpoints/outputs.tf;
  echo -e "\n### APP-modules/vpc_endpoints/variables.tf ###"; cat APP-modules/vpc_endpoints/variables.tf;
} > all_apps_infra_code-06.txt
