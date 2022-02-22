#!/bin/bash
export HADOOP_HOME=/usr/local/hadoop/current
export ENSURE_NAMENODE_DIR="/opt/mount1/namenode-dir/current"
if [ -n "$ENSURE_NAMENODE_DIR" ]; then
   if [ ! -d "$ENSURE_NAMENODE_DIR" ]; then
      $HADOOP_HOME/bin/hdfs namenode -format cluster1
        fi
fi
sh -x runhdfs.sh & sh -x runyarn.sh
