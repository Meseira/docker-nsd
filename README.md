Supported tags and respective `Dockerfile` links
================================================

* [`latest` *(Dockerfile)*][1]

The version of NSD used by this `Dockerfile` is the same as the one from the [stable debian package `nsd3`][2]. Currently, the version is `3.2.12`.

What is NSD?
============

NSD is an authoritative only and open source DNS server. It is developed by NLnet Labs and it is distributed under the BSD license.

[NSD website][3]

[wikipedia.org/wiki/NSD][4]

How to use this image
=====================

Testing with an empty NSD server
--------------------------------

By default, this image provides a NSD server with no configuration and no zone. It may still be tested by running on the host:

    docker run -d --name nsd-server meseira/nsd

To interrogate this local empty name server, simply use `dig`:

    dig @`docker inspect --format "{{ .NetworkSettings.IPAddress }}" nsd-server`

This command should return an empty *QUESTION SECTION* and some details about the request.

If you receive no response from the NSD server and an error message "*connection timed out; no servers could be reached*", this may be due to an input blockage from your firewall. In such a case, check the rules related to the `docker0` interface.

Accessing the data
------------------

Two volumes devoted to handle the mutable data are included in the image. An easy way to deal with them consists in running `/bin/bash` in a container that can see them,

    docker run -it --name nsd-data --hostname nsd-data \
                   --volumes-from nsd-server \
                   debian:wheezy /bin/bash

Thus, the log file `nsd.log` is located in `/var/log/nsd`,

    root@nsd-data:/# cat /var/log/nsd/nsd.log

and the configuration and zone files are in `/etc/nsd3`,

    root@nsd-data:/# ls /etc/nsd3

Adding configuration and zone files
-----------------------------------

For the moment, the container `nsd-server` is empty and does not serve to anything. Now we want to have fun with our own configuration and zone files.

The default configuration file is `nsd.conf` and is located in `/etc/nsd3`. Help about this file can be found with `man 5 nsd.conf` and in the sample configuration file,

    root@nsd-data:/# cat /etc/nsd3/nsd.conf.sample

Let us take a basic example to test our server,

    root@nsd-data:/# cat <<EOF > /etc/nsd3/nsd.conf
    server:
      hide-version: yes
      identity: ""
    
    zone:
      name: test.nsd
      zonefile: test.nsd.zone
    EOF

The zone files can also be located in `/etc/nsd3`. The format of a zone file is defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1). For more details, see

[wikipedia.org/wiki/Zone_file][5]

In our example of `nsd.conf`, we have declared a zone `test.nsd` defined in a zone file `test.nsd.zone`. Let us create it,

    root@nsd-data:/# cat <<EOF > /etc/nsd3/test.nsd.zone
    \$ORIGIN test.nsd.
    \$TTL 86400
    
    @ IN SOA test.nsd. admin.test.nsd. (
        201410292335 ;
        28800 ;
        28800 ;
        864000 ;
        28800 ;
    )
    
    @ IN A 1.2.3.4
    EOF

To take into account the changes, simply `restart` the container of the NSD server from the host,

    docker restart nsd-server

You can use `docker logs nsd-server` to make sure there was no error and, if everything works, you can test the NSD server,

    dig @`docker inspect --format "{{ .NetworkSettings.IPAddress }}" nsd-server` A test.nsd

You should obtain

    [...]
    
    ;; QUESTION SECTION:
    ;test.nsd.    IN    A

    ;; ANSWER SECTION:
    test.nsd.    86400    IN    A    1.2.3.4
    
    [...]

Exposing the port
-----------------

To use the container as a name server listening on the standard domain port of the host, we need to map its port `53/udp` to the one of the host:

    docker run -p 53:53/udp -d --name nsd-server nsd-server

Issues
======

If you encounter any problem with this image, do not hesitate to report it in a [GitHub issue][6].

  [1]: https://github.com/Meseira/docker-nsd/blob/master/Dockerfile
  [2]: https://packages.debian.org/fr/wheezy/nsd3
  [3]: https://www.nlnetlabs.nl/projects/nsd/
  [4]: https://en.wikipedia.org/wiki/NSD
  [5]: https://en.wikipedia.org/wiki/Zone_file
  [6]: https://github.com/Meseira/docker-nsd/issues
