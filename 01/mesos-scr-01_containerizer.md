## Agenda

./docs以下だけはあらかじめ読んできておいてもらえると嬉しいな。

* Listing docs
* Future of containerizer
* Read containerizer code

## Source

* Tag 1.1.0 / hash a44b077ea0df54b77f0
* $ find . -type f -name "container*"
  * scheduler等と比べるとドキュメントはだいぶ豊富な方かもしれない
  * 追加で `./include/mesos/v1/mesos.proto`
  * 追加で ./include/mesos/slave/以下のファイル数点
* 読んでおきたい、もしくはこれからピックアップするファイルの名前末尾に※を付ける
* 把握しておきたいディレクトリ構造
  * docs
  * IDL (protobuf)
  * Docker ラッパー
  * Containerizer
    * Composing
    * Docker
    * Mesos


```
./docs/container-image.md
./docs/containerizer-internals.md ※
./docs/containerizer.md ※
./docs/endpoints/slave/containers.md
./docs/images/containerizer_isolator_api.png
./include/mesos/module/container_logger.hpp
./include/mesos/slave/container_logger.hpp
./include/mesos/slave/containerizer.hpp
./include/mesos/slave/containerizer.proto ※
./src/slave/container_logger.cpp
./src/slave/containerizer/composing.cpp
./src/slave/containerizer/containerizer.cpp
./src/slave/containerizer/docker.cpp
./src/slave/containerizer/fetcher.cpp
./src/slave/containerizer/composing.hpp
./src/slave/containerizer/containerizer.hpp ※
./src/slave/containerizer/docker.hpp ※
./src/slave/containerizer/fetcher.hpp ※
./src/slave/containerizer/mesos/containerizer.cpp ※
./src/slave/containerizer/mesos/containerizer.hpp ※
./src/slave/containerizer/mesos/ あとこのディレクトリ以下
./src/tests/container_logger_tests.cpp
./src/tests/containerizer.cpp
./src/tests/containerizer.hpp
```

```
./include/mesos/v1/mesos.proto ※
./src/docker/docker.hpp
./src/docker/docker.cpp
```


## Future

以下のような話しもあります。

* [An Overview of Mesos' New Unified Containerizer](http://winderresearch.com/2016/07/02/Overview-of-Mesos-New-Unified-Containerizer/)
  * Unified ContainerizerがほかすべてのContainerizerを置き換える
  * 古いContainerizerはそのまま使える
* [Questions about "Unified Container"](https://groups.google.com/forum/m/#!topic/mesos-containerizer-dev-wg/u5VhPvDy6Uw)
  * Unifiedとは: Docker, appc, mesos containerizer を統合したもの

## docsなどの情報からざっくりまとめ

コンテナの種類

* Composing: Docker, Mesosを合成するコンテナライザー。リソースのアイソレーションのタスクをテストするような使い方をする。
* Docker: 名前の通りDockerを使用
* Mesos: Linuxのnamespacesとcgroupsを使用

## Code Reading

### protobufに定義されている型とか

* ./include/mesos/v1/mesos.proto
* コンテナのイメージの種類 L1796 message Image
* message
  * ./include/mesos/v1/mesos.proto
    * TaskInfo
    * ContainerInfo
  * ./include/mesos/slave/containerizer.proto
    * ContainerConfig
    * ContainerLaunchInfo

* ディレクトリの階層
  * ./src/slave/containerizer/containerizer.hpp abstract class
  * ./src/slave/containerizer/mesos/containerizer.cpp (default) Mesos containerizer

## Containerizer (abstract class)のメンバ関数を見る

docs/containerizer-internals.mdより、おさらいすると、

1. pull image する
2. pre-hookを呼ぶ
3. (A)Mesos agent in dockerと(B)のnot in dockerの2通りで、executorは呼び出す

となっていることに注目してコードを読む。

staticなメンバ関数のresourcesって共通のメンバでしたっけ。教えて。

読みたい：

* Containerizer::create
* Containerizer::recover
* Containerizer::launch
* Containerizer::wait
* Containerizer::destroy


## みんな大好きDocker (Containerizer)の探索

* abstract classで見たメンバを眺める
* ./src/slave/containerizer/docker.{hpp,cpp}
  * DockerContainerizer => DockerContainerizerProcess クラスを呼び出す形となっているのがわかる
  * create, launch, wait, destroyを見る

* src/docker/docker.hpp, src/docker/docker.cpp
  * `docker` コマンドのラッパーらしい。subprocessで実行する


