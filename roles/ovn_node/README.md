## Openshift OVN

Install ovn CNI components on Master and worker nodes.

## Requirements

* Ansible 2.2+
* Centos/ RHEL 7.5+

## Current OVN restrictions when used with OpenShift

* This is Development Preview, not Production, and it will change over time.
* There is no upgrade path. New install only.
* This is limited to a single cluster master
* This is limited to a single cluster network cidr range.
* This is limited to OKD-3.11 (OKD-4.0 will build, install and work differently)

## Key Ansible inventory OVN master configuration parameters

* ``openshift_use_ovn=True``
* ``openshift_use_openshift_sdn=False``
* ``openshift_sdn_network_plugin_name='cni'``

## OVN resources

