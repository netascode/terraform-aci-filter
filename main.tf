resource "aci_rest_managed" "vzFilter" {
  dn         = "uni/tn-${var.tenant}/flt-${var.name}"
  class_name = "vzFilter"
  content = {
    name      = var.name
    nameAlias = var.alias
    descr     = var.description
  }
}

resource "aci_rest_managed" "vzEntry" {
  for_each   = { for entry in var.entries : entry.name => entry }
  dn         = "${aci_rest_managed.vzFilter.dn}/e-${each.value.name}"
  class_name = "vzEntry"
  content = {
    name      = each.value.name
    nameAlias = each.value.alias
    descr     = each.value.description
    etherT    = each.value.ethertype
    prot      = contains(["ip", "ipv4", "ipv6", null], each.value.ethertype) ? each.value.protocol : null
    sFromPort = each.value.source_from_port
    sToPort   = each.value.source_to_port
    dFromPort = each.value.destination_from_port
    dToPort   = each.value.destination_to_port
    stateful  = each.value.stateful == true ? "yes" : "no"
  }
}
