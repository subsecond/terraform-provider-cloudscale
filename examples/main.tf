# Set the variable value in a *.tfvars file or use 
# the -var="cloudscale_token=..." CLI option.
#
# You can omit both the variable and provider if you
# choose to set a shell environment variable called
# `CLOUDSCALE_TOKEN` instead.

variable "cloudscale_token" {}

provider "cloudscale" {
  token = "${var.cloudscale_token}"
}

# Create a new Server
resource "cloudscale_server" "web-worker01" {
  name           = "web-worker01"
  flavor_slug    = "flex-4"
  image_slug     = "debian-9"
  volume_size_gb = 50
  ssh_keys       = ["ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFEepRNW5hDct4AdJ8oYsb4lNP5E9XY5fnz3ZvgNCEv7m48+bhUjJXUPuamWix3zigp2lgJHC6SChI/okJ41GUY="]
}

# Add a Floating IPv4 address to web-worker01
resource "cloudscale_floating_ip" "web-worker01-vip" {
  server      = "${cloudscale_server.web-worker01.id}"
  ip_version  = 4
  reverse_ptr = "vip.web-worker01.example.com"
}

# Add a Floating IPv6 network to web-worker01
resource "cloudscale_floating_ip" "web-worker01-net" {
  server        = "${cloudscale_server.web-worker01.id}"
  ip_version    = 6
  prefix_length = 56
}
