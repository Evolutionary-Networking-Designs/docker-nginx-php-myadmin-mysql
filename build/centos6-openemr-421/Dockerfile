# Unable to use 6.7 OS Branch is too old for yum to work for updates.
# Pulling latest support 6 Branch from Docker Hub
FROM centos:6

ENV OPENEMR_BRANCH=rel-421

RUN yum install -y git
RUN yum upgrade -y

RUN mkdir -p /var/www/html/

WORKDIR /var/www/html/
RUN git clone https://github.com/openemr/openemr.git

WORKDIR /var/www/html/openemr/
RUN git checkout $OPENEMR_BRANCH
