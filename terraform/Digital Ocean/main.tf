terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Create a new Droplet 
resource "digitalocean_droplet" "k8s-master" {
  image    = var.image
  name     = "k8s-master"
  region   = var.region
  size     = var.master_size
  ssh_keys = var.ssh_keys
}

resource "digitalocean_droplet" "k8s-worker" {
  image    = var.image
  name     = "k8s-worker"
  region   = var.region
  size     = var.worker_size
  ssh_keys = var.ssh_keys
}

