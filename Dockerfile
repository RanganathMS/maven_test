FROM maven:3-jdk-8 as builder
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source
RUN mvn clean package

FROM tomcat:latest
COPY --from=builder /app/source/webapp/target/*.war /usr/local/tomcat/webapps/webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]


FROM sonarqube:latest
COPY sonar-project.properties /app/source/sonar-project.properties
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-javadoc.jar -O /opt/sonar-scanner-cli.jar
RUN ln -s /opt/sonar-scanner-cli.jar /opt/sonar-scanner-cli/sonar-scanner-cli.jar
RUN java -Dsonar.scanner.home=/opt/sonar-scanner-cli -jar /opt/sonar-scanner-cli/sonar-scanner-cli.jar

