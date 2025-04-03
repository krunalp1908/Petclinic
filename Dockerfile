FROM openjdk:8
EXPOSE 8082
COPY target/petclinic.war /usr/local/tomcat/webapps/petclinic.war
CMD ["catalina.sh", "run"]
