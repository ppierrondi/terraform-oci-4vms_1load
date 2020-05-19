
# This code is auto generated and any changes will be lost if it is regenerated.

terraform {
    required_version = ">= 0.12.0"
}

# -- Copyright: Copyright (c) 2020, Oracle and/or its affiliates.
# ---- Author : [&#39;Andrew Hopkinson (Oracle Cloud Solutions A-Team)&#39;]
# ------ Connect to Provider
provider "oci" {
  version          = ">= 3.64.0" 
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# ------ Retrieve Regional / Cloud Data
# -------- Get a list of Availability Domains
data "oci_identity_availability_domains" "AvailabilityDomains" {
    compartment_id = var.tenancy_ocid
}
data "template_file" "AvailabilityDomainNames" {
    count    = length(data.oci_identity_availability_domains.AvailabilityDomains.availability_domains)
    template = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[count.index]["name"]
}
# -------- Get a list of Fault Domains
data "oci_identity_fault_domains" "FaultDomainsAD1" {
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[0]["name"]
    compartment_id = var.tenancy_ocid
}
data "oci_identity_fault_domains" "FaultDomainsAD2" {
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[1]["name"]
    compartment_id = var.tenancy_ocid
}
data "oci_identity_fault_domains" "FaultDomainsAD3" {
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[2]["name"]
    compartment_id = var.tenancy_ocid
}
# -------- Get Home Region Name
data "oci_identity_region_subscriptions" "RegionSubscriptions" {
    tenancy_id = var.tenancy_ocid
}
locals {
    HomeRegion = [for x in data.oci_identity_region_subscriptions.RegionSubscriptions.region_subscriptions: x if x.is_home_region][0]
}


# ------ Create Compartment - Root True
# ------ Root Compartment
locals {
    Okit_Comp001_id              = var.compartment_ocid
}

output "Okit_Comp001Id" {
    value = local.Okit_Comp001_id
}

# ------ Create Virtual Cloud Network
resource "oci_core_vcn" "Okit_Vcn001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    cidr_block     = var.Okit_Vcn001_cidr_block
    # Optional
    dns_label      = var.Okit_Vcn001_dns_label
    display_name   = var.Okit_Vcn001_display_name
}

locals {
    Okit_Vcn001_id              = oci_core_vcn.Okit_Vcn001.id
    Okit_Vcn001_dhcp_options_id = oci_core_vcn.Okit_Vcn001.default_dhcp_options_id
    Okit_Vcn001_domain_name     = oci_core_vcn.Okit_Vcn001.vcn_domain_name
}


# ------ Create Internet Gateway
resource "oci_core_internet_gateway" "Okit_Ig001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    enabled        = var.Okit_Ig001_enabled
    display_name   = var.Okit_Ig001_display_name
}

locals {
    Okit_Ig001_id = oci_core_internet_gateway.Okit_Ig001.id
}

# ------ Create NAT Gateway
resource "oci_core_nat_gateway" "Okit_Ng001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    display_name   = var.Okit_Ng001_display_name
    block_traffic  = var.Okit_Ng001_block_traffic
}

locals {
    Okit_Ng001_id = oci_core_nat_gateway.Okit_Ng001.id
}

# ------ Create Security List
resource "oci_core_security_list" "Okit_Sl001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    egress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_egress_rule_01_protocol
        destination = var.Okit_Sl001_egress_rule_01_destination
        # Optional
        destination_type  = var.Okit_Sl001_egress_rule_01_destination_type
    }
    ingress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_ingress_rule_01_protocol
        source      = var.Okit_Sl001_ingress_rule_01_source
        # Optional
        source_type  = var.Okit_Sl001_ingress_rule_01_source_type
        tcp_options {
            min = var.Okit_Sl001_ingress_rule_01_tcp_dst_min
            max = var.Okit_Sl001_ingress_rule_01_tcp_dst_max
        }
    }
    ingress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_ingress_rule_02_protocol
        source      = var.Okit_Sl001_ingress_rule_02_source
        # Optional
        source_type  = var.Okit_Sl001_ingress_rule_02_source_type
        icmp_options {
            type = var.Okit_Sl001_ingress_rule_02_icmp_type
            code = var.Okit_Sl001_ingress_rule_02_icmp_code
        }
    }
    ingress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_ingress_rule_03_protocol
        source      = var.Okit_Sl001_ingress_rule_03_source
        # Optional
        source_type  = var.Okit_Sl001_ingress_rule_03_source_type
        # icmp_options {
        #     type = var.Okit_Sl001_ingress_rule_03_icmp_type
        # }
    }
    # Optional
    display_name   = var.Okit_Sl001_display_name
}

