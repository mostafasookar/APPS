locals {
  name = var.name
  tags = merge({ Module = "efs" }, var.tags)
}
