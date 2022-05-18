编译环境

- 官方文档：https://docs.starrocks.com/zh-cn/main/administration/Build_in_docker

- 基于官方开发docker镜像进行编译
```bash
docker pull starrocks/dev-env:main
docker run -it \
-v /root/.m2:/root/.m2 \
-v /data/docs/src/github/starrocks:/root/starrocks \
--name starrocks-dev \
-d starrocks/dev-env:main
docker exec -it starrocks-dev /root/starrocks/build.sh
```
- 

