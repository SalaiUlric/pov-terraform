variable "cluster_name" {
  type        = string
  description = "This is the name of kind cluster"
  default     = "sg-cluster"
}

variable "k8s_image" {
  type        = string
  description = "This is node image of kind cluster"
  default     = "kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f"
}

variable "masternode_count" {
  type        = number
  description = "The number of master nodes"
  default     = 1
}

variable "workernode_count" {
  type        = number
  description = "The number of worker nodes"
  default     = 3
}

variable "pod_subnet" {
  type = string
  description = "Pod Subnets CIDR"
  default = "10.253.0.0/16"
}

variable "service_subnet" {
  type = string
  description = "Service Subnets CIDR"
  default = "10.133.0.0/16"
}