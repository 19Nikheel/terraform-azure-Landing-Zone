variable "nic_security_group_association" {
  type = map(object({
    network_interface_id      = string
    network_security_group_id = string
  }))
}