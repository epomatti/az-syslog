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

### Server

```sh
sudo nano /etc/rsyslog.conf
```

```sh
# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")
```

```sh
rsyslogd -f /etc/rsyslog.conf -N1
```


### Client


```sh
*.* @10.10.10.133:514

$ActionQueueFileName queue #Sets file name and enables disk mode
$ActionQueueMaxDiskSpace 1g #Sets max dis usage
$ActionQueueSaveOnShutdown on #Save in-memory data if rsyslog shuts down
$ActionQueueType LinkedList #Use asynchronous processing
$ActionQueueRetryCount -1 #Infinite retries on insert failure
```

systemctl restart rsyslog

netstat -anup

