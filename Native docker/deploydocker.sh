sudo mkdir -p /opt/mount1/namenode-dir /opt/mount2/namenode-dir /opt/mount1/datanode-dir /opt/mount2/datanode-dir /opt/mount1/nodemanager-local-dir /opt/mount2/nodemanager-local-dir /opt/mount1/nodemanager-log-dir /opt/mount2/nodemanager-log-dir
docker pull sasha0986/hadoopdocker:namenode
docker pull sasha0986/hadoopdocker:worker
docker network create local
docker run -d --network local --rm --add-host headnode:127.0.0.1  -v /opt/mount1/namenode-dir:/opt/mount1/namenode-dir  -v /opt/mount2/namenode-dir:/opt/mount2/namenode-dir  -p 9870:9870  -p 8020:8020  -p 8088:8088  --name namenode sasha0986/hadoopdocker:namenode
docker run -d --network local --rm --add-host datanode:127.0.0.1 -v /opt/mount1/datanode-dir:/opt/mount1/datanode-dir -v /opt/mount2/datanode-dir:/opt/mount2/datanode-dir -v /opt/mount1/nodemanager-local-dir:/opt/mount1/nodemanager-local-dir -v /opt/mount2/nodemanager-local-dir:/opt/mount2/nodemanager-local-dir -v /opt/mount1/nodemanager-log-dir:/opt/mount1/nodemanager-log-dir -v /opt/mount2/nodemanager-log-dir:/opt/mount2/nodemanager-log-dir -p 9864:9864 -p 9867:9867 -p 9866:9866 -p 9865:9865 --name datanode sasha0986/hadoopdocker:worker
