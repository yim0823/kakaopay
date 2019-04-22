FROM java:8
MAINTAINER Taehyoung Yim <yim0823@naver.com>

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Set Appropriate Environmental Variables
ENV APP_HOME=backend-dir-inside-container
ENV ARTIFACT_NAME=spring-boot-sample-web-ui-2.0.2.RELEASE.jar

# Create a directory in the container where the code will be placed
RUN mkdir -p /$APP_HOME

# Set this as the default, working directory.
WORKDIR /$APP_HOME

# Copy everything inside src to our directory in the container.
# The reason for the comment is that I will use docker-compose.
#COPY ./target/$ARTIFACT_NAME /$APP_HOME

# Our Nginx container will forward HTTP traffic to containers of this image via port 8082.
EXPOSE 8082

# Execute Spring boot [dev, prod, local, test]
ENTRYPOINT ["java","-jar","-Dspring.profiles.active=prod",/$APP_HOME/$ARTIFACT_NAME]
