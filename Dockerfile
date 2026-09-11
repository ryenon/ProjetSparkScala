# Étape 1 : Utiliser une image Spark 2.4.0 officielle et prête à l'emploi
FROM bde2020/spark-master:2.4.0-hadoop2.7

# Étape 2 : Définir le répertoire de travail
WORKDIR /opt/spark/work-dir

# Étape 3 : Copier votre fichier Fat JAR compilé par Maven
COPY target/*-jar-with-dependencies.jar /opt/spark/work-dir/app.jar

# Étape 4 : Point d'entrée pour exécuter votre application Spark Scala
ENTRYPOINT ["/css/spark/bin/spark-submit", "--master", "local[*]", "--class", "GestionData", "/opt/spark/work-dir/app.jar"]
