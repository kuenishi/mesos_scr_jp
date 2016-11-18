Mesos Source Code Reading
=========================

2016/11/21 @さくらインターネットさま

ノーチラス・テクノロジーズ　上西


はい
======

始まって
=========

しまいました
=================

Mesos
=====

コードリーディング
========================

この会の目的
================

* `Apache Mesos の公式ドキュメント <http://mesos.apache.org/documentation/latest/>`_ は、内容が充実しているとはいえ細かい挙動までは把握しにくい
* 参加者（私）が仕事を進めていく上で必要な雑多な知識をコードから拾っていく
* 一人で読むと心が折れやすい

進め方  
=======

* 発表者とそのテーマが決まると開催
* 基本的には会の終了時に次回の予定を決める
* 発表者と会場の予定を最優先（基本的に平日夜、 19:00 ~ 21:00 開催）
* 月に1~2度集まって、 2名ほどがMesosのソースコードを解説する

* (Optional) 発表者は、発表につかったテキストや資料 (のURL）をこのレポジトリにコミット
* Open Questions は随時追加


全員自己紹介
================

* 氏名、 (Optional) 所属
* 技術的なバックグラウンド、または今取り組んでいること
* この会に参加する目的
* (Optional) Mesosに関する具体的な興味
* (Optional) C++わかりますか？  

とりあえず第0回ということで
=================================

* Mesosの 10,000 ft overview の説明
* よく分かってないところ

などをこれから話します  


Mesosのプロセス構成
===========================

* Mesos Master
* Mesos Agent
* (Optional) ZooKeeper

Mesos の特徴
====================

* Two-level scheduler という仕組み

* 基本的なアイディアは、リソース管理とスケジューリングを分割
* リソース管理と簡単なタスク管理をMesosが担当
* スケジューリングは、個々 Scheduler Framework が与えられたリソースの範囲内でやりくりする
* 両者をつなぐのが `Scheduler API <http://mesos.apache.org/documentation/latest/scheduler-http-api/>`_ と Resource Offer 

~~
  
* 代表的な分散スケジューラーは、リソースをリクエストしてもらうという形式
* リソーススケジューリングがモノリシックになってしまい、柔軟性がない
* 目的に応じてリソーススケジューリングを使い分けにくい
* Fair-share/Capacity, Preemptive/Non-preemptive
  
Mesosの基本的な構成とモジュール
======================================




Mesosの基本的な用語
=========================

先に読んでおきたい
====================

* libprocess
* 最小のフレームワーク: mesos-execute
* 全部のプロトコル: mesos.proto と通信まわりの実装
* Isolator 基本
* CommandInfo Executor
* Unified Containerizer 基本
* Fetcher (簡単に読めそう)

気になっているところ
========================

* Isolator 応用: linux/filesystem, docker/runtime, gpu/nvidia, cgroups/{cpu, mem, devices}
* Doninant Resource Fairness 論文とその実装
* Master - Agents間の障害検出
* 各クライアントの実装
* Boostrap, systemdまわり
  
コード以外なら…
===================

* Mesos論文解説

実際のコード
=================

何行？

ビルドしてみる

テストしてみる

必要なライブラリ

ディレクトリ構成

ビルドシステム概要

* FreeBSD は automake
* MacOS, Linux, Windows は  CMake

コミュニティ
===============

* http://mesos.apache.org/community/
* 活発なのはSlack ( mesos.slack.com ) とML
* 真面目なのはJIRA
* みんな割とフランク

Questions?
==========


Special Thanks and Resources
============================

This slide can be built by `rst2html5-tools <http://marianoguerra.github.io/rst2html5/>`_ with following options::

  rst2html5 --deck-js --pretty-print-code --embed-content bootstrap.rst

* `GitStats <http://gitstats.sourceforge.net/>`_

* `Mesos Frameworkの作り方 <https://speakerdeck.com/kuenishi/mesos-frameworkfalsezuo-rifang-how-to-make-mesos-framework>`_
* `分散スケジューラMesosの紹介 <https://speakerdeck.com/kuenishi/fen-san-sukeziyuramesosfalseshao-jie>`_