locals {
    Okit_Sl001_id = oci_core_security_list.Okit_Sl001.id
}

# ------ Create Security List
resource "oci_core_security_list" "Secuprivate" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    display_name   = var.Secuprivate_display_name
    egress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_egress_rule_01_protocol
        destination = var.Okit_Sl001_egress_rule_01_destination
        # Optional
        destination_type  = var.Okit_Sl001_egress_rule_01_destination_type
    }

    ingress_security_rules {
        # Required
        protocol    = var.Okit_Sl001_ingress_rule_03_protocol
        source      = var.Okit_Sl001_ingress_rule_03_source
        # Optional
        source_type  = var.Okit_Sl001_ingress_rule_03_source_type
        # icmp_options {
        #     type = var.Okit_Sl001_ingress_rule_03_icmp_type
        # }
    }
}

locals {
    Secuprivate_id = oci_core_security_list.Secuprivate.id
}

# ------ Create Route Table
resource "oci_core_route_table" "Okit_Rt001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    route_rules    {
        destination       = var.Okit_Rt001_route_rule_01_destination
        destination_type  = var.Okit_Rt001_route_rule_01_destination_type
        network_entity_id = local.Okit_Ig001_id
        description       = var.Okit_Rt001_route_rule_01_description
    }
    # Optional
    display_name   = var.Okit_Rt001_display_name
}

locals {
    Okit_Rt001_id = oci_core_route_table.Okit_Rt001.id
}

# ------ Create Route Table
resource "oci_core_route_table" "Okit_Rt002" {
    # Required
    compartment_id = local.Okit_Comp001_id
    vcn_id         = local.Okit_Vcn001_id
    route_rules    {
        destination       = var.Okit_Rt002_route_rule_01_destination
        destination_type  = var.Okit_Rt002_route_rule_01_destination_type
        network_entity_id = local.Okit_Ng001_id
        description       = var.Okit_Rt002_route_rule_01_description
    }
    # Optional
    display_name   = var.Okit_Rt002_display_name
}

locals {
    Okit_Rt002_id = oci_core_route_table.Okit_Rt002.id
}

# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Okit_Sn001" {
    # Required
    compartment_id             = local.Okit_Comp001_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.Okit_Sn001_cidr_block
    # Optional
    display_name               = var.Okit_Sn001_display_name
    dns_label                  = var.Okit_Sn001_dns_label
    security_list_ids          = [local.Okit_Sl001_id,local.Secuprivate_id]
    route_table_id             = local.Okit_Rt001_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = var.Okit_Sn001_prohibit_public_ip_on_vnic
}

locals {
    Okit_Sn001_id              = oci_core_subnet.Okit_Sn001.id
    Okit_Sn001_domain_name     = oci_core_subnet.Okit_Sn001.subnet_domain_name
}

# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Subprivate" {
    # Required
    compartment_id             = local.Okit_Comp001_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.Subprivate_cidr_block
    # Optional
    display_name               = var.Subprivate_display_name
    dns_label                  = var.Subprivate_dns_label
    security_list_ids          = [local.Okit_Sl001_id,local.Secuprivate_id]
    route_table_id             = local.Okit_Rt002_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = var.Subprivate_prohibit_public_ip_on_vnic
}

locals {
    Subprivate_id              = oci_core_subnet.Subprivate.id
    Subprivate_domain_name     = oci_core_subnet.Subprivate.subnet_domain_name
}

# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Okit_Sn003" {
    # Required
    compartment_id             = local.Okit_Comp001_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.Okit_Sn003_cidr_block
    # Optional
    display_name               = var.Okit_Sn003_display_name
    dns_label                  = var.Okit_Sn003_dns_label
    security_list_ids          = [local.Okit_Sl001_id,local.Secuprivate_id]
    route_table_id             = local.Okit_Rt001_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = var.Okit_Sn003_prohibit_public_ip_on_vnic
}

