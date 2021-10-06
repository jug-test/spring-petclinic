FROM openjdk:8-jdk-alpine
WORKDIR /app
ARG JAR_FILE=./*.jar
COPY ${JAR_FILE} spring-petclinic-2.5.0-SNAPSHOT
ENTRYPOINT ["java", "-jar", "/spring-petclinic-2.5.0-SNAPSHOT"]
