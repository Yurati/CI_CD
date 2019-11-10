FROM openjdk:8-jdk-alpine
VOLUME /tmp
WORKDIR /
ADD build/libs/test-1.0.0.jar test-1.0.0.jar
EXPOSE 8080
CMD java - jar test-1.0.0.jar