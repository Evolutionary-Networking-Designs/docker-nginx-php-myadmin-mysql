FROM centos:7

ENV OPENEMR_BRANCH=rel-421

RUN yum install -y git
RUN yum upgrade -y

RUN mkdir -p /var/www/html/

WORKDIR /var/www/html/
RUN git clone --progress --verbose https://github.com/openemr/openemr.git

WORKDIR /var/www/html/openemr/
RUN git checkout $OPENEMR_BRANCH