locals {
    Okit_Sn003_id              = oci_core_subnet.Okit_Sn003.id
    Okit_Sn003_domain_name     = oci_core_subnet.Okit_Sn003.subnet_domain_name
}

# ------ Get List OL7 Images
data "oci_core_images" "Okit_In001Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = var.Okit_In001_os
    operating_system_version = var.Okit_In001_os_version
    shape                    = var.Okit_In001_shape
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In001" {
    # Required
    compartment_id      = local.Okit_Comp001_id
    shape               = var.Okit_In001_shape
    # Optional
    display_name        = var.Okit_In001_display_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[var.Okit_In001_availability_domain - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Okit_Sn001_id
        # Optional
        assign_public_ip = var.Okit_In001_primary_vnic_assign_public
        display_name     = var.Okit_In001_display_name_vnic
        hostname_label   = var.Okit_In001_hostname_label
        skip_source_dest_check = var.Okit_In001_primary_vnic_skip_src_dst_check
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    fault_domain = var.Okit_In001_fault_domain
    metadata = {
        ssh_authorized_keys = var.Okit_In001_authorized_keys
        user_data           = base64encode(var.Okit_In001_user_data)
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In001Images.images[0]["id"]
        source_type             = var.Okit_In001_source_type
        # Optional
        boot_volume_size_in_gbs = var.Okit_In001_boot_volume_size_in_gbs
#        kms_key_id              = 
    }
    preserve_boot_volume = var.Okit_In001_preserve_boot_volume
}

locals {
    Okit_In001_id            = oci_core_instance.Okit_In001.id
    Okit_In001_public_ip     = oci_core_instance.Okit_In001.public_ip
    Okit_In001_private_ip    = oci_core_instance.Okit_In001.private_ip
}

output "okit-in001PublicIP" {
    value = local.Okit_In001_public_ip
}

output "okit-in001PrivateIP" {
    value = local.Okit_In001_private_ip
}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments


# ------ Get List OL7 Images
data "oci_core_images" "Okit_In002Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = var.Okit_In002_os
    operating_system_version = var.Okit_In002_os_version
    shape                    = var.Okit_In002_shape
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In002" {
    # Required
    compartment_id      = local.Okit_Comp001_id
    shape               = var.Okit_In002_shape
    # Optional
    display_name        = var.Okit_In002_display_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[var.Okit_In002_availability_domain - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Okit_Sn001_id
        # Optional
        assign_public_ip = var.Okit_In002_primary_vnic_assign_public
        display_name     = var.Okit_In002_display_name_vnic
        hostname_label   = var.Okit_In002_hostname_label
        skip_source_dest_check = var.Okit_In002_primary_vnic_skip_src_dst_check
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    fault_domain = var.Okit_In002_fault_domain
    metadata = {
        ssh_authorized_keys = var.Okit_In002_authorized_keys
        user_data           = base64encode(var.Okit_In002_user_data)
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In002Images.images[0]["id"]
        source_type             = var.Okit_In002_source_type
        # Optional
        boot_volume_size_in_gbs = var.Okit_In002_boot_volume_size_in_gbs
#        kms_key_id              = 
    }
    preserve_boot_volume = var.Okit_In002_preserve_boot_volume
}

locals {
    Okit_In002_id            = oci_core_instance.Okit_In002.id
    Okit_In002_public_ip     = oci_core_instance.Okit_In002.public_ip
    Okit_In002_private_ip    = oci_core_instance.Okit_In002.private_ip
}

output "okit-in002PublicIP" {
    value = local.Okit_In002_public_ip
}

output "okit-in002PrivateIP" {
    value = local.Okit_In002_private_ip
}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments


