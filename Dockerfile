FROM maven:3-jdk-8 as builder
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source
RUN mvn clean package

FROM tomcat:latest
COPY --from=builder /app/source/webapp/target/*.war /usr/local/tomcat/webapps/webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

