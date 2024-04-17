# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project files to the container
COPY pom.xml .
COPY src ./src/

# Build the project
RUN mvn clean package -DskipTests

# Create a new stage for the final image
FROM tomcat:latest

# Copy the WAR file from the build stage to the Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]