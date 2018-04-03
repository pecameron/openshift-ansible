## Openshift openvswitch open virtual network (OVN)

Install ovn CNI components (ovn-controller, ovn-cni) on Master and worker
nodes. 

## Requirements

* Ansible 2.2+
* Centos/ RHEL 7.4+
* Openvswitch 2.8+

## Current Ovn restrictions when used with OpenShift

* Openshift Origin only

## Key Ansible inventory Ovn master configuration parameters

* ``openshift_use_ovn=True``
* ``openshift_use_openshift_sdn=False``
* ``openshift_sdn_network_plugin_name='cni'``

