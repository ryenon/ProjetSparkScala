# Étape 1 : Utiliser une image Java 8 légère officielle (indispensable pour Spark 2.x)
FROM openjdk:8-jdk-slim

# Étape 2 : Définir les variables d'environnement de Spark 2.4.0 et Hadoop 2.7
ENV SPARK_VERSION=2.4.0
ENV HADOOP_VERSION=2.7
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin

# Étape 3 : Installer les outils nécessaires et télécharger les binaires de Spark 2.4.0
RUN apt-get update && apt-get install -y wget curl procps && \
    wget -q https://apache.org{SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Étape 4 : Définir le répertoire de travail pour votre application
WORKDIR /opt/spark/work-dir

# Étape 5 : Copier le Fat JAR généré par votre build Maven
# Note : Veillez à ce que le nom corresponde à votre artifactId dans le pom.xml
COPY target/*-jar-with-dependencies.jar /opt/spark/work-dir/app.jar

# Étape 6 : Point d'entrée pour exécuter votre application via le spark-submit de Spark 2.4.0
ENTRYPOINT ["/opt/spark/bin/spark-submit", "--master", "local[*]", "--class", "GestionData", "/opt/spark/work-dir/app.jar"]