# ------ Get List OL7 Images
data "oci_core_images" "Okit_In003Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = var.Okit_In003_os
    operating_system_version = var.Okit_In003_os_version
    shape                    = var.Okit_In003_shape
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In003" {
    # Required
    compartment_id      = local.Okit_Comp001_id
    shape               = var.Okit_In003_shape
    # Optional
    display_name        = var.Okit_In003_display_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[var.Okit_In003_availability_domain - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Okit_Sn001_id
        # Optional
        assign_public_ip = var.Okit_In003_primary_vnic_assign_public
        display_name     = var.Okit_In003_display_name_vnic
        hostname_label   = var.Okit_In003_hostname_label
        skip_source_dest_check = var.Okit_In003_primary_vnic_skip_src_dst_check
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    fault_domain = var.Okit_In003_fault_domain
    metadata = {
        ssh_authorized_keys = var.Okit_In003_authorized_keys
        user_data           = base64encode(var.Okit_In003_user_data)
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In003Images.images[0]["id"]
        source_type             = var.Okit_In003_source_type
        # Optional
        boot_volume_size_in_gbs = var.Okit_In003_boot_volume_size_in_gbs
#        kms_key_id              = 
    }
    preserve_boot_volume = var.Okit_In003_preserve_boot_volume
}

locals {
    Okit_In003_id            = oci_core_instance.Okit_In003.id
    Okit_In003_public_ip     = oci_core_instance.Okit_In003.public_ip
    Okit_In003_private_ip    = oci_core_instance.Okit_In003.private_ip
}

output "okit-in003PublicIP" {
    value = local.Okit_In003_public_ip
}

output "okit-in003PrivateIP" {
    value = local.Okit_In003_private_ip
}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments


# ------ Get List OL7 Images
data "oci_core_images" "Okit_In004Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = var.Okit_In004_os
    operating_system_version = var.Okit_In004_os_version
    shape                    = var.Okit_In004_shape
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In004" {
    # Required
    compartment_id      = local.Okit_Comp001_id
    shape               = var.Okit_In004_shape
    # Optional
    display_name        = var.Okit_In004_display_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[var.Okit_In004_availability_domain - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Subprivate_id
        # Optional
        assign_public_ip = var.Okit_In004_primary_vnic_assign_public
        display_name     = var.Okit_In004_display_name_vnic
        hostname_label   = var.Okit_In004_hostname_label
        skip_source_dest_check = var.Okit_In004_primary_vnic_skip_src_dst_check
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    fault_domain = var.Okit_In004_fault_domain
    metadata = {
        ssh_authorized_keys = var.Okit_In004_authorized_keys
        user_data           = base64encode(var.Okit_In004_user_data)
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In004Images.images[0]["id"]
        source_type             = var.Okit_In004_source_type
        # Optional
        boot_volume_size_in_gbs = var.Okit_In004_boot_volume_size_in_gbs
#        kms_key_id              = 
    }
    preserve_boot_volume = var.Okit_In004_preserve_boot_volume
}

locals {
    Okit_In004_id            = oci_core_instance.Okit_In004.id
    Okit_In004_public_ip     = oci_core_instance.Okit_In004.public_ip
    Okit_In004_private_ip    = oci_core_instance.Okit_In004.private_ip
}

output "okit-in004PublicIP" {
    value = local.Okit_In004_public_ip
}

output "okit-in004PrivateIP" {
    value = local.Okit_In004_private_ip
}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments


# ------ Create Loadbalancer
resource "oci_load_balancer_load_balancer" "Okit_Lb001" {
    # Required
    compartment_id = local.Okit_Comp001_id
    shape          = var.Okit_Lb001_shape
    display_name   = var.Okit_Lb001_display_name
    subnet_ids     = [
                    local.Okit_Sn003_id                    ]
    # Optional
    is_private     = false
}

locals {
    Okit_Lb001_id            = oci_load_balancer_load_balancer.Okit_Lb001.id
    Okit_Lb001_ip_address    = oci_load_balancer_load_balancer.Okit_Lb001.ip_address_details[0]["ip_address"]
    Okit_Lb001_url           = format("http://%s", oci_load_balancer_load_balancer.Okit_Lb001.ip_address_details[0]["ip_address"])
}

output "okit-lb001IPAddress" {
    value = local.Okit_Lb001_ip_address
}

output "okit-lb001URL" {
    value = format("http://%s", local.Okit_Lb001_ip_address)
}

