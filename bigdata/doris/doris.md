编译环境

```bash
docker pull  apache/incubator-doris:build-env-ldb-toolchain-latest
docker run -it \
-v /root/.m2:/root/.m2 \
-v /data/docs/src/github/doris:/root/doris \
--name doris-dev \
-d apache/incubator-doris:build-env-ldb-toolchain-latest
docker exec -it doris-dev /root/starrocks/build.sh

# 也可以bash进入以后自行执行编译命令

docker exec -it doris-dev /bin/bash
```

单元测试

- FE: run-fe-ut.sh
- BE: run-be-ut.sh

