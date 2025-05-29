#FROM eclipse-temurin:21-jdk
#
#WORKDIR /app
#
#COPY . .
#
#ADD target/scala-3.3.3/my-api-assembly-0.0.1-SNAPSHOT.jar .
#
#ENTRYPOINT ["java", "-jar", "my-api-assembly-0.0.1-SNAPSHOT.jar"]

# Use OpenJDK base image
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the assembly jar (adjust path based on your sbt configuration)
# Default sbt assembly output is usually in target/scala-x.x/
COPY target/scala-3.3.3/my-api-assembly-0.0.1-SNAPSHOT.jar app.jar
# ADD target/scala-3.3.3/my-api-assembly-0.0.1-SNAPSHOT.jar .


# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# Expose port (adjust as needed)
EXPOSE 8080

# Health check (optional, adjust endpoint as needed)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]