locals {
    Okit_Lb001_backend_set_name = "Okit_Lb001BackendSet"
    Okit_Lb001_listener_name    = "Okit_Lb001Listener"
}

# ------ Create Loadbalancer Backend Set
resource "oci_load_balancer_backend_set" "Okit_Lb001BackendSet" {
    # Required
    health_checker {
        # Required
        protocol            = var.Okit_Lb001_protocol
        # Optional
        interval_ms         = 1000
        port                = 80
#        response_body_regex = 
#        retries             = 100
#        return_code         = 200
#        timeout_in_millis   = 3000
        url_path            = var.Okit_Lb001_url_path
    }
    load_balancer_id = local.Okit_Lb001_id
    name             = substr(local.Okit_Lb001_backend_set_name, 0, 32)
    policy           = var.Okit_Lb001_backend_policy
}

locals {
    Okit_Lb001BackendSet_id   = oci_load_balancer_backend_set.Okit_Lb001BackendSet.id
    Okit_Lb001BackendSet_name = oci_load_balancer_backend_set.Okit_Lb001BackendSet.name
}

# ------ Create Loadbalancer Backend
resource "oci_load_balancer_backend" "Okit_Lb001Backend1" {
    # Required
    backendset_name  = local.Okit_Lb001BackendSet_name
    ip_address       = local.Okit_In001_private_ip
    load_balancer_id = local.Okit_Lb001_id
    port             = 80
    # Optional
#    backup           = 
#    drain            = 
#    offline          = 
#    weight           = 
}
resource "oci_load_balancer_backend" "Okit_Lb001Backend2" {
    # Required
    backendset_name  = local.Okit_Lb001BackendSet_name
    ip_address       = local.Okit_In002_private_ip
    load_balancer_id = local.Okit_Lb001_id
    port             = 80
    # Optional
#    backup           = 
#    drain            = 
#    offline          = 
#    weight           = 
}
resource "oci_load_balancer_backend" "Okit_Lb001Backend3" {
    # Required
    backendset_name  = local.Okit_Lb001BackendSet_name
    ip_address       = local.Okit_In003_private_ip
    load_balancer_id = local.Okit_Lb001_id
    port             = 80
    # Optional
#    backup           = 
#    drain            = 
#    offline          = 
#    weight           = 
}
resource "oci_load_balancer_backend" "Okit_Lb001Backend4" {
    # Required
    backendset_name  = local.Okit_Lb001BackendSet_name
    ip_address       = local.Okit_In004_private_ip
    load_balancer_id = local.Okit_Lb001_id
    port             = 80
    # Optional
#    backup           = 
#    drain            = 
#    offline          = 
#    weight           = 
}

# ------ Create Loadbalancer Listener
resource "oci_load_balancer_listener" "Okit_Lb001Listener" {
    # Required
    default_backend_set_name = local.Okit_Lb001BackendSet_name
    load_balancer_id         = local.Okit_Lb001_id
    name                     = substr(local.Okit_Lb001_listener_name, 0, 32)
    port                     = 80
    protocol                 = var.Okit_Lb001_protocol
    # Optional
    connection_configuration {
        # Required
        idle_timeout_in_seconds = 1200
    }
#    hostname_names           = []
#    path_route_set_name      = 
#    rule_set_names           = []
#    ssl_configuration {
#        # Required
#        certificate_name        = 
#        # Optional
#        verify_depth            = 
#        verify_peer_certificate = 
#    }
}

locals {
    Okit_Lb001Listener_id            = oci_load_balancer_listener.Okit_Lb001Listener.id
}

# # ----Install apache and open port 80

# resource "null_resource" "ppWebserver1_ConfigMgmt"{
#   depends_on = [oci_core_instance.Okit_In001]

 
#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "opc"
#       host        = local.Okit_In001_public_ip
#       private_key = "${var.ssh_private_key}"
#       script_path = "/home/opc/myssh.sh"
#       agent       = false
#       timeout     = "10m"
#     }
#     inline = ["echo '== 1. Install Oracle instant client'",
#       "sudo -u root yum -y install oracle-release-el7",
#       "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
#       "sudo -u root yum -y install oracle-instantclient18.3-basic",

