# MISE A JOUR FORCEE DU DOCKERFILE
FROM amazoncorretto:8

ENV SPARK_VERSION=2.4.0
ENV HADOOP_VERSION=2.7
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin

RUN yum update -y && \
    yum install -y wget curl procps tar gzip && \
    wget -q https://apache.org && \
    tar -xzf spark-2.4.0-bin-hadoop2.7.tgz && \
    mv spark-2.4.0-bin-hadoop2.7 /opt/spark && \
    rm spark-2.4.0-bin-hadoop2.7.tgz && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /opt/spark/work-dir

COPY target/*-jar-with-dependencies.jar /opt/spark/work-dir/app.jar

ENTRYPOINT ["/opt/spark/bin/spark-submit", "--master", "local[*]", "--class", "GestionData", "/opt/spark/work-dir/app.jar"]
