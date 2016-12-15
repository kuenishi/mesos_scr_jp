# libprocess memo
2016-12-15 @ashigeru

> Library that provides an actor style message-passing programming model (in C++).

* https://github.com/3rdparty/libprocess

## topic

* libprocess
  * `3rdparty/libprocess/**`
* Actorっぽく使える `process` を対象に
  * `future` など他にも重要なのは多数
  * `process` がMesos全体の根幹にあるので、何かあったときに多少読める程度に
* `process::` 配下の関数を軽くさらう
  * 今回はローカルメッセージング
  * (リモートまで進められなかった)

## source

* 51b151fbe771bd2a340a1820fba3d5047e8597d6
  * 1.1.0 よりは少し進んでるっぽい

## documents

* `3rdparty/libprocess/README.md`

## entry point

* `process::initialize()`
  * `src/exec/exec.cpp`
  * `src/sched/sched.cpp`
  * `src/local/main.cpp`
  * `src/master/main.cpp`
  * `src/slave/main.cpp`
  * `src/executor/executor.cpp`
  * `src/scheduler/scheduler.cpp`

## process.hpp

* `class ProcessBase < EventVisitor`
  * `EventVisitor` -> `event.hpp`
  * virtual
    * `serve(Event)`
      * -> `Event::visit(this) -> EventVisitor.visit(...)`
    * `visit({Message,Dispatch,Http,Exited,Terminate}Event)`
    * `initialize()`
    * `finalize()`
    * `exited(UPID)`
    * `lost(UPID)`
  * non-virtual
    * `inject`
    * `send`
    * `link`
    * `install()`
      * `handlers.message[name] = handler`
    * `delegate()`
      * `delegates[name] = pid`
    * `route`
    * `provide`
    * `_visit(....)`
* namespace
  * `initialize(...)` <- entry
  * `finalize()`
  * `spawn(ProcessBase*, bool)`
  * `terminate({ProcessBase*,UPID&}, ...)`
  * `wait({ProcessBase*,UPID&}, ...)`
  * `post(...)`
  * `extern THREAD_LOCAL ProcessBase* __process__`

## process.cpp

* namespace
  * `initialize(...)` L993 <- entry
    * `initialize_{started,complete}:atomic_boolean`  L564
    * `ProcessManager::new`
    * `SocketManager::new`
    * `EventLoop::initialize()`
    * `ProcessManager::init_threads()`
    * `spawn(GarbageCollector)`
    * `spawn(Help)`
    * `spawn(metrics::internal::MetricsProcess)`
    * `spawn(Logging)`
    * `spawn(Profiler)`
    * `spawn(System)`
    * `spawn(process::internal::ReaperProcess)`
  * `finalize(...)` L1248
    * `ProcessManager::finalize()`
    * `SocketManager::finalize()`
  * `spawn(...)` L3929
    * `ProcessManager::spawn()`
  * `terminate(...)` L3948
    * `ProcessManager::terminate(...)`
  * `wait(...)` L3992
    * `ProcessManager::wait(...)`
    * `WaitWaiter < Process` L3954
  * `post(...)` L4031
    * -> `transport()`
  * `transport(...)` L711
    * `ProcessManager::deliver(...)`
    * `SocketManager::send(...)`
* `ProcessBase`
  * `enqueue()` L3598
    * `ProcessBase.events.{back,front}(event)`
    * `ProcessManager::enqueue(this)`
  * `inject(...)` L3625
    * `enqueue(MessageEvent, ...)`
  * `send(...)` L3640
    * `transport(...)`
  * `visit(MessageEvent)` L3655
    * `ProcessBase::handlers.message[name](...)`
    * `transport(...)`
  * `visit(DispatchEvent)` L3671
    * -> `DispatchEvent::f(this)`
  * `visit(HttpEvent)` L3677
    * -> `_visit(...)`
  * `visit(ExitedEvent)` L3865
    * -> `ProcessBase::exited(...)`
  * `visit(TerminateEvent)` L3871
    * -> `ProcessBase::finalize()`
  * `link(...)` L3877
    * `ProcessManager::link(...)`
  * `internal::dispatch()` L4076
    * `ProcessManager::deliver(...)`
    * <- `dispatch.hpp` L157~
* `class ProcessManager` L469
  * `threads : std::vector<std::thread*>` L547
  * ctor L2585
  * `init_threads()` L2664
    * `struct worker`
      * `ProcessManager::dequeue()`
      * `ProcessManager::resume(ProcessBase*)`
    * `EventLoop::run`
      * at `libevent.cpp:94`
  * `finalize()` L2595
    * `process::terminate(...)`
    * `process:wait(...)`
    * `EventLoop::stop()`
    * `ProcessManager::threads*->join()`
   * `handle()` L2771
     * <- `internal::on_accept()` L923
   * `deliver()` L2956
     * `ProcessBase::enqueue(...)`
   * `spawn()` L2997
     * `if (manage) -> dispatch(gc...)`
     * `enqueue(process)`
   * `resume()` L3043
     * `ProcessBase::events.front()`
     * `ProcessorBase::serve(...)` -> `ProcessorBase::visit(...)`
   * `link()` L3251
     * `SocketManager::link()`
   * `terminate()` L3274
     * `ProcessBase::enqueue(new TerminateEvent(...))`
   * `wait()` L3294
     * `Gate::approach()`
     * `ProcessManager::resume(process)`
     * `Gate::alive()`
   * ...

