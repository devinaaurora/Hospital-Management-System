FROM tomcat:10.1-jdk17

# Copy WAR file to Tomcat webapps
COPY target/hospital-management.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

CMD ["catalina.sh", "run"]
