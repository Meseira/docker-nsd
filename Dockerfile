FROM debian:wheezy

MAINTAINER Xavier Gendre "gendre.reivax@gmail.com"

RUN apt-get update && apt-get install -y nsd3

# Empty configuration file
RUN touch /etc/nsd3/nsd.conf

# Build the database
RUN zonec -c /etc/nsd3/nsd.conf

# Volume for the logs
VOLUME ["/var/log/nsd"]

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 53/udp
CMD ["/usr/sbin/nsd", "-d", "-c", "/etc/nsd3/nsd.conf", "-l", "/var/log/nsd/nsd.log"]
