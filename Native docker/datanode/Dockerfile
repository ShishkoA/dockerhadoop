FROM ubuntu:22.04

# set environment vars
ENV HADOOP_HOME /usr/local/hadoop/current
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV HADOOP_CONF_DIR /usr/local/hadoop/current/etc/hadoop

# install packages
RUN \
  apt-get update && apt-get install -y \
  ssh \
  vim 
  
#######
# OpenJDK 8
#######
# hadolint ignore=DL3008
RUN apt-get -q update && \
    apt-get -q install -y --no-install-recommends openjdk-8-jdk libbcprov-java && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
RUN \
  wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz && \
  tar -xzf hadoop-3.1.2.tar.gz && \
  mv hadoop-3.1.2 /opt && \
  rm hadoop-3.1.2.tar.gz && \
  mkdir /usr/local/hadoop && \
  ln -s /opt/hadoop-3.1.2/ /usr/local/hadoop/current && \
  cd /tmp && \
  wget https://gist.github.com/rdaadr/2f42f248f02aeda18105805493bb0e9b/raw/hadoop-env.sh && \
  wget https://gist.github.com/rdaadr/64b9abd1700e15f04147ea48bc72b3c7/raw/core-site.xml && \
  wget https://gist.github.com/rdaadr/2bedf24fd2721bad276e416b57d63e38/raw/hdfs-site.xml && \
  wget https://gist.github.com/Stupnikov-NA/ba87c0072cd51aa85c9ee6334cc99158/raw/yarn-site.xml && \
  sed -i '/^export JAVA_HOME/s/=.*$/=\/usr\/lib\/jvm\/java-8-openjdk-amd64\/jre/' /tmp/hadoop-env.sh && \
  sed -i '/^export HADOOP_HOME/s/=.*$/=\/usr\/local\/hadoop\/current/' /tmp/hadoop-env.sh && \
  sed -i '/^export HADOOP_HEAPSIZE_MAX/s/=.*$/=512M/' /tmp/hadoop-env.sh && \
  sed -i 's/%HDFS_NAMENODE_HOSTNAME%/namenode/' /tmp/core-site.xml && \
  sed -i 's/%NAMENODE_DIRS%/\/opt\/mount1\/namenode-dir,\/opt\/mount2\/namenode-dir/' /tmp/hdfs-site.xml && \
  sed -i 's/%DATANODE_DIRS%/\/opt\/mount1\/datanode-dir,\/opt\/mount2\/datanode-dir/' /tmp/hdfs-site.xml && \
  sed -i 's/%YARN_RESOURCE_MANAGER_HOSTNAME%/namenode/' /tmp/yarn-site.xml && \
  sed -i 's/%NODE_MANAGER_LOCAL_DIR%/\/opt\/mount1\/nodemanager-local-dir,\/opt\/mount2\/nodemanager-local-dir/' /tmp/yarn-site.xml && \
  sed -i 's/%NODE_MANAGER_LOG_DIR%/\/opt\/mount1\/nodemanager-log-dir,\/opt\/mount2\/nodemanager-log-dir/' /tmp/yarn-site.xml && \
  mv /tmp/hadoop-env.sh /usr/local/hadoop/current/etc/hadoop/hadoop-env.sh && \
  mv /tmp/core-site.xml /usr/local/hadoop/current/etc/hadoop/core-site.xml && \
  mv /tmp/hdfs-site.xml /usr/local/hadoop/current/etc/hadoop/hdfs-site.xml && \
  mv /tmp/yarn-site.xml /usr/local/hadoop/current/etc/hadoop/yarn-site.xml && \
  echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc && \
  mkdir /usr/local/hadoop/current/logs

# expose various ports
EXPOSE 9864 8040 8042 9866 9867

ADD runhdfs.sh /runhdfs.sh
RUN chmod a+x /runhdfs.sh
ADD runyarn.sh /runyarn.sh
RUN chmod a+x /runyarn.sh
ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
