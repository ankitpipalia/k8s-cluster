variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  default = "dop_v1_9826a01756ec072d085450b1dfa0dfe5c10096d40eb57023a51f37ef8b40777d"
}

variable "ssh_keys" {
  description = "List of SSH key IDs to enable on the droplets"
  type        = list(string)
  default = [ "38756587", "38553604" ]
}

variable "region" {
  description = "Region where the droplets will be created"
  type        = string
  default     = "blr1"
}

variable "image" {
  description = "Image ID to use for the droplets"
  type        = string
  default     = "135996681"
}

variable "master_size" {
  description = "Size of the master droplet"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "worker_size" {
  description = "Size of the worker droplet"
  type        = string
  default     = "s-2vcpu-4gb"
}