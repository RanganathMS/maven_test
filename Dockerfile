FROM tomcat:latest as builder
RUN mkdir -p /app/source
COPY . /app/source
WORKDIR /app/source
RUN yum install -y maven
RUN chmod +x mvnw
RUN ./mvnw clean package


FROM builder
COPY --from=builder /app/source/target/*.war /app/webapp.war
EXPOSE 8080
CMD ["catalina.sh", "run" ]
