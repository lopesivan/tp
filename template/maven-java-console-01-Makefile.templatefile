package=br.com.fortytwo
project=NameOfProject

all: getting-started-with-maven-java-console-app

getting-started-with-maven-java-console-app:
	@mvn archetype:generate -DgroupId=$(package) -DartifactId=$(project) -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

clean-project:
	rm -rf $(project)

compile:
	@(cd $(project); mvn compile)

run:
	@(cd $(project); mvn exec:java -Dexec.mainClass="$(package).App")

