KEEP OUT -- IN PROGRESS

docker build -t nsfwaas .

docker run  -p 5000:5000/tcp nsfwaas

curl -X POST -F "image=@beach.jpg" localhost:5000/classify



