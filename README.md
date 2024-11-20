# Syslog

Generate the `.auto.tfvars` from the [template](config/template.tfvars):

```sh
cp config/template.tfvars
```

Set your public IP address in the `allowed_source_address_prefixes` variable using CIDR notation:

```sh
# allowed_source_address_prefixes = ["1.2.3.4/32"]
curl ifconfig.me
```

Create a temporary key for the Virtual Machine:

```sh
mkdir keys && ssh-keygen -f keys/temp_rsa
```

Deploy the resources:

```sh
terraform init
terraform apply -auto-approve
```

## Syslog

> [!NOTE]
> Most of the configuration used from [this video][1].

### Server

Edit the RSyslog configuration in the server:

```sh
sudo nano /etc/rsyslog.conf
```

Uncomment the following configuration:

```sh
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")
```

Add this configuration as well:

```sh
$template remote-incoming-logs, "/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?remote-incoming-logs
& stop # stop processing after receive
```

Verify the configuration file:

```sh
rsyslogd -f /etc/rsyslog.conf -N1
```

Restart RSyslog:

```sh
sudo systemctl restart rsyslog
sudo systemctl status rsyslog
```

Check if the listener is opened:

```sh
netstat -anup
```

Get the private IP to use in the client configuration:

```sh
ip a
```

### Client

Edit the RSyslog configuration in the client:

```sh
sudo nano /etc/rsyslog.conf
```

Verify the configuration file:

```sh
rsyslogd -f /etc/rsyslog.conf -N1
```

```sh
*.* @<SYSLOG SERVER IP>:514

$ActionQueueFileName queue #Sets file name and enables disk mode
$ActionQueueMaxDiskSpace 1g #Sets max dis usage
$ActionQueueSaveOnShutdown on #Save in-memory data if rsyslog shuts down
$ActionQueueType LinkedList #Use asynchronous processing
$ActionQueueRetryCount -1 #Infinite retries on insert failure
```

Verify the configuration file:

```sh
rsyslogd -f /etc/rsyslog.conf -N1
```

Restart RSyslog:

```sh
sudo systemctl restart rsyslog
sudo systemctl status rsyslog
```


[1]: https://youtu.be/mBJ8JfJnlXQ