#       "echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'",
#       "sudo -u root yum install -y python36",
#       "sudo -u root pip3 install cx_Oracle",
#       "sudo -u root pip3 install flask",

#       "echo '== 3. Disabling firewall and starting HTTPD service'",
#     "echo '== 4. Webservice Install'",
#     "sudo -u root yum install httpd -y",
#     "sudo -u root apachectl start",
#     "sudo -u root systemctl enable httpd",
#     "sudo -u root sudo firewall-cmd --permanent --zone=public --add-port=80/tcp",
#     "sudo -u root sudo firewall-cmd --reload"
#     ]
#   }
#     provisioner "file" {
#       connection {
#       type        = "ssh"
#       user        = "opc"
#       host        = local.Okit_In001_public_ip
#       private_key = "${var.ssh_private_key}"
#       script_path = "/home/opc/myssh.sh"
#       agent       = false
#       timeout     = "10m"
#     }
#     source     = "index.html"
#     destination = "/tmp/index.html"
#   }

#   }
#   resource "null_resource" "ppWebserver1_File"{
#       depends_on = [null_resource.ppWebserver1_ConfigMgmt]
#  provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "opc"
#       host        = local.Okit_In001_public_ip
#       private_key = "${var.ssh_private_key}"
#       script_path = "/home/opc/myssh.sh"
#       agent       = false
#       timeout     = "10m"
#     }
#     inline = ["echo '== 6.finishing file'",
#      "sudo sed -i ${local.Okit_In001_public_ip} > /tmp/index.html",
#       "sudo -u root cp /tmp/index.html /var/www/html/",
#       "sudo -u root apachectl start",
#         "sudo -u root systemctl enable httpd"
#       ]
#   }

# }

# resource "null_resource" "ppWebserver1_ConfigMgmt2" {
#   depends_on = [oci_core_instance.Okit_In002]

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "opc"
#       host        = local.Okit_In002_public_ip
#       private_key = "${var.ssh_private_key}"
#       script_path = "/home/opc/myssh.sh"
#       agent       = false
#       timeout     = "10m"
#     }
#     inline = ["echo '== 1. Install Oracle instant client'",
#       "sudo -u root yum -y install oracle-release-el7",
#       "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
#       "sudo -u root yum -y install oracle-instantclient18.3-basic",

#       "echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'",
#       "sudo -u root yum install -y python36",
#       "sudo -u root pip3 install cx_Oracle",
#       "sudo -u root pip3 install flask",

#       "echo '== 3. Disabling firewall and starting HTTPD service'",
#     "echo '== 4. Webservice Install'",
#     "sudo -u root yum install httpd -y",
#     "sudo -u root apachectl start",
#     "sudo -u root systemctl enable httpd",
#     "sudo -u root sudo firewall-cmd --permanent --zone=public --add-port=80/tcp",
#     "sudo -u root sudo firewall-cmd --reload"   
#     ]
#   }
# }

# resource "null_resource" "ppWebserver1_ConfigMgmt3" {
#   depends_on = [oci_core_instance.Okit_In003]

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "opc"
#       host        = local.Okit_In003_public_ip
#       private_key = "${var.ssh_private_key}"
#       script_path = "/home/opc/myssh.sh"
#       agent       = false
#       timeout     = "10m"
#     }
#     inline = ["echo '== 1. Install Oracle instant client'",
#       "sudo -u root yum -y install oracle-release-el7",
#       "sudo -u root yum-config-manager --enable ol7_oracle_instantclient",
#       "sudo -u root yum -y install oracle-instantclient18.3-basic",

#       "echo '== 2. Install Python3, and then with pip3 cx_Oracle and flask'",
#       "sudo -u root yum install -y python36",
#       "sudo -u root pip3 install cx_Oracle",
#       "sudo -u root pip3 install flask",

#       "echo '== 3. Disabling firewall and starting HTTPD service'",
#     "echo '== 4. Webservice Install'",
#     "sudo -u root yum install httpd -y",
#     "sudo -u root apachectl start",
#     "sudo -u root systemctl enable httpd",
#     "sudo -u root sudo firewall-cmd --permanent --zone=public --add-port=80/tcp",
#     "sudo -u root sudo firewall-cmd --reload"   
#     ]
#   }
# }