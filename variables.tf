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
