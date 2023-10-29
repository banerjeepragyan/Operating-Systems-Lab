# Operating Systems Lab

As a part of the operating systems lab, we were asked to implement various aspects of an Operating System on xv6. The end result was that we were able to create a mini-OS with basic functionalities.

We implemented the various functionalities spread across different assignments.

## Assignment 1

This assignment was mostly to familiarise ourselves with xv6. We defined a basic system call for our mini OS.
The output-

![image](https://user-images.githubusercontent.com/88557062/232106419-99d7bc4f-b1f3-4a8b-bf78-bea2b0b971ba.png)

## Assignment 2

We first implemented kernel threads and then built spinlocks and mutexes to synchronize access among them. To make it more real and fun, we implemented interface of the POSIX threads that are de facto standard on most UNIX systems.

For implementing threads, we created three system calls- 
- thread_create()
- thread_join()
- thread_exit()

![image](https://user-images.githubusercontent.com/88557062/232112106-221152d0-1223-4b7c-acf1-09cdde14a88c.png)

Which is not giving the correct answer which is (3200+2800) 6000 and also throwing different answers as expected because we haven’t implemented any sort of synchronisation so far.

For implementing spinlocks, we created two system calls-
- thread_spin_lock()
- thread_spin_unlock()

![image](https://user-images.githubusercontent.com/88557062/232112531-0c191da5-d9c9-465d-8268-4acb70c82457.png)

We got the correct answer as 6000, but it is slower. So, we implement mutexes which are comparitively faster.

For implementing mutexes, we created three system calls-
- thread_mutex_init()
- thread_mutex_lock()
- thread_mutex_unlock()

![image](https://user-images.githubusercontent.com/88557062/232112908-c4a11c0c-46cb-4c31-a0de-5a6fdb1c7afa.png)

We got the correct answer as 6000, and the time taken was low as well.

## Assignment 3

## Assignment 4

It had 2 parts.

### Part A

In this part of the lab, we have implemented the Lazy Memory Allocation for xv6, which is a feature in most modern operating systems. In the case of the original xv6, it makes use of the sbrk() system call, to allocate physical memory and map it to the virtual address space. In the first section, we modified the sbrk() system call to remove the memory allocation and cause a page fault. In the second section, we have modified the trap.c file to resolve this page fault via lazy allocation.

![image](https://github.com/banerjeepragyan/Operating-Systems-Lab/assets/88557062/498169bf-d2da-442d-9ea5-7a388aef1a3a)

### Part B

The create_kernel_process() function was created in proc.c. The kernel process will remain in kernel mode the whole time. Thus, we do not need to initialise its trapframe (trapframes store userspace register values), user space and the user section of its page table. The eip register of the process’ context stores the address of the next instruction. We want the process to start executing at the entry point (which is a function pointer).

Also, we created a process queue that keeps track of the processes that were refused additional memory since there were no free pages available. We created a circular queue struct called rq. And the specific queue that holds processes with swap out requests is rqueue. We have also created the functions corresponding to rq, namely rpush() and rpop(). The queue needs to be accessed with a lock that we have initialised in pinit. We have also initialised the initial values of s and e to zero in Userinit. Since the queue and the functions relating to it are needed in other files too, we added prototypes in defs.h too.

![image](https://github.com/banerjeepragyan/Operating-Systems-Lab/assets/88557062/ae7d2e7d-941f-4d56-8499-3e31ffb02fa8)

## Assignment 5
