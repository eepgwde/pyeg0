import Dependencies._

val snapshots = "Sonatype Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"

/*
val algebraVersion = "0.13.0"
val catsVersion    = "0.1.0-SNAPSHOT"

val algebra    = "org.spire-math" %% "algebra" % algebraVersion
val algebraStd = "org.spire-math" %% "algebra-std" % algebraVersion

val cats       = "org.spire-math" %% "cats-core" % catsVersion
val catsStd    = "org.spire-math" %% "cats-std" % catsVersion
*/

val cats = "org.typelevel" %% "cats" % "0.9.0"

lazy val root = (project in file(".")).
  settings(
    inThisBuild(List(
      organization := "com.example",
      scalaVersion := "2.11.8",
      version      := "0.1.0-SNAPSHOT"
    )),
    partialUnificationModule := "com.milessabin" % "si2712fix-plugin" % "1.2.0",
    name := "cats0",
    resolvers += snapshots,
    libraryDependencies ++=
      Seq(
        scalaTest % Test,
	"com.opencsv" % "opencsv" % "4.0",
	"org.apache.commons" % "commons-csv" % "1.5",
	"ch.qos.logback"          % "logback-classic" % "1.1.2",
	"com.typesafe.scala-logging" %% "scala-logging" % "3.7.2",
        cats
      )
  )

