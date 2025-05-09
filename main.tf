resource "oci_container_instances_container_instance" "container_instance" {

  compartment_id = var.compartment_id

  display_name        = "${var.container_definition.name}-instance"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = var.container_definition.shape.shape

  shape_config {
    ocpus         = var.container_definition.shape.ocpus
    memory_in_gbs = var.container_definition.shape.memory
  }

  # Container configuration
  containers {
    image_url    = var.container_definition.image
    display_name = "${var.container_definition.name}-container"

    environment_variables = var.container_definition.environment_variables

    resource_config {
      vcpus_limit         = var.container_definition.resource.vcpus_limit
      memory_limit_in_gbs = var.container_definition.resource.memory_limit_in_gbs
    }

    /*ports {
      port     = var.container_definition.resource.ports.port
      protocol = var.container_definition.resource.ports.protocol
    }*/

    volume_mounts {
      mount_path  = var.container_definition.volumes.mount_path
      volume_name = var.container_definition.volumes.volume_name
    }

    health_checks {
      # Basic TCP health check
      health_check_type = var.container_definition.health_checks.type
      port              = var.container_definition.health_checks.port
    }

    

    command = var.container_definition.command
  }

  # Volumes for persistent storage
  volumes {
    name        = var.container_definition.volumes.volume_name
    volume_type = "EMPTYDIR"
    #size_in_gbs = var.container_definition.volumes.size_in_gbs
  }

  # Networking configuration
  vnics {
    subnet_id = var.subnet
    #nsg_ids   = [oci_core_network_security_group.redis_nsg.id]
  }

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform",
    "Oracle-Tags.Environment" = var.environment
  }
}