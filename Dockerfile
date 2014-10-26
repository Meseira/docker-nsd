FROM debian:wheezy

MAINTAINER Xavier Gendre "gendre.reivax@gmail.com"

RUN apt-get update && apt-get install -y nsd3

EXPOSE 53

ENTRYPOINT ["/usr/sbin/nsd"]
CMD ["-c /etc/nsd3/nsd.conf"]
