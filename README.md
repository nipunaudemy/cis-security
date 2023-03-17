# cis_security

A role to implement Center for Internet Security (CIS) controls for RHEL (7-8) and RHEL clones (Oracle, CentOS), recent Fedora (31-32), SLES 15, and Ubuntu 18.04 / 20.04 LTS and certain Windows servers.

### Introduction

The [Center for Internet Security](https://www.cisecurity.org/) provides a set of
security benchmarks for operating systems designed to decrease the vulnerability vectors of a system.

These benchmarks are published in PDFs for non-commercial use. This role is an implementation of
those controls for various Operating Systems per the list below. The controls themselves are not published here and
you should visit CIS for a copy of the PDF. These automations are provided as a resposne and a tool to
help systems administrators secure machines based off those recommendations. This collection is not
endorsed by the Center for Internet Security in any way.

This collection contains a role that is designed to layer under other Ansible roles that install software packages, users, etc. It should be idempotent and can be run at any time. As usual with Ansible, make sure that later playbooks don't modify
files that are modified in this role.

Benchmark Versions:
| Operating System | OS Benchmark version |
| -----------------|--------------------- |
| RHEL 7 | v2.2.0 |
| RHEL 8 | v1.0.1 |
| CentOS 7 | v2.2.0 |
| CentOS 8 | v1.0.0 |
| Fedora 31 | \(Fedora 28\) v1.1.0 |
| Fedora 32 | \(Fedora 28\) v1.1.0 |
| Oracle Linux 7 | v2.2.0 |
| Oracle Linux 8 | v1.0.0 |
| SUSE Linux Enterprise 15 SP1 | \(SUSE Linux Enterprise 12\) v2.1.0 |
| Ubuntu 18.04 LTS | v2.0.1 |
| Ubuntu 20.04 LTS | \(Ubuntu 18.04 LTS\) v2.0.1 |
| Windows Server 2019 | v1.8.1 |
| Windows 10 | \(Windows Server 2019\) v1.8.1 |

- Some distributions use older CIS benchmarks that were the most recent at the time of creation. Efforts have
been made to update the controls to work with the newer operating systems. Older versions of the benchmarks are listed in parenthesis.
- SUSE Linux Enterprise 15 SP1 uses the RHEL 7 task file since their controls are so similar. If you want to exclude a SUSE tag, make sure you use the associated RHEL 7 tag number if they are different.  Tags can be found in the appropriate controls_list file found in the docs directory.

### Requirements
To implement the collection correctly, you will require the following

Control machine:
- Ansible 2.9+
- Machine connected to a package repository source (Satellite or yum repo)

Target machine:
- SSH connection with prviiledge escalation on Linux machines.
  - Python interpreter
- WinRM connection with user with admin priviledge for Windows. Alternatively you can use an SSH connection.
  - PowerShell v3 or higher

Some of the Ansible modules that are used require Ansible 2.7 and newer.

For most of the collection to work, you will need to have a package repo where you can install packages for
the target machine. Registering with Satellite, a package repository, SCM, or a local package collection is recommended before using this, unless you exclude any tags that install packages.

### Use and Care
The collection is designed to run on the machines in the chart above. It may run on other Red Hat and Ubuntu deriviatives, but it has not been tested on them. Upon initiation, the collection will automatically detect the OS and run the appropriate task list.

As the role runs, you will see an output listing the control number and a brief description of the
task being performed (or skipped):

```
TASK [security-rollup : 1.7.1.3 - Set SELinux policy to targeted] ******************************
ok: [192.168.122.252]
```

The controls are implemented as Ansible tags. By default all tags are run on a given system. To
disable a tag from running, run the playbook with the tag excluded (--skip-tags "x.y.z"):

```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "x.y.z"
```
Multiple tags can be listed, separated by commas:
```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "x.y.z,a.b.c"
```
Note: Some automation tasks handle multiple controls. In the role you may see something like this:

```
- name: 6.1.[2,4] - Ensure permissions on /etc/passwd /etc/group
  file:
    path: /etc/{{item}}
    owner: root
    group: root
    mode: 0644
  loop:
    - passwd
    - group
  tags:
    - 6.1.2
    - 6.1.4
```
* In this control, two tags are being processed, '6.1.2' and '6.1.4' if you want this control to not
run, you must exclude both tags:

```
ansible-playbook -i <inventory> <playbook.yml> --skip-tags "6.1.2,6.1.4"
```
Some controls are surrouned by Ansible blocks that themselves have tags. Excluding the tag that applies
to the block will exclude all of the tasks inside of the block. If the block's tag is **not** excluded,
then individual tasks inside of the block can be excluded by excluding their tags.

The list of tags and their associated crontol descriptions are listed in the [controls_list](./docs/controls_list.md) file for Linux and [control_list_win](./docs/controls_list_win.md_ file for Windows)
in the docs directory.

In addition to tags, there are a number of variables that can be set which will enable or disable
tasks, or set values. These are explained and given default values in the **roles/cis-security/defaults/main.yml**
file. Do not set these values in that file, but create and include your own variable file to override the
defaults or set them as host variables.

### Idempotency
Every effort has been made to make the controls idempotent, however some Ansible modules do not have the ability
to measure every need as currently written and shell or command has been utilized to implement controls. This
has the effect of bringing down the quality score on Ansible Galaxy, but the roles can be run multiple times
without fear of breaking.

### History
Orginally dsglaser built the cis-security repository and role as a learning tool for Ansible. However, this role solves something many did not, providing a single interfact for 
multiple OS's to apply security controls for CIS benchmarks. The role was then converted to a collection to allow for easier use and to allow for the addition of Windows controls.
Unfortunately, the original author has moved on to other projects and is no longer able to maintain the role. The role has been forked and will be maintained here by David Murphy.


### Versioning
From dgslaser's  repo we have split @ 1.3.3, and will start our versioning at 2.0.0 to avoid confusion where possible.

### Contributing
Contributions are welcome. Please fork the repo and submit a pull request. If you have any questions, please open an issue.

### License
MIT License for this code
Creative Commons Attribution-ShareAlike 4.0 International License for the CIS Benchmarks

### Author
David Murphy


### Acknowledgements
- @dsglaser for the original role
- @jaredhocutt for the Windows controls
- @joshuacox for the SUSE, Ubuntu, CentOS, Oracle, Fedora, RHEL, Debian, and other  controls
- @joshuacox for the Ansible Galaxy roles for most of the OS's
- @joshuacox for the Ansible Galaxy collection for most of the OS's
- @dbmurphy  for the cleanup and maintenance of the roles
- @dbmurphy  for the Amazon Linux 2 controls
- @dbmurphy  for the Ansible Galaxy role for Amazon Linux 2
- @dbmurphy  for updating the collection to Ansible Core 2.15 and Ansible Commnity Package 7.X
