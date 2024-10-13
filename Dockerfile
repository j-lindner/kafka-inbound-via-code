FROM alpine/java:21-jdk
MAINTAINER jens
COPY target/kafka-ws-service-1.0.5.jar kafka-ws-service-1.0.5.jar
ENTRYPOINT ["java","-jar","/kafka-ws-service-1.0.5.jar"]