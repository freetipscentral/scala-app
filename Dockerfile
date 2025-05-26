FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY . .

ADD target/scala-3.3.3/my-api-assembly-0.0.1-SNAPSHOT.jar .

ENTRYPOINT ["java", "-jar", "my-api-assembly-0.0.1-SNAPSHOT.jar"]
