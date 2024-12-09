# Public IP for Application Gateway
resource "azurerm_public_ip" "gateway" {
  name                = "${var.prefix}-appgw-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = "${var.prefix}-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.environment == "prod" ? "WAF_v2" : "Standard_v2"
    tier     = var.environment == "prod" ? "WAF_v2" : "Standard_v2"
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }

  # Optional SSL Certificate
  dynamic "ssl_certificate" {
    for_each = var.enable_https && var.ssl_certificate_data != null ? [1] : []
    content {
      name     = "ssl-cert"
      data     = var.ssl_certificate_data
      password = var.ssl_certificate_password
    }
  }

  backend_address_pool {
    name = "aks-backend-pool"
  }


  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }


  backend_http_settings {
    name                  = "aks-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "aks-probe"
  }

  # Health probe
  probe {
    name                = "aks-probe"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    path                = "/"
  }


  #Main routing rule
  request_routing_rule {
    name                       = "aks-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "aks-http-settings"
    priority                   = 2
  }

   # WAF configuration (if using WAF_v2 SKU)
  dynamic "waf_configuration" {
    for_each = var.environment == "prod" ? [1] : []
    content {
      enabled                  = true
      firewall_mode            = "Prevention"
      rule_set_type            = "OWASP"
      rule_set_version         = "3.2"
      file_upload_limit_mb     = 100
      max_request_body_size_kb = 128
    }
  }

  tags = var.tags
}

   ## Conditional HTTPS Listener
  #dynamic "http_listener" {
  #  for_each = var.enable_https ? [1] : []
  #  content {
  #    name                           = "https-listener"
  #    frontend_ip_configuration_name = "frontend-ip-config"
  #    frontend_port_name            = "https-port"
  #    protocol                      = "Https"
  #    ssl_certificate_name          = "ssl-cert"
  #  }
  #}

  # HTTP to HTTPS redirect rule
  #request_routing_rule {
  #  name                        = "http-to-https-rule"
  #  rule_type                   = "Basic"
  #  http_listener_name          = "http-listener"
  #  redirect_configuration_name = "http-to-https-redirect"
  #  priority                    = 1
  #}

  # Conditional HTTPS routing rule
  #dynamic "request_routing_rule" {
  #  for_each = var.enable_https ? [1] : []
  #  content {
  #    name                       = "https-rule"
  #    priority                  = 2
  #    rule_type                 = "Basic"
  #    http_listener_name        = "https-listener"
  #    backend_address_pool_name = "aks-backend-pool"
  #    backend_http_settings_name = "aks-http-settings"
  #  }
  #}

  #redirect_configuration {
  #  name                 = "http-to-https-redirect"
  #  redirect_type        = "Permanent"
  #  target_listener_name = "https-listener"
  #  include_path         = true
  #  include_query_string = true
  #}

