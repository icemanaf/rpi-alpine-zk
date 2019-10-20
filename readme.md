# Zookeeper Docker image for Raspberry Pi Zero W's and above.

This is a docker image that has been optimized to run reliably on memory constrained Raspberry Pi's such as the Zero W.

Introduction
------------
[Zookeeper](https://zookeeper.apache.org/) is a distributed coordinator and configuration management system and is a required dependency for software such as Apache Kafka.


Instructions
------------
Create a  directory called zk on the host and two subdirectories inside it named data and config repectively.
These will contain the setup and configuration data and the running container will have it's zookeeper config directories mapped to these.

Run the image:

```
	run sudo docker run -it --restart always -p 2181:2181 -p 2888:2888 -p 3888:3888 -v ~/zk/data:/zk/data -v ~/zk/conf:/zk/conf icemanaf/zk-rpi-alpine
```
Put the myid file in the data folder. This is essential in a multi broker zookeeper ensemble.

