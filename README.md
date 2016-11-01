# Mesos SCR JP

[Mesos Source Code Reading Group](http://mesos-scr-jp.connpass.com/) in Tokyo/Japan.

[分散スケジューラ Apache Mesos](http://mesos.apache.org) のソースコー
ドを読んで解説しあい、その設計や挙動を明らかにし、知識を共有していくこ
とを目的としたローカルグループです。東京のローカルコミュニティなので日
本語が主要な言語になりますが、ソフトウェアの性質上、英語が使われること
もあります。

Mesos SCR JP is a local group to investigate and share its design
principle, details and behaviour by reading source code. Main
communication language is Japanese as this is a local community, but
English may also be used depending on circumstances.

# 進め方

* 発表者が決まると開催できます
* 月に1~2度集まって、 2名ほどがMesosのソースコードを解説する
* 発表者は、発表につかったテキスト、資料 (のURL）をこのレポジトリにコミット（PR）sうる
* Open Questions は随時募集中
* 基本的に平日夜、 19:00 ~ 21:00 開催

# 基礎知識

* Mesos paper
* Dominant Resource Fairness paper


# Open Questions or keywords

* libprocess
* Unified Containerizer
* Fetcher
* Master high availability, ZooKeeper usage, failover sequence
* What is Isolators?
* CGroups
* Roles, Authentication
* GPU support, isolation
* Pods / Task Groups
* Port mapping and CNI (Container Network Interface)
* Persistent Volume, Reservation
* Quota
* Resource Offer / Weighted Dominant Resource Fairness
* CommandInfo Executor
* V1 API protocol ( mesos.proto ) and Protocol Buffers
* Clients (Java, Python, C++)
* Replicated Logs
* mesos-execute, Marathon, Aurora, Chronos as framework examples
* systemd related structure
* Tests and CMake usage, build system

# 履歴 (history)

- [11/21 第0回](http://mesos-scr-jp.connpass.com/event/43819/)
