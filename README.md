# kakaopay - Non-disruptive deployment of web services using dockers
이 프로젝트는 Java Web application with Gradle를 Nginx로 Reverse proxy 80 port, Round robin 방식으로 웹서버를 구동하고 이 웹서버들을 Container 기반으로 구성하여 scale in/out과 무중단 배포가 가능하게 구축합니다. 그리로 이를 운영 스크립트로 운영합니다.

## 요구사항
> - 웹 애플리케이션 예제 spring-boot-sample-web-ui
> - build script는 gradle로 작성
> - 어플리케이션들은 모두 독립적인 Container 로 구성
> - 어플리케이션들의 Log 는 Host 에 file 로 적재
> - Container scale in/out 가능해야 함
> - 웹서버는 Nginx 사용
> - 웹서버는 Reverse proxy 80 port, Round robin 방식으로 설정
> - 무중단 배포 동작을 구현 (배포 방식에 제한 없음)
> - 실행스크립트 개발언어는 bash/python/go 선택하여 작성
> - 어플리케이션 REST API 추가
>   - [GET /health] Health check: REST API 응답결과는 JSON Object 구현


Make image: 
docker build -t ubuntu-kakaopay-web:0.0.1 -t ubuntu-kakaopay-web:0.0.1 .
Run container: 
docker run --name  ubuntu-kakaopay-web 

무중단 배포 스크립트 deploy.sh
chmod +x ./deploy.sh 명령어로 deploy.sh에 실행할 수 있는 권한을 추가


python3 devops.py -c start
