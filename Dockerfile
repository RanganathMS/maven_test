FROM centos:7 as builder
LABEL maintainer="HJ"
WORKDIR /app/source
COPY . /app/source
RUN yum install -y maven && yum install java-1.8* && wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
RUN tar -zvxf apache-tomcat-9.0.55.tar.gz
RUN mvn clean package
FROM builder
COPY --from=builder /webapp/target/webapp.war /app/source
EXPOSE 8080
CMD ["catalina.sh", "run"]
