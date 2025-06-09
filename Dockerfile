FROM openjdk:21-slim AS app-builder
RUN apt update && apt install -y wget
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.tar.gz -P /opt \
    && tar xf /opt/apache-maven-3.9.10-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.9.10 /opt/maven
ENV PATH="/opt/maven/bin:${PATH}"
RUN mkdir /working && chmod a+rw /working
ADD . /working
WORKDIR /working
RUN mvn package -DskipTests

FROM alpine/java:21.0.4-jre
COPY --from=app-builder /working/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT exec java -jar /app/app.jar

