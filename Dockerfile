FROM java:8 

ADD /build/libs/application.jar application.jar

EXPOSE 4567
CMD ["/usr/lib/jvm/java-8-openjdk-amd64/bin/java", "-jar", "application.jar"]