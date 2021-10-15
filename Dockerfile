FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY ./target/spring-petclinic-2.5.0-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "spring-petclinic-2.5.0-SNAPSHOT.jar"]
