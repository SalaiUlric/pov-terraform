data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  local_network_cidr_block = ["${chomp(data.http.my_ip.response_body)}/32"]
}