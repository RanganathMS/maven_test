FROM centos:7 as builder
LABEL maintainer="HJ"
WORKDIR /app/source
COPY . /app/source
RUN yum install -y wget
RUN yum install -y maven && \
    yum install -y java-1.8.0-openjdk && \  # Corrected Java installation command
    wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz && \
    tar -zvxf apache-tomcat-9.0.80.tar.gz
RUN mvn clean package


FROM centos:7
WORKDIR /app
COPY --from=builder /app/source/webapp/target/webapp.war /app/
EXPOSE 8080
CMD ["./apache-tomcat-9.0.80/bin/catalina.sh", "run"]
