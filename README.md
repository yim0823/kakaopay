# kakaopay - Non-disruptive deployment of web services using dockers
이 프로젝트는 Java Web application with Gradle를 Nginx로 Reverse proxy 80 port, Round robin 방식으로 웹서버를 구동하고 이 웹서버들을 Container 기반으로 구성하여 scale in/out과 무중단 배포가 가능하게 구축합니다. 그리로 이를 운영 스크립트로 운영합니다.

## Requirements
> * [x] checked 웹 애플리케이션 예제 spring-boot-sample-web-ui
> * [x] checked build script는 gradle로 작성
> * [x] checked 어플리케이션들은 모두 독립적인 Container 로 구성
> * [x] checked 어플리케이션들의 Log 는 Host 에 file 로 적재
> * [x] checked Container scale in/out 가능해야 함
> * [x] checked 웹서버는 Nginx 사용
> * [x] checked 웹서버는 Reverse proxy 80 port, Round robin 방식으로 설정
> * [x] checked 무중단 배포 동작을 구현 (배포 방식에 제한 없음)
> * [x] checked 실행스크립트 개발언어는 bash/python/go 선택하여 작성
> * [x] checked 어플리케이션 REST API 추가
>   - [GET /health] Health check: REST API 응답결과는 JSON Object 구현

## Elements
 - load-balancer folder: Nginx에 대한 것으로 도커파일과 Nginx 설정 파일이 있다.
   - nginx.conf: scale in/out 가능, Round robin 방식, Reverse proxy 설정 
   ```
   http {

    upstream localhost {
        server server1:8082;
        server server2:8082;
        server server3:8082;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://localhost;
            proxy_set_header Host $host;
        }
    }
 
    keepalive_timeout  65;
 
    include /etc/nginx/conf.d/*.conf;
   }
   ```
 - spring-boot-sample-web-ui project: Java8 기반으로 한 web application 프로젝트 파일들과 도커파일이 있다.
   - Maven -> Gradle로 변경.
   - logback를 설정(logback-spring.xml)하여 log를 file로 적재, daily && filesize 10mb 마다 rollover.
   - Spring-boot의 actuator 이용해 health check 구현, 
     - MonitorController.java [GET /health] 
     ```
     http://localhost/health/healthcheck
     ```
     - application-prod.properties 설정:
     ```
     spring.security.user.name=kakaopay
     spring.security.user.password=kakaopay
     
     management.endpoints.web.exposure.include=health,metrics
     management.endpoints.web.base-path=/health
     management.endpoints.web.path-mapping.health=healthcheck
    ```
 - ubuntu folder: ubuntu16.04로 초기 환경을 도커로 세팅한다.(사용하지 않음)
 - deploy.sh: 도커 이용한 웹서버 무중단 배포를 위한 스크립트.
   - [blue-green](https://subicura.com/2016/06/07/zero-downtime-docker-deployment.html, "BlueGreenDeployment") 배포 방식을 이용하여 무중단 배포를 구현
   - 단독으로 싫행 가능하지만 devops.py에 의해 실행되게 한다.
   ```
   $ sudo devops.py -c delopy
   ```
 - devops.py: 웹서버 운영을 위한 파이썬3 기반으로한 스크립트.
   - start : 컨테이너 환경 전체 실행
   ```
   $ sudo devops.py -c start
   ```
   - stop : 컨테이너 환경 전체 중지
   ```
   $ sudo devops.py -c stop
   ```
   - restart : 컨테이너 환경 전체 재시작
   ```
   $ sudo devops.py -c restart
   ```
   - deploy : 웹어플리케이션 무중단 배포
   ```
   $ sudo devops.py -c delopy
   ```
 - docker-compose.blue.yml | docker-compose.green.yml: 도커에 사용될 docker-compose 파일.
   - 무중단 배포에 활용될 두 docker-compose.yml 파일.
   - scale in/out할 경우, nginx.conf의 upstream 요소에 server를 늘리거나 줄임을 하고 이 docker-compose.*.yml의 services 요소의 server를 같이 조정하면 됨.
 - install-docker-ubuntu16.04.sh: 운영체제(우분투16.04기반)에 초기 환경 세팅하는 스크립트.
   - Installing docker-ce and essential libararies
   - Installing docker-compose
   - Installing git and cloning https://github.com/yim0823/kakaopay.git
   - Installing gradle and configuring environment
 - install_python3.sh: 우분투에 파이썬3를 설치하고 필요한 모듈을 설치하여 devops.py 파일이 동작 가능한 환경을 만드는 스크립트.

## Compatibility
The following platforms are currently tested:
- Ubuntu 16.04

## Installation & Requirements
 - 도커용 서버에 두 파일(install-docker-ubuntu16.04.sh, install_python3.sh)을 옮깁니다. 그리고 다음 명령어를 순차적으로 실행해 설치를 진행합니다.
 ```
 # 운영체제(우분투16.04기반)에 초기 환경 세팅
 $ sudo sh install-docker-ubuntu16.04.sh
 
 # 우분투에 파이썬3를 설치하고 필요한 모듈을 설치하여 devops.py 파일이 동작 가능한 환경 구성
 $ sudo sh install_python3.sh
 ```

## General Guideliens
1. **실행 방법** 
```
$ python3 /usr/app/kakaopay/devops.py -c deploy
$ python3 /usr/app/kakaopay/devops.py -c stop
$ python3 /usr/app/kakaopay/devops.py -c start
$ python3 /usr/app/kakaopay/devops.py -c restart
$ python3 /usr/app/kakaopay/devops.py -c check
```
### properties:
- `-c, --command` : '동작'[start | stop | restart | deploy | check]을 지정합니다.

2. **확인방법**
 - 도커 
 ```
 $ python3 /usr/app/kakaopay/devops.py -c check
 ```
