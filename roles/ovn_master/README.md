# OVN (Master)

Configure OVN components for the Master host.

## Requirements

* Ansible 2.2

## Installation

To install, set the following inventory configuration parameters:
* `openshift_use_ovn=True`
* `openshift_use_openshift_sdn=False`
* `openshift_sdn_network_plugin_name='cni'`


## Upgrading

ovn 3.1 cannot be upgraded

