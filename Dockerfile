# Base image with Maven and Java for the build stage
FROM maven:3.9.9-eclipse-temurin-23 AS build

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml ./
COPY src ./src

# Run Maven to build the project
RUN mvn clean install -DskipTests

# Lightweight Java runtime for the final image
FROM eclipse-temurin:23-jdk-alpine

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# Set the spring.config.location to point to the external application.yaml file
CMD ["java", "-jar", "app.jar", "--spring.config.location=file:/opt/bin/application.yaml"]
