output "master_ipv4" {
  value = digitalocean_droplet.k8s-master.ipv4_address
}

output "worker_ipv4" {
  value = digitalocean_droplet.k8s-worker.ipv4_address
}