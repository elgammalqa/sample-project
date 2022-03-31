ARG RUNTIME_IMAGE=adoptopenjdk/openjdk11:jdk-11.0.6_10-alpine-slim
ARG BUILD_IMAGE=gradle:7.4.1
ARG JAR_FILE=/build/libs/*.jar
FROM ${BUILD_IMAGE} AS builder
WORKDIR /app
COPY . ./
RUN gradle build
FROM ${RUNTIME_IMAGE}
WORKDIR /app
RUN set -eux; \
    addgroup -S -g 1000 spring; \
    adduser -S -D -u 1000 -G spring spring;
USER spring
COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT [ "java", "-jar", "app.jar" ]