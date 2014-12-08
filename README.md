Ansible role to install the Consul.io Service discovery and clustering framework (http://consul.io). The role targets linux, and aims to be as generic as possible, avoiding package managers, installing to '/opt' and optionally using the supervisord process manager to control the service.

ansible-galaxy install -p <your_roles> sgargan.consul

The role can be used to install either the server or the agent. It installs the agent by default, and the server by setting the consul_server flag to true when calling role

```yaml
- hosts: consul_agents
  sudo: true

  role:
    - sgargan.consul
```

```yaml
- hosts: consul_servers
  sudo: true

  role:
    - {role: sgargan.consul, consul_server: true}
```

Bootstrapping
-------------

Note that by default when creating a server cluster you need to have the servers to elect a leader until all the servers are ready. This is called bootstrapping and can be read about in detail [here](https://consul.io/docs/guides/bootstrapping.html).

To bootstrap the servers you pass a group of servers to the role as it is being applied, usually this will be the group that the role is being run against e.g. consul_servers. This consul_join group is passed as follows.

```yaml
- hosts: consul_servers
  sudo: true

  role:
    - {role: sgargan.consul, consul_server: true, consul_join: '{{groups["consul_servers"]}}'}
```

Consul will expect the number of servers in the supplied group to join the cluster and will wait to beging the leader election until at least that many servers have joined.

Joining
-------

For the agent role this consul_join can be used to supply the list of servers to join when the agent starts e.g.

```yaml
- hosts: consul_agents
  sudo: true

  role:
    - {role: sgargan.consul, , consul_join: ['consul-1.dc1.example.io', 'consul-2.dc1.example.io', 'consul-2.dc1.example.io']}
```

Using Supervisor
----------------

I like to use Supervisor to manage the Consul process lifecycle, the consul role does not have a dependency on supervisor role, so you must apply it yourself. A complimentary Supervisor role can be downloaded from galaxy as follows

```bash
ansible-galaxy install -p <your_roles> sgargan.supervisor
```

To use this in a playbook and have the consul role generate a supervisor config you need to invoke the role and supply the consul_supervisor_enabled flag.

```yaml
- hosts: consul_servers
  sudo: true

  role:
    - {role: sgargan.supervisor}
    - {role: sgargan.consul, consul_server: true, consul_join: '{{groups["consul_servers"]}}', consul_supervisor_enabled: true}
```

For more information on using supervisor see
