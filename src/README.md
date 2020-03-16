# Overview - ntp-centos
* It installs and enables chrony to sync time.

## Charm configuration
You can configure your ntp servers as:
<pre>
juju config ntp servers="1.ntp.server 2.ntp.server 3.ntp.server "
</pre>
## Deploying the charm
This is a subordinate charm so deploying needs a principal charm:

<pre>
juju deploy slurm-node-centos
juju deploy ntp-centos
juju relate ntp-centos slurm-node-centos
</pre>

## Actions
These are the operator actions available.

### status
Retrieve output from chronyc to see ntp status
<pre>
juju run action ntp-centos/0 status --wait
</pre> 