* control

author: weaves

following

 https://github.com/scala/scala-module-dependency-sample.git

** With Spark

This looks useful.

https://nosqlnocry.wordpress.com/2015/02/27/how-to-build-a-spark-fat-jar-in-scala-and-submit-a-job/

https://github.com/H4ml3t/spark-scala-maven-boilerplate-project

git clone git@github.com:H4ml3t/spark-scala-maven-boilerplate-project.git
cd spark-scala-maven-boilerplate-project


** sbt basics

sbt uses ivy to manage dependencies. (Ivy is Apache project adding
dependency management to Ant builds.)

The Hello template can be created with this:

 sbt new sbt/scala-seed.g8

prompted for a project name "hello" after that

 sbt run

should build. Populates an ~/.ivy2 cache directory.

 sbt test

should run the tests. And there's clean and package tasks.

Because of Java spin-up costs it's best to run multiple goals, either on
the command line or in the interpreter.

http://www.scala-sbt.org/0.13/docs/Running.html

It might be an idea to use sbt to run and test Scala components in the
Emacs interpreter.



** With Spark 2.1.0 - currently uses 2.11.* Scala

https://nosqlnocry.wordpress.com/2015/02/27/how-to-build-a-spark-fat-jar-in-scala-and-submit-a-job/

https://github.com/H4ml3t/spark-scala-maven-boilerplate-project

** Depend on Scala modules like a pro

This repository shows how to use these build tools:

  - sbt
  - Maven

to depend on Scala standard modules such as:

  - scala-xml, containing the `scala.xml` package
  - scala-parser-combinators, containing the `scala.util.parsing` package
  - scala-swing, containing the `scala.swing` package

These modules were split out from the Scala standard library, beginning with Scala 2.11.

*** Sbt sample

This sample demonstrates how to conditionally depend on all modules. If use
only on some of the modules just edit the `libraryDependencies` definition
accordingly. If you are just looking for a copy&paste snippet for your
`build.sbt` file, here it is:

```scala
// add dependencies on standard Scala modules, in a way
// supporting cross-version publishing
// taken from: http://github.com/scala/scala-module-dependency-sample
libraryDependencies := {
  CrossVersion.partialVersion(scalaVersion.value) match {
    // if Scala 2.12+ is used, use scala-swing 2.x
    case Some((2, scalaMajor)) if scalaMajor >= 12 =>
      libraryDependencies.value ++ Seq(
        "org.scala-lang.modules" %% "scala-xml" % "1.0.6",
        "org.scala-lang.modules" %% "scala-parser-combinators" % "1.0.4",
        "org.scala-lang.modules" %% "scala-swing" % "2.0.0-M2")
    case Some((2, scalaMajor)) if scalaMajor >= 11 =>
      libraryDependencies.value ++ Seq(
        "org.scala-lang.modules" %% "scala-xml" % "1.0.6",
        "org.scala-lang.modules" %% "scala-parser-combinators" % "1.0.4",
        "org.scala-lang.modules" %% "scala-swing" % "1.0.2")
    case _ =>
      // or just libraryDependencies.value if you don't depend on scala-swing
      libraryDependencies.value :+ "org.scala-lang" % "scala-swing" % scalaVersion.value
  }
}
```

*** Maven sample

The following `pom.xml` snippet assumes you define a `scalaBinaryVersion` property in your pom.xml file. For example, the `scalaBinaryVersion` should be set to `2.11` for any Scala 2.11.x version.

```xml
<!-- taken from: http://github.com/scala/scala-module-dependency-sample -->
<dependency>
  <groupId>org.scala-lang.modules</groupId>
  <artifactId>scala-xml_${scalaBinaryVersion}</artifactId>
  <version>1.0.6</version>
</dependency>
<dependency>
  <groupId>org.scala-lang.modules</groupId>
  <artifactId>scala-parser-combinators_${scalaBinaryVersion}</artifactId>
  <version>1.0.4</version>
</dependency>
<dependency>
  <groupId>org.scala-lang.modules</groupId>
  <artifactId>scala-swing_${scalaBinaryVersion}</artifactId>
  <version>1.0.2</version>
</dependency>
```

**** NOTE

Due to an [issue](https://issues.scala-lang.org/browse/SI-8358) in the
Scala compiler, a project that uses scala-xml will compile
successfully on Scala 2.11 even without an explicit dependency on the
`scala-xml` module. However, it will fail at runtime due to missing
dependency. In order to prevent that mistake we offer a
workaround. Add `-nobootcp` Scala compiler option which will make
scala-xml invisible to compilation classpath and your code will fail
to compile when the dependency on `scala-xml` is missing. Check sample
pom.xml for details.

**** Scala cross-versioning with Maven

The snippet provided above allows you to declare dependencies on
modules shipped against Scala 2.11. If you would like to support
building your project with both Scala 2.10, 2.11 and 2.12 at the same
time you'll need to use [Maven
profiles](http://maven.apache.org/guides/introduction/introduction-to-profiles.html). Check
the `pom.xml` file in the sample project for details how to set up
Maven profiles for supporting different Scala versions.


** This file's Emacs file variables

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: iso-8859-1-unix ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]

