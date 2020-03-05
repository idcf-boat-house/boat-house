template {
  source      = "/etc/container.d/templates/consul-template/10-container.hcl.ctmpl"
  destination = "/etc/container.d/conf-services.d/10-container.hcl"
  perms       = 0644
}

template {
  source      = "/etc/container.d/templates/container/service.json.ctmpl"
  destination = "/var/run/container/service.json"
  perms       = 0644
}

template {
  source      = "/etc/container.d/templates/container/check.json.ctmpl"
  destination = "/var/run/container/check.json"
  perms       = 0644
}
