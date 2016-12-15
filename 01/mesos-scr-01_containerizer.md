## Purpose

* コードの読みとき方・ツールの使い方を知る
  * とはいえ、ここに来る方にとっては釈迦に説法か。適宜割愛
* Mesos containerizerの構成・コードの概観を知る
* testも大事だけど今回は説明しません（準備してません）
  * ディレクトリ構造はわかりやすいのでテスト読みたい方はそちらへ... (src/tests/containerizer/)
  * gtest/gmockが使われてる様子

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
  * ./src/slave/containerizer/mesos/ ディレクトリも
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
  * ./src/slave/containerizer/containerizer.hpp abstract class + FactoryMethod
  * ./src/slave/containerizer/mesos/containerizer.cpp (default) Mesos containerizer

## Component

* Fetcher
  * http://mesos.apache.org/documentation/latest/fetcher/
    * ./docs/fetcher.md, ./docs/fetcher-internal.md
  * Sandbox上にファイルをコピー（ダウンロード）してくるもの
  * imageのpullかと思ってたけどそうではなかった
  * 違いがよくわかっていないが、普通の実行用とcontainerizer用と区別されてる気がする
    * src/launcher/fetcher.cpp
    * src/slave/containerizer/fetcher.hpp

## Containerizer (abstract class)のメンバ関数を見る

docs/containerizer-internals.mdより、おさらいすると、

1. pull image する
2. pre-hookを呼ぶ
3. executorを呼び出す。(A)Mesos agent in dockerと(B)のnot in dockerの2通りある

となっていることに注目してコードを読む。

staticなメンバ関数のresourcesって共通のメンバでしたっけ。教えていただきたい。

### コードのフロー

* src/local/local.cpp もしくは src/slave/main.cpp からContainerizer::create が呼ばれる
  * slaveのlaunch, mainといった関数から実行される
* ./src/slave/containerizer/containerizer.cpp Containerizer::create
  * FactoryMethodになっているので、これが呼び出されて各containerizerのオブジェクトが生成される
* slave/slave.cppやslave/http.cpp から呼び出される
  * 残りは追い切れておらず

createの呼び出しを探すgit grep
```
$ git grep "\<Containerizer::create"
src/local/local.cpp:      Containerizer::create(slaveFlags, true, fetchers->back()); 
src/slave/containerizer/containerizer.cpp:Try<Containerizer*> Containerizer::create(
src/slave/main.cpp:    Containerizer::create(flags, false, &fetcher);  launch関数にて
src/tests/cluster.cpp:      slave::Containerizer::create(flags, true, slave->fetcher.get());
```


containerizer変数からメンバ関数の呼び出しを追跡する
```
slave/containerizer/composing.cpp:    futures.push_back(containerizer->recover(state));
slave/containerizer/composing.cpp:    Future<Nothing> future = containerizer->containers()
slave/containerizer/composing.cpp:  return containerizer->launch(
slave/containerizer/composing.cpp:  return containers_[containerId]->containerizer->attach(containerId);
slave/containerizer/composing.cpp:  return containers_[containerId]->containerizer->update(
slave/containerizer/composing.cpp:  return containers_[containerId]->containerizer->usage(containerId);
slave/containerizer/composing.cpp:  return containers_[containerId]->containerizer->status(containerId);
slave/containerizer/composing.cpp:  return containers_[containerId]->containerizer->wait(containerId);
slave/containerizer/composing.cpp:      container->containerizer->destroy(containerId)
slave/containerizer/composing.cpp:          container->containerizer->destroy(containerId));
slave/containerizer/mesos/containerizer.cpp:  // so that subsequent containerizer->update can be handled properly.
slave/containerizer/mesos/isolators/filesystem/linux.cpp:      // 'containerizer->update' after the executor re-registers,
slave/containerizer/mesos/isolators/filesystem/posix.cpp:      // 'containerizer->update' after the executor re-registers,
slave/http.cpp:      statusFutures.push_back(slave->containerizer->status(containerId));
slave/http.cpp:      statsFutures.push_back(slave->containerizer->usage(containerId));
slave/http.cpp:  Future<bool> launched = slave->containerizer->launch(
slave/http.cpp:      slave->containerizer->destroy(containerId)
slave/http.cpp:        slave->containerizer->wait(containerId);
slave/http.cpp:      Future<bool> destroy = slave->containerizer->destroy(containerId);
slave/http.cpp:  return slave->containerizer->attach(containerId)
slave/http.cpp:    slave->containerizer->destroy(containerId)
slave/http.cpp:  return slave->containerizer->attach(containerId)
slave/slave.cpp:      containerizer->update(executor->containerId, resources)
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:      containerizer->update(executor->containerId, resources)
slave/slave.cpp:      containerizer->update(executor->containerId, resources)
slave/slave.cpp:      containerizer->update(executor->containerId, executor->resources)
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:          containerizer->destroy(executor->containerId);
slave/slave.cpp:  containerizer->status(containerId)
slave/slave.cpp:    containerizer->update(executor->containerId, executor->resources)
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:  containerizer->wait(containerId)
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:    containerizer->destroy(containerId);
slave/slave.cpp:      containerizer->destroy(containerId);
slave/slave.cpp:      containerizer->destroy(executor->containerId);
slave/slave.cpp:      containerizer->destroy(containerId);
slave/slave.cpp:  return containerizer->recover(state);
slave/slave.cpp:      containerizer->wait(executor->containerId)
slave/slave.cpp:          containerizer->destroy(executor->containerId);
slave/slave.cpp:          containerizer->destroy(containerId);
slave/slave.cpp:      futures.push_back(containerizer->usage(executor->containerId));
slave/slave.cpp:    launch = slave->containerizer->launch(
slave/slave.cpp:    launch = slave->containerizer->launch(
```

### 読みたい

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


