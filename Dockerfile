FROM alpine:3.12.1 AS builder

#add required packages
RUN  apk add --no-cache   tar  wget bash

#current zookeeper version - update the version if wget complains while building the image
ARG ZK_VERSION=3.6.2

#get zookeeper
RUN wget -O zk.tar.gz -q http://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/apache-zookeeper-${ZK_VERSION}-bin.tar.gz

RUN tar -xzvf zk.tar.gz && mv apache-zookeeper-${ZK_VERSION}-bin /zk && \
mkdir /zk/data && \
rm -rf zk.tar.gz && \
rm -rf /zk/docs && \
apk del wget tar


#arm32 alpine image for the rapsberry pi's
FROM arm32v6/alpine:3.12.1 as final
COPY /tmp/qemu-arm-static /usr/bin/qemu-arm-static

#install java
RUN apk add --no-cache openjdk8-jre bash

WORKDIR zk

COPY --from=builder /zk .

ENV DATA_DIR=/zk/data
ENV MY_ID=1

#configurations
RUN sed "s~dataDir=/tmp/zookeeper~dataDir=${DATA_DIR}~g" /zk/conf/zoo_sample.cfg >/zk/conf/zoo.cfg

RUN echo  "4lw.commands.whitelist=*" >> /zk/conf/zoo.cfg
RUN echo ${MY_ID} >> ${DATA_DIR}/myid

ENV PATH=$PATH:/zk/bin

EXPOSE 2181 2888 3888

CMD ["zkServer.sh", "start-foreground"]