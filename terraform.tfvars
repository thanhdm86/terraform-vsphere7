#===============================================================================
# VMware vSphere configuration
#===============================================================================

# vCenter IP or FQDN #
vsphere_vcenter = "192.168.3.100"

# vSphere username used to deploy the infrastructure #
vsphere_user = "administrator@vsphere.local"
vsphere_password = "Hocmai@123456"
# Skip the verification of the vCenter SSL certificate (true/false) #
vsphere_unverified_ssl = "true"

# vSphere datacenter name where the infrastructure will be deployed #
vsphere_datacenter = "DC1"

# vSphere cluster name where the infrastructure will be deployed #
vsphere_cluster = "CL1"

#===============================================================================
# Virtual machine parameters
#===============================================================================

# The name of the virtual machine #
vm_name = "node"

# The datastore name used to store the files of the virtual machine #
vm_datastore = "vsanDatastore"

# The vSphere network name used by the virtual machine #
vm_network = "DSwitch-VM Network"

# The netmask used to configure the network card of the virtual machine (example: 24) #
vm_netmask = "24"

# The network gateway used by the virtual machine #
vm_gateway = "192.168.3.2"

# The DNS server used by the virtual machine #
vm_dns = "8.8.8.8"

# The domain name used by the virtual machine #
vm_domain = "localhost"

# The vSphere template the virtual machine is based on #
vm_template = "ubuntu"

# Use linked clone (true/false)
vm_linked_clone = "false"

# The number of vCPU allocated to the virtual machine #
vm_cpu = "2"

# The amount of RAM allocated to the virtual machine #
vm_ram = "3024"

# The IP address of the virtual machine #
vm_ip = ""