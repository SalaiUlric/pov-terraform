module "cluster133" {
#   source = "../../"
  source = "git::https://gitlab.com/sailinnthu/terraform-kindcluster.git?ref=feature/v4"

  cluster_name     = var.cluster_name
  k8s_image        = var.k8s_image
  masternode_count = var.masternode_count
  workernode_count = var.workernode_count
  pod_subnet       = var.pod_subnet
  service_subnet   = var.service_subnet
}
