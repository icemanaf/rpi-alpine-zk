FROM alpine:3.7 AS builder

#add required packages
RUN  apk add --no-cache   tar  wget bash

#current zookeeper version
ARG ZK_VERSION=3.5.5

#get zookeeper
RUN wget -O zk.tar.gz -q http://mirror.ox.ac.uk/sites/rsync.apache.org/zookeeper/stable/apache-zookeeper-${ZK_VERSION}.tar.gz 

RUN tar -xzvf zk.tar.gz && mv apache-zookeeper-${ZK_VERSION} /zk && \
mkdir /zk/data && \
rm -rf zk.tar.gz && \
apk del wget tar


#arm32 alpine image for the rapsberry pi's
FROM arm32v6/alpine:3.7 as final
COPY /tmp/qemu-arm-static /usr/bin/qemu-arm-static

#install java
RUN apk add --no-cache openjdk8-jre bash

WORKDIR zk

COPY --from=builder /zk .

ARG DATA_DIR=/zk/data

#configurations
RUN sed "s~dataDir=/tmp/zookeeper~dataDir=${DATA_DIR}~g" /zk/conf/zoo_sample.cfg >/zk/conf/zoo.cfg

ENV PATH=$PATH:/zk/bin

EXPOSE 2181 2888 3888

CMD ["zkServer.sh", "start-foreground"]