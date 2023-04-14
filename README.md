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

## Assignment 5
