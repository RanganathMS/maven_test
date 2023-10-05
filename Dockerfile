FROM maven:3-jdk-8 as builder
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source
RUN mvn clean package
RUN apt-get update && apt-get install -y unzip && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip && \
    unzip sonar-scanner-cli-3.0.3.778-linux.zip -d /opt/ && \
    rm sonar-scanner-cli-3.0.3.778-linux.zip && \
    ln -s /opt/sonar-scanner-3.0.3.778-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

ENV SONAR_URL=http://65.0.7.97:9000 
sonar.projectKey=maven_test
sonar.projectName=webapp
sonar.projectVersion=1.0
sonar.sources=src
sonar.java.binaries=target/classes

COPY sonar-project.properties /app/source/sonar-project.properties
RUN mvn clean package && sonar-scanner

FROM tomcat:latest
COPY --from=builder /app/source/webapp/target/*.war /usr/local/tomcat/webapps/webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]



