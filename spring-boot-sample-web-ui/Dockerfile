FROM java:8
MAINTAINER Taehyoung Yim <yim0823@naver.com>

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Set Appropriate Environmental Variables
ENV ARTIFACT_NAME=spring-boot-sample-web-ui-0.0.1-SNAPSHOT.jar

# Create a directory in the container where the code will be placed
RUN mkdir -p /backend-dir-inside-container

# Copy everything inside src to our directory in the container.
# The reason for the comment is that I will use docker-compose.
#COPY build/libs/$ARTIFACT_NAME /backend-dir-inside-container

# Set this as the default, working directory.
#WORKDIR /backend-dir-inside-container

# Our Nginx container will forward HTTP traffic to containers of this image via port 8082.
EXPOSE 8082

# Execute Spring boot [dev, prod, local, test]
#ENTRYPOINT ["java","-jar","-Dspring.profiles.active=prod","/backend-dir-inside-container/spring-boot-sample-web-ui-0.0.1-SNAPSHOT.jar"]
