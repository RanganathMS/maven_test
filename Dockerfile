FROM centos:8 as builder
RUN yum install -y java-1.8.0-openjdk-devel
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source
RUN mvn clean package

FROM tomcat:latest
COPY --from=builder /app/source/target/*.war /usr/local/tomcat/webapps/webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]

