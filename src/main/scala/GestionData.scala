import LaSessionSpark._
import org.apache.spark.sql.{DataFrame, SparkSession}

object GestionData {

  def main(args: Array[String]): Unit = {

    /*
    * Initialisation de la session spark
    * */

    val ls = Session_Spark(true)
    val sc = ls.sparkContext
    sc.setLogLevel("OFF")

    /*
    * Initialisation du repertoire contenant les fichiers
    * */

    val baseDataPath = sys.env.getOrElse("BASE_DATA_PATH", "./data")

    /*
    * Création de la fonction de la lecture des différents fichiers
    * */

    def readCsv(spark: SparkSession, dataDir: String, filename: String): DataFrame = {
      ls.read
        .option("header", "true")
        .csv(s"${dataDir}/${filename}.csv")
    }

    /*
    * Création des dataframes
    * */

    val usersDF = readCsv(ls, baseDataPath, "Users")
    val postsDF = readCsv(ls, baseDataPath, "Posts")
    val commentsDF = readCsv(ls, baseDataPath, "Comments")

    /*
    * Affichage des dataframes
    * */

    println("--------- AFFICHAGE DES DATAFRAMES ------------")
    println("Dataframe : USERS")
    usersDF.show(truncate = false)

    println("Dataframe : POSTS")
    postsDF.show(truncate = false)

    println("Dataframe : COMMENTS")
    commentsDF.show(truncate = false)

    /*
    * Jointure
    * */

    val out = postsDF
      .join(usersDF, postsDF("user_id") === usersDF("id"))
      .join(commentsDF, postsDF("id") === commentsDF("user_id"))
      .select(
        usersDF("id").as("user_id"),
        usersDF("name"),
        postsDF("id").as("post_id"),
        postsDF("created_at").as("post_date"),
        commentsDF("id").as("comment_id"),
        commentsDF("created_at").as("comment_date"),
        postsDF("title"),
        commentsDF("text")
      )
      .orderBy("post_date", "comment_date")

    println("--------- AFFICHAGE DU RESULTAT ------------")
    out.show(5)

    println("Le nombre d'elements dans la base est :" + out.count())


  }



}
