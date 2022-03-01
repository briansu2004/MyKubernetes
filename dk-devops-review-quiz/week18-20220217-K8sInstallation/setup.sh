#!/bin/bash

docker pull nginx
docker pull redis
docker pull hello-world
docker pull ubuntu
echo "This is week8!" > /usr/local/share/hello.txt
docker run -d --name dk -p 8888:80 -v /usr/local/share:/tmp nginx &
docker run -d --name indoc -p 9999:6379 -p 7777:6378 redis &

clear
echo "Please wait 5s for the environment setup..."
sleep 5s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
