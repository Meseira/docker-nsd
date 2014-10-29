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

This command should return an empty *QUESTION SECTION* and some details about the request. If you receive no response from the NSD server and an error message "*connection timed out; no servers could be reached*", this may be due to an input blockage from your firewall. In such a case, check the rules related to the `docker0` interface.

Viewing the logs
----------------

TODO

Exposing the port
-----------------

TODO

Issues
======

If you encounter any problem with this image, do not hesitate to report it in a [GitHub issue][5].

  [1]: https://github.com/Meseira/docker-nsd/blob/master/Dockerfile
  [2]: https://packages.debian.org/fr/wheezy/nsd3
  [3]: https://www.nlnetlabs.nl/projects/nsd/
  [4]: https://en.wikipedia.org/wiki/NSD
  [5]: https://github.com/Meseira/docker-nsd/issues
