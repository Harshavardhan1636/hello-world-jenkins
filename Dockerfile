# ---------- Build stage ----------
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY HelloWorld.java .
RUN javac HelloWorld.java

# ---------- Runtime stage ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/HelloWorld.class .
ENTRYPOINT ["java", "HelloWorld"]
