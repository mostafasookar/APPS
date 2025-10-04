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
} > all_apps_infra_code-02.txt
