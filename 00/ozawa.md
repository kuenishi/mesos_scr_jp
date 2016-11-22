
## Agenda

* I will read how scheduler works
	* src/master/allocator/*
* Let's read the code togather

### sorter

* A base class which has virtual methods
* DRFSorter is only one implementation

* (suppliment) I talked about how sorting and scheduling are related.

### DRFSorter

* Methods to be read
	* DRFComparator
	* DRFSorter::allocated
	* DRFSorter::sort
	* DRFSorter::activate

* allocator/sorter/drf/sorter.hpp

* (suppliment) I talked about summary of what's is DRF.

### Data structures shared between nodes

* include/mesos/v1/mesos.proto 

### What's next?

* When sorter is called?

* Source code
	* allocator/mesos/hierarchical.cpp

* Methods to be read
	* HierarchicalAllocatorProcess::addFramework
