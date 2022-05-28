variable "tenancy_ocid" {
  description = "OCID of the Tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the User the API Key belongs to"
  type        = string
}

variable "private_key_path" {
  description = "The path the where the private key is stored"
  type        = string

  default = "./oci.pem"
}

variable "key_fingerprint" {
  description = "Fingerprint for the key pair"
  type        = string
}

variable "region" {
  description = "The OCI Region of the Tenancy"
  type        = string
}

variable "availability_domain" {
  description = "The availability domain to deploy into"
  type        = number

  default = 0
}

variable "project_name" {
  description = "The name of the project"
  type        = string

  default = "oracle-cloud-kubernetes"
}

variable "vcn_cidr" {
  description = "CIDR Block for the VCN"
  type        = string

  default = "10.0.0.0/16"
}

variable "kubernetes_subnet_cidr" {
  description = "CIDR Block for the Kubernetes subnet"
  type        = string

  default = "10.0.0.0/24"
}

variable "worker_count" {
  description = "The number of worker instances required"
  type        = number

  default = 3
}

variable "instance_shape" {
  description = "The shape of the instance being created"
  type        = string

  default = "VM.Standard.A1.Flex"
}

variable "instance_cpu" {
  description = "The number of CPUs given to each instance (out of the 4 available on free tier)"
  type        = number

  default = 1
}

variable "instance_memory" {
  description = "The amount of memory given to each instance (out of the 24gb available)"
  type        = number

  default = 6
}
