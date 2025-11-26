FROM amazoncorretto:11-alpine-jdk as builder
WORKDIR /app/source
COPY . .
RUN ./mvnw package

FROM amazoncorretto:11-alpine-jdk
COPY --from=builder /app/source/target/*.jar /app/app.jar
EXPOSE 8082
VOLUME /data
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

#adoptopenjdk/openjdk11