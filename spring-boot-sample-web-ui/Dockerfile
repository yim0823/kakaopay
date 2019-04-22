FROM java:8
MAINTAINER Taehyoung Yim <yim0823@naver.com>

# Set Appropriate Environmental Variables
ENV SERVICE_NAME=spring-boot-sample-web-ui
ENV ARTIFACT_NAME=$SERVICE_NAME-2.0.2.RELEASE.jar

# Create a directory in the container where the code will be placed
RUN mkdir -p /backend-dir-inside-container

# Set this as the default, working directory.
WORKDIR /backend-dir-inside-container

# Copy everything inside src to our directory in the container.
# The reason for the comment is that I will use docker-compose.
#COPY ./target/$ARTIFACT_NAME /backend-dir-inside-container

# Our Nginx container will forward HTTP traffic to containers of this image via port 8082.
EXPOSE 8082

# Execute Spring boot [dev, prod, local, test]
ENTRYPOINT ["java","-jar","-Dspring.profiles.active=prod",$ARTIFACT_NAME]
