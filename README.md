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

By default, this image provides a NSD server with no zone. It may still be tested by running on the host:

    docker run -d --name empty-nsd meseira/nsd

To interrogate this local empty name server, simply use `dig`:

    dig @`docker inspect --format "{{ .NetworkSettings.IPAddress }}" empty-nsd`

This command should return an empty *QUESTION SECTION* and some details about the request.

If you receive no response from the NSD server and an error message "*connection timed out; no servers could be reached*", this may be due to an input blockage from your firewall. In such a case, check the rules related to the `docker0` interface or ignore this test.

Viewing the logs
----------------

A volume devoted to the logs is included in the image. Its path is `/var/log/nsd` and the default log file is `nsd.log`. For example, to view this file,

    docker run --volumes-from empty-nsd debian:wheezy cat /var/log/nsd/nsd.log

Adding configuration and zone files
-----------------------------------

The container `empty-nsd` simply runs a basic NSD server with no zone. Now we want to have fun with our own configuration and zone files.

The default configuration file is `nsd.conf` and is located in `/etc/nsd3/`. To write it, help can be found with `man 5 nsd.conf` and in the sample configuration file,

    docker run --entrypoint cat meseira/nsd /etc/nsd3/nsd.conf.sample

The zone files can be located in `/etc/nsd3/` also. The format of a zone file is defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1). For more details, see

[wikipedia.org/wiki/Zone_file][5]

When all these files are in `/etc/nsd3/`, NSD expects that we rebuild the zone database with some command like `nsdc rebuild`. To avoid connecting to the container, writing these files and compiling the database, we prefer the cleaner way of building a new image through a simple `Dockerfile`:

    FROM meseira/nsd
    COPY my_nsd_conf /etc/nsd3
    RUN nsdc rebuild

Place this `Dockerfile` in the same directory as the directory `my_nsd_conf` that contains your configuration and zone files. Thus, do the build:

    docker build -t my-nsd .

If everything works, you now have an image to run your own NSD server:

    docker run -P -d --name nsd-server my-nsd

Note that the option `-P` will map the port `53/udp` of the container to a random high port of the host. Through this port, you can test the NSD server from outside.

Exposing the port
-----------------

To use the container as a name server listening on the standard domain port of the host, we need to map its port `53/udp` to the one of the host:

    docker run -p 53:53/udp -d --name nsd-server my-nsd

Issues
======

If you encounter any problem with this image, do not hesitate to report it in a [GitHub issue][6].

  [1]: https://github.com/Meseira/docker-nsd/blob/master/Dockerfile
  [2]: https://packages.debian.org/fr/wheezy/nsd3
  [3]: https://www.nlnetlabs.nl/projects/nsd/
  [4]: https://en.wikipedia.org/wiki/NSD
  [5]: https://en.wikipedia.org/wiki/Zone_file
  [6]: https://github.com/Meseira/docker-nsd/issues
