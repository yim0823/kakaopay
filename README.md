# kakaopay

Make image: 
docker build -t ubuntu-kakaopay-web:0.0.1 -t ubuntu-kakaopay-web:0.0.1 .
Run container: 
docker run --name  ubuntu-kakaopay-web 

무중단 배포 스크립트 deploy.sh에서는 Docker remote API를 이용하기 때문에 아래와 같은 설정이 필요하다.
