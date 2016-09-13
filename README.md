PowerDNS in Docker with master/slave configuration

This Dockerfile by default will build a PowerDNS image configured to be master.

```
$ docker build -t pdns_master:latest .
...
```

In order to build a slave image perform the following:

```
$ docker build -t pdns_slave:latest --build-arg='role=slave' .
...
```

After you have built the images, you can run a container by executing:

```
$ docker run -d pdns_master:latest
3b52bbbdf5f98w7eyh9wefhjw9efhqw9eofjqefo
```

You may inspect the container and get the IP address to configure the slave
and send commands from a different network address.

```
$ docker inspect --format '{{ .NetworkSettings.IPAddress }}' 3b52bbbdf5f9
172.17.0.2
```

You may now enter the running master and create a zone and enter records as
well as allowing AXFR to slave nodes:

```
$ docker exec -it 3b52bbbdf5f9 /bin/bash
$ pdnsutil create-zone cookgetsitdone.co.uk
$ pdnsutil add-record cookgetsitdone.co.uk www1 A 10.100.100.21
$ pdnsutil set-kind cookgetsitdone.co.uk master
$ pdnsutil set-meta cookgetsitdone.co.uk ALLOW-AXFR-FROM 172.17.0.0/16
```

Finally, you can create a slave instance and configure it to request AXFR from
the master.

```
$ docker run -d pdns_slave:latest
...
$ docker exec -it ... /bin/bash
$ pdnsutil create-slave-zone cookgetsitdone.co.uk 172.17.0.2:5353
```
