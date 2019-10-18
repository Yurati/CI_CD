FROM openjdk:8-jdk-alpine
VOLUME /tmp
COPY dependency/BOOT-INF/lib /app/lib
COPY dependency/META-INF /app/META-INF
COPY dependency/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","docker.Application"]