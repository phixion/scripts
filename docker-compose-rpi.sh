# hack to build docker-compose on arm devices

git clone https://github.com/docker/compose.git
git checkout release
cd compose
cp -i Dockerfile Dockerfile.armhf
sed -i -e 's/^FROM debian\:/FROM armhf\/debian:/' Dockerfile.armhf
sed -i -e 's/x86_64/armel/g' Dockerfile.armhf