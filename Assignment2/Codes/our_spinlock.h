struct thread_spinlock{
    volatile uint lock;
    char *name;
};
static inline uint xchg(volatile uint *addr,uint newval){
    uint result;

    asm volatile("lock; xchgl %0, %1" :
                  "+m" (*addr), "=a" (result) :
                  "1" (newval) :
                  "cc");
    return result;
}
void thread_spin_init(struct thread_spinlock *lk){
    lk->lock = 0;
    lk->name = "null";
}

void thread_spin_lock(struct thread_spinlock *lk){
    while(xchg(&lk->lock,1)!=0);
    __sync_synchronize();
}

void thread_spin_unlock(struct thread_spinlock *lk){
    __sync_synchronize();
    asm volatile("movl $0, %0" : "+m" (lk->lock) : );
}
struct thread_spinlock lock;
