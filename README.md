KEEP OUT -- IN PROGRESS

docker build -t nsfwaas .

docker run -p 80:80/tcp nsfwaas

curl -X POST -F "image=@beach.jpg" http://localhost/classify



