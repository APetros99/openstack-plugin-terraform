provider "openstack" {
  auth_url    = "http://127.0.0.1/identity"
  user_name   = "admin"
  tenant_name = "admin"
  password    = "secret"
  domain_name = "Default"
}

resource "openstack_compute_instance_v2" "example_instance" {
  name            = "example-instance"
  image_name      = "cirros"
  flavor_name     = "m1.tiny"
  network {
    name = "public"
  }
}
