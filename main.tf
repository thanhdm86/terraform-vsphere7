#===============================================================================
# vSphere Provider
#===============================================================================

provider "vsphere" {

  vsphere_server = "${var.vsphere_vcenter}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}

#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vm_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#===============================================================================
# vSphere Resources
#===============================================================================

resource "vsphere_virtual_machine" "vmmaster" {
  count            = 1
  name             = "master-${count.index}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.vm_cpu}"
  memory   = "${var.vm_ram}"
  guest_id = "ubuntu64Guest"


  disk {
    label            = "master-${count.index}.vmdk"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}" 
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  cdrom {
    client_device = true
  }
  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    }
 
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
     
      linux_options {
        host_name = "master-${count.index}"
        domain    = "test.local"
      }

      network_interface {
        ipv4_address = "192.168.3.${200 + count.index}" 
        ipv4_netmask = "${var.vm_netmask}"
      }

      ipv4_gateway    = "${var.vm_gateway}"
      dns_server_list = ["${var.vm_dns}"]
    }
  }
  provisioner "file" {
    source      = "install-k8s.sh"
    destination = "/tmp/install-k8s.sh"
    

      connection {
          host          = "192.168.3.${200 + count.index}"
          type          = "ssh"
          user          = "root"
          password      = " "
      }
  }
  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/install-k8s.sh",
        "bash /tmp/install-k8s.sh",
      ]
      connection {
        host          = "192.168.3.${200 + count.index}"
        type          = "ssh"
        user          = "root"
        password      = " "
      }
    }
}


