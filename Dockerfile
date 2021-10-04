FROM openjdk:8-jre-alpine
WORKDIR /app
COPY ./target/*.jar .
RUN java -jar spring-petclinic-2.5.0-SNAPSHOT*.jar
ENTRYPOINT ["java", "-jar", "spring-petclinic-2.5.0-SNAPSHOT.jar"]
EXPOSE 8080