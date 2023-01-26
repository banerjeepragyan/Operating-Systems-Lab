
_thread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "Done s:%x\n", b->name);
    thread_exit();

    return;
}
int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp

    //thread_spin_init(&lock);
    thread_mutex_init(&lock2);

    struct balance b1 = {"b1", 3200};
   7:	31 d2                	xor    %edx,%edx
   9:	31 c0                	xor    %eax,%eax
int main(int argc, char *argv[]) {
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 58             	sub    $0x58,%esp
                  "1" (newval) :
                  "cc");
    return result;
}
void thread_mutex_init(struct thread_mutex *lk){
    lk->lock = 0;
  18:	c7 05 d8 0d 00 00 00 	movl   $0x0,0xdd8
  1f:	00 00 00 
    lk->name = "null";
  22:	c7 05 dc 0d 00 00 98 	movl   $0x998,0xddc
  29:	09 00 00 
    struct balance b1 = {"b1", 3200};
  2c:	c7 45 a0 62 31 00 00 	movl   $0x3162,-0x60(%ebp)
  33:	89 54 05 a4          	mov    %edx,-0x5c(%ebp,%eax,1)
  37:	83 c0 04             	add    $0x4,%eax
  3a:	83 f8 1c             	cmp    $0x1c,%eax
  3d:	72 f4                	jb     33 <main+0x33>
  3f:	c7 45 c0 80 0c 00 00 	movl   $0xc80,-0x40(%ebp)
    struct balance b2 = {"b2", 2800};
  46:	c7 45 c4 62 32 00 00 	movl   $0x3262,-0x3c(%ebp)
  4d:	31 d2                	xor    %edx,%edx
  4f:	31 c0                	xor    %eax,%eax
  51:	89 54 05 c8          	mov    %edx,-0x38(%ebp,%eax,1)
  55:	83 c0 04             	add    $0x4,%eax
  58:	83 f8 1c             	cmp    $0x1c,%eax
  5b:	72 f4                	jb     51 <main+0x51>

    void *s1, *s2;
    int t1, t2, r1, r2;

    s1 = malloc(4096);
  5d:	83 ec 0c             	sub    $0xc,%esp
    struct balance b2 = {"b2", 2800};
  60:	c7 45 e4 f0 0a 00 00 	movl   $0xaf0,-0x1c(%ebp)
    s1 = malloc(4096);
  67:	68 00 10 00 00       	push   $0x1000
  6c:	e8 2f 08 00 00       	call   8a0 <malloc>
    s2 = malloc(4096);
  71:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    s1 = malloc(4096);
  78:	89 c3                	mov    %eax,%ebx
    s2 = malloc(4096);
  7a:	e8 21 08 00 00       	call   8a0 <malloc>
  7f:	89 c6                	mov    %eax,%esi

    t1 = thread_create(do_work, (void*)&b1, s1);
  81:	8d 45 a0             	lea    -0x60(%ebp),%eax
  84:	83 c4 0c             	add    $0xc,%esp
  87:	53                   	push   %ebx
  88:	50                   	push   %eax
  89:	68 50 01 00 00       	push   $0x150
  8e:	e8 df 04 00 00       	call   572 <thread_create>
  93:	89 c3                	mov    %eax,%ebx
    t2 = thread_create(do_work, (void*)&b2, s2);
  95:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  98:	83 c4 0c             	add    $0xc,%esp
  9b:	56                   	push   %esi
  9c:	50                   	push   %eax
  9d:	68 50 01 00 00       	push   $0x150
  a2:	e8 cb 04 00 00       	call   572 <thread_create>
  a7:	89 c7                	mov    %eax,%edi

    r1 = thread_join();
  a9:	e8 cc 04 00 00       	call   57a <thread_join>
  ae:	89 c6                	mov    %eax,%esi
    r2 = thread_join();
  b0:	e8 c5 04 00 00       	call   57a <thread_join>

    printf(1, "Threads finished: (%d):%d, (%d):%d, shared balance:%d\n",
  b5:	8b 15 c0 0d 00 00    	mov    0xdc0,%edx
  bb:	83 c4 0c             	add    $0xc,%esp
  be:	52                   	push   %edx
  bf:	50                   	push   %eax
  c0:	57                   	push   %edi
  c1:	56                   	push   %esi
  c2:	53                   	push   %ebx
  c3:	68 c0 09 00 00       	push   $0x9c0
  c8:	6a 01                	push   $0x1
  ca:	e8 71 05 00 00       	call   640 <printf>
    t1, r1, t2, r2, total_balance);
    exit();
  cf:	83 c4 20             	add    $0x20,%esp
  d2:	e8 fb 03 00 00       	call   4d2 <exit>
  d7:	66 90                	xchg   %ax,%ax
  d9:	66 90                	xchg   %ax,%ax
  db:	66 90                	xchg   %ax,%ax
  dd:	66 90                	xchg   %ax,%ax
  df:	90                   	nop

000000e0 <thread_mutex_init>:
void thread_mutex_init(struct thread_mutex *lk){
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->lock = 0;
  e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = "null";
  ec:	c7 40 04 98 09 00 00 	movl   $0x998,0x4(%eax)
}
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <thread_mutex_lock>:

void thread_mutex_lock(struct thread_mutex *lk){
 100:	55                   	push   %ebp
    asm volatile("lock; xchgl %0, %1" :
 101:	b8 01 00 00 00       	mov    $0x1,%eax
void thread_mutex_lock(struct thread_mutex *lk){
 106:	89 e5                	mov    %esp,%ebp
 108:	56                   	push   %esi
 109:	53                   	push   %ebx
 10a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    asm volatile("lock; xchgl %0, %1" :
 10d:	f0 87 03             	lock xchg %eax,(%ebx)
    while(xchg2(&lk->lock,1)!=0){
 110:	85 c0                	test   %eax,%eax
 112:	74 22                	je     136 <thread_mutex_lock+0x36>
    asm volatile("lock; xchgl %0, %1" :
 114:	be 01 00 00 00       	mov    $0x1,%esi
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sleep(1);
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	6a 01                	push   $0x1
 125:	e8 38 04 00 00       	call   562 <sleep>
    asm volatile("lock; xchgl %0, %1" :
 12a:	89 f0                	mov    %esi,%eax
 12c:	f0 87 03             	lock xchg %eax,(%ebx)
    while(xchg2(&lk->lock,1)!=0){
 12f:	83 c4 10             	add    $0x10,%esp
 132:	85 c0                	test   %eax,%eax
 134:	75 ea                	jne    120 <thread_mutex_lock+0x20>
    }

    __sync_synchronize();
 136:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
 13b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    
 142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <do_work>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	56                   	push   %esi
 154:	53                   	push   %ebx
 155:	8b 5d 08             	mov    0x8(%ebp),%ebx
    printf(1, "Starting do_work: s:%s\n", b->name);
 158:	83 ec 04             	sub    $0x4,%esp
 15b:	53                   	push   %ebx
 15c:	68 9d 09 00 00       	push   $0x99d
 161:	6a 01                	push   $0x1
 163:	e8 d8 04 00 00       	call   640 <printf>
    for (i = 0; i < b->amount; i++){
 168:	8b 43 20             	mov    0x20(%ebx),%eax
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	85 c0                	test   %eax,%eax
 170:	7e 4b                	jle    1bd <do_work+0x6d>
 172:	31 f6                	xor    %esi,%esi
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        thread_mutex_lock(&lock2);
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	68 d8 0d 00 00       	push   $0xdd8
 180:	e8 7b ff ff ff       	call   100 <thread_mutex_lock>
        old = total_balance;
 185:	8b 15 c0 0d 00 00    	mov    0xdc0,%edx
 18b:	83 c4 10             	add    $0x10,%esp
 18e:	b8 a0 86 01 00       	mov    $0x186a0,%eax
 193:	90                   	nop
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    __asm volatile( "nop" ::: );
 198:	90                   	nop
    for (i = 0; i < d; i++)
 199:	83 e8 01             	sub    $0x1,%eax
 19c:	75 fa                	jne    198 <do_work+0x48>
        total_balance = old + 1;
 19e:	8d 42 01             	lea    0x1(%edx),%eax
 1a1:	a3 c0 0d 00 00       	mov    %eax,0xdc0

void thread_mutex_unlock(struct thread_mutex *lk){
    __sync_synchronize();
 1a6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile("movl $0, %0" : "+m" (lk->lock) : );
 1ab:	c7 05 d8 0d 00 00 00 	movl   $0x0,0xdd8
 1b2:	00 00 00 
    for (i = 0; i < b->amount; i++){
 1b5:	83 c6 01             	add    $0x1,%esi
 1b8:	39 73 20             	cmp    %esi,0x20(%ebx)
 1bb:	7f bb                	jg     178 <do_work+0x28>
    printf(1, "Done s:%x\n", b->name);
 1bd:	83 ec 04             	sub    $0x4,%esp
 1c0:	53                   	push   %ebx
 1c1:	68 b5 09 00 00       	push   $0x9b5
 1c6:	6a 01                	push   $0x1
 1c8:	e8 73 04 00 00       	call   640 <printf>
    thread_exit();
 1cd:	83 c4 10             	add    $0x10,%esp
}
 1d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5d                   	pop    %ebp
    thread_exit();
 1d6:	e9 a7 03 00 00       	jmp    582 <thread_exit>
 1db:	90                   	nop
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001e0 <thread_mutex_unlock>:
void thread_mutex_unlock(struct thread_mutex *lk){
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
    __sync_synchronize();
 1e6:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile("movl $0, %0" : "+m" (lk->lock) : );
 1eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <thread_spin_init>:
                  "+m" (*addr), "=a" (result) :
                  "1" (newval) :
                  "cc");
    return result;
}
void thread_spin_init(struct thread_spinlock *lk){
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->lock = 0;
 206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = "null";
 20c:	c7 40 04 98 09 00 00 	movl   $0x998,0x4(%eax)
}
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <thread_spin_lock>:

void thread_spin_lock(struct thread_spinlock *lk){
 220:	55                   	push   %ebp
    asm volatile("lock; xchgl %0, %1" :
 221:	b9 01 00 00 00       	mov    $0x1,%ecx
void thread_spin_lock(struct thread_spinlock *lk){
 226:	89 e5                	mov    %esp,%ebp
 228:	8b 55 08             	mov    0x8(%ebp),%edx
 22b:	90                   	nop
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    asm volatile("lock; xchgl %0, %1" :
 230:	89 c8                	mov    %ecx,%eax
 232:	f0 87 02             	lock xchg %eax,(%edx)
    while(xchg(&lk->lock,1)!=0);
 235:	85 c0                	test   %eax,%eax
 237:	75 f7                	jne    230 <thread_spin_lock+0x10>
    __sync_synchronize();
 239:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <thread_spin_unlock>:

void thread_spin_unlock(struct thread_spinlock *lk){
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
    __sync_synchronize();
 246:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile("movl $0, %0" : "+m" (lk->lock) : );
 24b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <delay>:
volatile unsigned int delay (unsigned int d){
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 45 08             	mov    0x8(%ebp),%eax
    for (i = 0; i < d; i++)
 266:	85 c0                	test   %eax,%eax
 268:	74 0e                	je     278 <delay+0x18>
 26a:	31 d2                	xor    %edx,%edx
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    __asm volatile( "nop" ::: );
 270:	90                   	nop
    for (i = 0; i < d; i++)
 271:	83 c2 01             	add    $0x1,%edx
 274:	39 d0                	cmp    %edx,%eax
 276:	75 f8                	jne    270 <delay+0x10>
}
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	66 90                	xchg   %ax,%ax
 27c:	66 90                	xchg   %ax,%ax
 27e:	66 90                	xchg   %ax,%ax

00000280 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 28a:	89 c2                	mov    %eax,%edx
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 290:	83 c1 01             	add    $0x1,%ecx
 293:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 297:	83 c2 01             	add    $0x1,%edx
 29a:	84 db                	test   %bl,%bl
 29c:	88 5a ff             	mov    %bl,-0x1(%edx)
 29f:	75 ef                	jne    290 <strcpy+0x10>
    ;
  return os;
}
 2a1:	5b                   	pop    %ebx
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret    
 2a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
 2b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2ba:	0f b6 02             	movzbl (%edx),%eax
 2bd:	0f b6 19             	movzbl (%ecx),%ebx
 2c0:	84 c0                	test   %al,%al
 2c2:	75 1c                	jne    2e0 <strcmp+0x30>
 2c4:	eb 2a                	jmp    2f0 <strcmp+0x40>
 2c6:	8d 76 00             	lea    0x0(%esi),%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2d6:	83 c1 01             	add    $0x1,%ecx
 2d9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2dc:	84 c0                	test   %al,%al
 2de:	74 10                	je     2f0 <strcmp+0x40>
 2e0:	38 d8                	cmp    %bl,%al
 2e2:	74 ec                	je     2d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2e4:	29 d8                	sub    %ebx,%eax
}
 2e6:	5b                   	pop    %ebx
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2f2:	29 d8                	sub    %ebx,%eax
}
 2f4:	5b                   	pop    %ebx
 2f5:	5d                   	pop    %ebp
 2f6:	c3                   	ret    
 2f7:	89 f6                	mov    %esi,%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <strlen>:

uint
strlen(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 306:	80 39 00             	cmpb   $0x0,(%ecx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 d2                	xor    %edx,%edx
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c2 01             	add    $0x1,%edx
 313:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 317:	89 d0                	mov    %edx,%eax
 319:	75 f5                	jne    310 <strlen+0x10>
    ;
  return n;
}
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    
 31d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 320:	31 c0                	xor    %eax,%eax
}
 322:	5d                   	pop    %ebp
 323:	c3                   	ret    
 324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 32a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld    
 340:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 342:	89 d0                	mov    %edx,%eax
 344:	5f                   	pop    %edi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	89 f6                	mov    %esi,%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <strchr>:

char*
strchr(const char *s, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	74 1d                	je     37e <strchr+0x2e>
    if(*s == c)
 361:	38 d3                	cmp    %dl,%bl
 363:	89 d9                	mov    %ebx,%ecx
 365:	75 0d                	jne    374 <strchr+0x24>
 367:	eb 17                	jmp    380 <strchr+0x30>
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 370:	38 ca                	cmp    %cl,%dl
 372:	74 0c                	je     380 <strchr+0x30>
  for(; *s; s++)
 374:	83 c0 01             	add    $0x1,%eax
 377:	0f b6 10             	movzbl (%eax),%edx
 37a:	84 d2                	test   %dl,%dl
 37c:	75 f2                	jne    370 <strchr+0x20>
      return (char*)s;
  return 0;
 37e:	31 c0                	xor    %eax,%eax
}
 380:	5b                   	pop    %ebx
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    
 383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	31 f6                	xor    %esi,%esi
 398:	89 f3                	mov    %esi,%ebx
{
 39a:	83 ec 1c             	sub    $0x1c,%esp
 39d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3a0:	eb 2f                	jmp    3d1 <gets+0x41>
 3a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3ab:	83 ec 04             	sub    $0x4,%esp
 3ae:	6a 01                	push   $0x1
 3b0:	50                   	push   %eax
 3b1:	6a 00                	push   $0x0
 3b3:	e8 32 01 00 00       	call   4ea <read>
    if(cc < 1)
 3b8:	83 c4 10             	add    $0x10,%esp
 3bb:	85 c0                	test   %eax,%eax
 3bd:	7e 1c                	jle    3db <gets+0x4b>
      break;
    buf[i++] = c;
 3bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3c3:	83 c7 01             	add    $0x1,%edi
 3c6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3c9:	3c 0a                	cmp    $0xa,%al
 3cb:	74 23                	je     3f0 <gets+0x60>
 3cd:	3c 0d                	cmp    $0xd,%al
 3cf:	74 1f                	je     3f0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3d1:	83 c3 01             	add    $0x1,%ebx
 3d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3d7:	89 fe                	mov    %edi,%esi
 3d9:	7c cd                	jl     3a8 <gets+0x18>
 3db:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3e0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e6:	5b                   	pop    %ebx
 3e7:	5e                   	pop    %esi
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    
 3eb:	90                   	nop
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f0:	8b 75 08             	mov    0x8(%ebp),%esi
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	01 de                	add    %ebx,%esi
 3f8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3fa:	c6 03 00             	movb   $0x0,(%ebx)
}
 3fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 400:	5b                   	pop    %ebx
 401:	5e                   	pop    %esi
 402:	5f                   	pop    %edi
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    
 405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <stat>:

int
stat(const char *n, struct stat *st)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 415:	83 ec 08             	sub    $0x8,%esp
 418:	6a 00                	push   $0x0
 41a:	ff 75 08             	pushl  0x8(%ebp)
 41d:	e8 f0 00 00 00       	call   512 <open>
  if(fd < 0)
 422:	83 c4 10             	add    $0x10,%esp
 425:	85 c0                	test   %eax,%eax
 427:	78 27                	js     450 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	ff 75 0c             	pushl  0xc(%ebp)
 42f:	89 c3                	mov    %eax,%ebx
 431:	50                   	push   %eax
 432:	e8 f3 00 00 00       	call   52a <fstat>
  close(fd);
 437:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 43a:	89 c6                	mov    %eax,%esi
  close(fd);
 43c:	e8 b9 00 00 00       	call   4fa <close>
  return r;
 441:	83 c4 10             	add    $0x10,%esp
}
 444:	8d 65 f8             	lea    -0x8(%ebp),%esp
 447:	89 f0                	mov    %esi,%eax
 449:	5b                   	pop    %ebx
 44a:	5e                   	pop    %esi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 450:	be ff ff ff ff       	mov    $0xffffffff,%esi
 455:	eb ed                	jmp    444 <stat+0x34>
 457:	89 f6                	mov    %esi,%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <atoi>:

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	53                   	push   %ebx
 464:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 467:	0f be 11             	movsbl (%ecx),%edx
 46a:	8d 42 d0             	lea    -0x30(%edx),%eax
 46d:	3c 09                	cmp    $0x9,%al
  n = 0;
 46f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 474:	77 1f                	ja     495 <atoi+0x35>
 476:	8d 76 00             	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 480:	8d 04 80             	lea    (%eax,%eax,4),%eax
 483:	83 c1 01             	add    $0x1,%ecx
 486:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 48a:	0f be 11             	movsbl (%ecx),%edx
 48d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 490:	80 fb 09             	cmp    $0x9,%bl
 493:	76 eb                	jbe    480 <atoi+0x20>
  return n;
}
 495:	5b                   	pop    %ebx
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
 498:	90                   	nop
 499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
 4a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 db                	test   %ebx,%ebx
 4b0:	7e 14                	jle    4c6 <memmove+0x26>
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4c2:	39 d3                	cmp    %edx,%ebx
 4c4:	75 f2                	jne    4b8 <memmove+0x18>
  return vdst;
}
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    

000004ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ca:	b8 01 00 00 00       	mov    $0x1,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exit>:
SYSCALL(exit)
 4d2:	b8 02 00 00 00       	mov    $0x2,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <wait>:
SYSCALL(wait)
 4da:	b8 03 00 00 00       	mov    $0x3,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <pipe>:
SYSCALL(pipe)
 4e2:	b8 04 00 00 00       	mov    $0x4,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <read>:
SYSCALL(read)
 4ea:	b8 05 00 00 00       	mov    $0x5,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <write>:
SYSCALL(write)
 4f2:	b8 10 00 00 00       	mov    $0x10,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <close>:
SYSCALL(close)
 4fa:	b8 15 00 00 00       	mov    $0x15,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <kill>:
SYSCALL(kill)
 502:	b8 06 00 00 00       	mov    $0x6,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <exec>:
SYSCALL(exec)
 50a:	b8 07 00 00 00       	mov    $0x7,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <open>:
SYSCALL(open)
 512:	b8 0f 00 00 00       	mov    $0xf,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <mknod>:
SYSCALL(mknod)
 51a:	b8 11 00 00 00       	mov    $0x11,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <unlink>:
SYSCALL(unlink)
 522:	b8 12 00 00 00       	mov    $0x12,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <fstat>:
SYSCALL(fstat)
 52a:	b8 08 00 00 00       	mov    $0x8,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <link>:
SYSCALL(link)
 532:	b8 13 00 00 00       	mov    $0x13,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mkdir>:
SYSCALL(mkdir)
 53a:	b8 14 00 00 00       	mov    $0x14,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <chdir>:
SYSCALL(chdir)
 542:	b8 09 00 00 00       	mov    $0x9,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <dup>:
SYSCALL(dup)
 54a:	b8 0a 00 00 00       	mov    $0xa,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <getpid>:
SYSCALL(getpid)
 552:	b8 0b 00 00 00       	mov    $0xb,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <sbrk>:
SYSCALL(sbrk)
 55a:	b8 0c 00 00 00       	mov    $0xc,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <sleep>:
SYSCALL(sleep)
 562:	b8 0d 00 00 00       	mov    $0xd,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <uptime>:
SYSCALL(uptime)
 56a:	b8 0e 00 00 00       	mov    $0xe,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <thread_create>:
SYSCALL(thread_create)
 572:	b8 16 00 00 00       	mov    $0x16,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <thread_join>:
SYSCALL(thread_join)
 57a:	b8 18 00 00 00       	mov    $0x18,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <thread_exit>:
SYSCALL(thread_exit)
 582:	b8 17 00 00 00       	mov    $0x17,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <draw>:
 58a:	b8 19 00 00 00       	mov    $0x19,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    
 592:	66 90                	xchg   %ax,%ax
 594:	66 90                	xchg   %ax,%ax
 596:	66 90                	xchg   %ax,%ax
 598:	66 90                	xchg   %ax,%ax
 59a:	66 90                	xchg   %ax,%ax
 59c:	66 90                	xchg   %ax,%ax
 59e:	66 90                	xchg   %ax,%ax

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a9:	85 d2                	test   %edx,%edx
{
 5ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 5ae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5b0:	79 76                	jns    628 <printint+0x88>
 5b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5b6:	74 70                	je     628 <printint+0x88>
    x = -xx;
 5b8:	f7 d8                	neg    %eax
    neg = 1;
 5ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5c1:	31 f6                	xor    %esi,%esi
 5c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5c6:	eb 0a                	jmp    5d2 <printint+0x32>
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 fe                	mov    %edi,%esi
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	8d 7e 01             	lea    0x1(%esi),%edi
 5d7:	f7 f1                	div    %ecx
 5d9:	0f b6 92 00 0a 00 00 	movzbl 0xa00(%edx),%edx
  }while((x /= base) != 0);
 5e0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5e5:	75 e9                	jne    5d0 <printint+0x30>
  if(neg)
 5e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ea:	85 c0                	test   %eax,%eax
 5ec:	74 08                	je     5f6 <printint+0x56>
    buf[i++] = '-';
 5ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5f3:	8d 7e 02             	lea    0x2(%esi),%edi
 5f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
 600:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	83 ee 01             	sub    $0x1,%esi
 609:	6a 01                	push   $0x1
 60b:	53                   	push   %ebx
 60c:	57                   	push   %edi
 60d:	88 45 d7             	mov    %al,-0x29(%ebp)
 610:	e8 dd fe ff ff       	call   4f2 <write>

  while(--i >= 0)
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x60>
    putc(fd, buf[i]);
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 628:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 62f:	eb 90                	jmp    5c1 <printint+0x21>
 631:	eb 0d                	jmp    640 <printf>
 633:	90                   	nop
 634:	90                   	nop
 635:	90                   	nop
 636:	90                   	nop
 637:	90                   	nop
 638:	90                   	nop
 639:	90                   	nop
 63a:	90                   	nop
 63b:	90                   	nop
 63c:	90                   	nop
 63d:	90                   	nop
 63e:	90                   	nop
 63f:	90                   	nop

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
 64c:	0f b6 1e             	movzbl (%esi),%ebx
 64f:	84 db                	test   %bl,%bl
 651:	0f 84 b3 00 00 00    	je     70a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 657:	8d 45 10             	lea    0x10(%ebp),%eax
 65a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 65d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 65f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 662:	eb 2f                	jmp    693 <printf+0x53>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 668:	83 f8 25             	cmp    $0x25,%eax
 66b:	0f 84 a7 00 00 00    	je     718 <printf+0xd8>
  write(fd, &c, 1);
 671:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 674:	83 ec 04             	sub    $0x4,%esp
 677:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 67a:	6a 01                	push   $0x1
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 6d fe ff ff       	call   4f2 <write>
 685:	83 c4 10             	add    $0x10,%esp
 688:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 68b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 68f:	84 db                	test   %bl,%bl
 691:	74 77                	je     70a <printf+0xca>
    if(state == 0){
 693:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 695:	0f be cb             	movsbl %bl,%ecx
 698:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 69b:	74 cb                	je     668 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69d:	83 ff 25             	cmp    $0x25,%edi
 6a0:	75 e6                	jne    688 <printf+0x48>
      if(c == 'd'){
 6a2:	83 f8 64             	cmp    $0x64,%eax
 6a5:	0f 84 05 01 00 00    	je     7b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6b1:	83 f9 70             	cmp    $0x70,%ecx
 6b4:	74 72                	je     728 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6b6:	83 f8 73             	cmp    $0x73,%eax
 6b9:	0f 84 99 00 00 00    	je     758 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bf:	83 f8 63             	cmp    $0x63,%eax
 6c2:	0f 84 08 01 00 00    	je     7d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	0f 84 ef 00 00 00    	je     7c0 <printf+0x180>
  write(fd, &c, 1);
 6d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6d4:	83 ec 04             	sub    $0x4,%esp
 6d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6db:	6a 01                	push   $0x1
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 0c fe ff ff       	call   4f2 <write>
 6e6:	83 c4 0c             	add    $0xc,%esp
 6e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ef:	6a 01                	push   $0x1
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6f8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6fa:	e8 f3 fd ff ff       	call   4f2 <write>
  for(i = 0; fmt[i]; i++){
 6ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 706:	84 db                	test   %bl,%bl
 708:	75 89                	jne    693 <printf+0x53>
    }
  }
}
 70a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 718:	bf 25 00 00 00       	mov    $0x25,%edi
 71d:	e9 66 ff ff ff       	jmp    688 <printf+0x48>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 728:	83 ec 0c             	sub    $0xc,%esp
 72b:	b9 10 00 00 00       	mov    $0x10,%ecx
 730:	6a 00                	push   $0x0
 732:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	8b 17                	mov    (%edi),%edx
 73a:	e8 61 fe ff ff       	call   5a0 <printint>
        ap++;
 73f:	89 f8                	mov    %edi,%eax
 741:	83 c4 10             	add    $0x10,%esp
      state = 0;
 744:	31 ff                	xor    %edi,%edi
        ap++;
 746:	83 c0 04             	add    $0x4,%eax
 749:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 74c:	e9 37 ff ff ff       	jmp    688 <printf+0x48>
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 75b:	8b 08                	mov    (%eax),%ecx
        ap++;
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 763:	85 c9                	test   %ecx,%ecx
 765:	0f 84 8e 00 00 00    	je     7f9 <printf+0x1b9>
        while(*s != 0){
 76b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 76e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 770:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 772:	84 c0                	test   %al,%al
 774:	0f 84 0e ff ff ff    	je     688 <printf+0x48>
 77a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 77d:	89 de                	mov    %ebx,%esi
 77f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 782:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 785:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 788:	83 ec 04             	sub    $0x4,%esp
          s++;
 78b:	83 c6 01             	add    $0x1,%esi
 78e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 791:	6a 01                	push   $0x1
 793:	57                   	push   %edi
 794:	53                   	push   %ebx
 795:	e8 58 fd ff ff       	call   4f2 <write>
        while(*s != 0){
 79a:	0f b6 06             	movzbl (%esi),%eax
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	84 c0                	test   %al,%al
 7a2:	75 e4                	jne    788 <printf+0x148>
 7a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7a7:	31 ff                	xor    %edi,%edi
 7a9:	e9 da fe ff ff       	jmp    688 <printf+0x48>
 7ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	e9 73 ff ff ff       	jmp    732 <printf+0xf2>
 7bf:	90                   	nop
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7c9:	6a 01                	push   $0x1
 7cb:	e9 21 ff ff ff       	jmp    6f1 <printf+0xb1>
        putc(fd, *ap);
 7d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7d8:	6a 01                	push   $0x1
        ap++;
 7da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7e3:	50                   	push   %eax
 7e4:	ff 75 08             	pushl  0x8(%ebp)
 7e7:	e8 06 fd ff ff       	call   4f2 <write>
        ap++;
 7ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7f2:	31 ff                	xor    %edi,%edi
 7f4:	e9 8f fe ff ff       	jmp    688 <printf+0x48>
          s = "(null)";
 7f9:	bb f8 09 00 00       	mov    $0x9f8,%ebx
        while(*s != 0){
 7fe:	b8 28 00 00 00       	mov    $0x28,%eax
 803:	e9 72 ff ff ff       	jmp    77a <printf+0x13a>
 808:	66 90                	xchg   %ax,%ax
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 c4 0d 00 00       	mov    0xdc4,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	39 c8                	cmp    %ecx,%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	73 32                	jae    860 <free+0x50>
 82e:	39 d1                	cmp    %edx,%ecx
 830:	72 04                	jb     836 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	39 d0                	cmp    %edx,%eax
 834:	72 32                	jb     868 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 836:	8b 73 fc             	mov    -0x4(%ebx),%esi
 839:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83c:	39 fa                	cmp    %edi,%edx
 83e:	74 30                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 840:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 849:	39 f1                	cmp    %esi,%ecx
 84b:	74 3a                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 84d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 84f:	a3 c4 0d 00 00       	mov    %eax,0xdc4
}
 854:	5b                   	pop    %ebx
 855:	5e                   	pop    %esi
 856:	5f                   	pop    %edi
 857:	5d                   	pop    %ebp
 858:	c3                   	ret    
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 d0                	cmp    %edx,%eax
 862:	72 04                	jb     868 <free+0x58>
 864:	39 d1                	cmp    %edx,%ecx
 866:	72 ce                	jb     836 <free+0x26>
{
 868:	89 d0                	mov    %edx,%eax
 86a:	eb bc                	jmp    828 <free+0x18>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 c6                	jne    84d <free+0x3d>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 c4 0d 00 00       	mov    %eax,0xdc4
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 53 f8             	mov    -0x8(%ebx),%edx
 895:	89 10                	mov    %edx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret    
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 c4 0d 00 00    	mov    0xdc4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 78 07             	lea    0x7(%eax),%edi
 8b5:	c1 ef 03             	shr    $0x3,%edi
 8b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8bb:	85 d2                	test   %edx,%edx
 8bd:	0f 84 9d 00 00 00    	je     960 <malloc+0xc0>
 8c3:	8b 02                	mov    (%edx),%eax
 8c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	76 6c                	jbe    938 <malloc+0x98>
 8cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8e1:	eb 0e                	jmp    8f1 <malloc+0x51>
 8e3:	90                   	nop
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ea:	8b 48 04             	mov    0x4(%eax),%ecx
 8ed:	39 f9                	cmp    %edi,%ecx
 8ef:	73 47                	jae    938 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	39 05 c4 0d 00 00    	cmp    %eax,0xdc4
 8f7:	89 c2                	mov    %eax,%edx
 8f9:	75 ed                	jne    8e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	56                   	push   %esi
 8ff:	e8 56 fc ff ff       	call   55a <sbrk>
  if(p == (char*)-1)
 904:	83 c4 10             	add    $0x10,%esp
 907:	83 f8 ff             	cmp    $0xffffffff,%eax
 90a:	74 1c                	je     928 <malloc+0x88>
  hp->s.size = nu;
 90c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 90f:	83 ec 0c             	sub    $0xc,%esp
 912:	83 c0 08             	add    $0x8,%eax
 915:	50                   	push   %eax
 916:	e8 f5 fe ff ff       	call   810 <free>
  return freep;
 91b:	8b 15 c4 0d 00 00    	mov    0xdc4,%edx
      if((p = morecore(nunits)) == 0)
 921:	83 c4 10             	add    $0x10,%esp
 924:	85 d2                	test   %edx,%edx
 926:	75 c0                	jne    8e8 <malloc+0x48>
        return 0;
  }
}
 928:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 92b:	31 c0                	xor    %eax,%eax
}
 92d:	5b                   	pop    %ebx
 92e:	5e                   	pop    %esi
 92f:	5f                   	pop    %edi
 930:	5d                   	pop    %ebp
 931:	c3                   	ret    
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 938:	39 cf                	cmp    %ecx,%edi
 93a:	74 54                	je     990 <malloc+0xf0>
        p->s.size -= nunits;
 93c:	29 f9                	sub    %edi,%ecx
 93e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 941:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 944:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 947:	89 15 c4 0d 00 00    	mov    %edx,0xdc4
}
 94d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 950:	83 c0 08             	add    $0x8,%eax
}
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
 958:	90                   	nop
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 c4 0d 00 00 c8 	movl   $0xdc8,0xdc4
 967:	0d 00 00 
 96a:	c7 05 c8 0d 00 00 c8 	movl   $0xdc8,0xdc8
 971:	0d 00 00 
    base.s.size = 0;
 974:	b8 c8 0d 00 00       	mov    $0xdc8,%eax
 979:	c7 05 cc 0d 00 00 00 	movl   $0x0,0xdcc
 980:	00 00 00 
 983:	e9 44 ff ff ff       	jmp    8cc <malloc+0x2c>
 988:	90                   	nop
 989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb b1                	jmp    947 <malloc+0xa7>
