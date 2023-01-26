struct thread_mutex{
    volatile uint lock;
    char *name;
};
static inline uint xchg2(volatile uint *addr,uint newval){
    uint result;

    asm volatile("lock; xchgl %0, %1" :
                  "+m" (*addr), "=a" (result) :
                  "1" (newval) :
                  "cc");
    return result;
}
void thread_mutex_init(struct thread_mutex *lk){
    lk->lock = 0;
    lk->name = "null";
}

void thread_mutex_lock(struct thread_mutex *lk){
    while(xchg2(&lk->lock,1)!=0){
        sleep(1);
    }

    __sync_synchronize();
}

void thread_mutex_unlock(struct thread_mutex *lk){
    __sync_synchronize();
    asm volatile("movl $0, %0" : "+m" (lk->lock) : );
}

struct thread_mutex lock2;

