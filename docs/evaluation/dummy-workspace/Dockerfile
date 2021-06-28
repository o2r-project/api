FROM debian:latest
MAINTAINER <http://o2r.info>

ENV SECONDS 60

COPY gotosleep.sh /gotosleep.sh

CMD ["/bin/bash", "/gotosleep.sh"]

CMD docker build --tag sleeptainer .
CMD docker run -it --rm sleeptainer
