
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 2f 10 80       	mov    $0x80102f20,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 7c 10 80       	push   $0x80107c60
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 c5 4d 00 00       	call   80104e20 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7c 10 80       	push   $0x80107c67
80100097:	50                   	push   %eax
80100098:	e8 53 4c 00 00       	call   80104cf0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 77 4e 00 00       	call   80104f60 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 b9 4e 00 00       	call   80105020 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 4b 00 00       	call   80104d30 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 7c 10 80       	push   $0x80107c6e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 4c 00 00       	call   80104dd0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 7c 10 80       	push   $0x80107c7f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 4b 00 00       	call   80104dd0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 4b 00 00       	call   80104d90 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 50 4d 00 00       	call   80104f60 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 4d 00 00       	jmp    80105020 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 7c 10 80       	push   $0x80107c86
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 cf 4c 00 00       	call   80104f60 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 86 44 00 00       	call   80104750 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 3b 00 00       	call   80103e50 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 4d 00 00       	call   80105020 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ce 4c 00 00       	call   80105020 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 02 24 00 00       	call   801027b0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 7c 10 80       	push   $0x80107c8d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 bb 87 10 80 	movl   $0x801087bb,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 4a 00 00       	call   80104e40 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 7c 10 80       	push   $0x80107ca1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 a1 63 00 00       	call   801067e0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ef 62 00 00       	call   801067e0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 62 00 00       	call   801067e0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 62 00 00       	call   801067e0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 4b 00 00       	call   80105120 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 4b 00 00       	call   80105070 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 7c 10 80       	push   $0x80107ca5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 d0 7c 10 80 	movzbl -0x7fef8330(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 40 49 00 00       	call   80104f60 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 49 00 00       	call   80105020 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 fc 48 00 00       	call   80105020 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba b8 7c 10 80       	mov    $0x80107cb8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 6b 47 00 00       	call   80104f60 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 7c 10 80       	push   $0x80107cbf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 38 47 00 00       	call   80104f60 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 93 47 00 00       	call   80105020 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 e5 3f 00 00       	call   80104900 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 14 42 00 00       	jmp    80104bb0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 c8 7c 10 80       	push   $0x80107cc8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 4b 44 00 00       	call   80104e20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 2f 34 00 00       	call   80103e50 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 f4 21 00 00       	call   80102c20 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 1c 22 00 00       	call   80102c90 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 07 6f 00 00       	call   801079a0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 55 6c 00 00       	call   80107750 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 63 6b 00 00       	call   80107690 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 a9 6d 00 00       	call   80107920 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 f1 20 00 00       	call   80102c90 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 a1 6b 00 00       	call   80107750 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 5a 6d 00 00       	call   80107920 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 b8 20 00 00       	call   80102c90 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 7c 10 80       	push   $0x80107ce1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 35 6e 00 00       	call   80107a40 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 46 00 00       	call   80105290 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 46 00 00       	call   80105290 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 4e 6f 00 00       	call   80107bb0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 e4 6e 00 00       	call   80107bb0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 41 45 00 00       	call   80105250 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 c7 67 00 00       	call   80107500 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 df 6b 00 00       	call   80107920 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ed 7c 10 80       	push   $0x80107ced
80100d6b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d70:	e8 ab 40 00 00       	call   80104e20 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 0f 11 80       	push   $0x80110fe0
80100d91:	e8 ca 41 00 00       	call   80104f60 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 5a 42 00 00       	call   80105020 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 0f 11 80       	push   $0x80110fe0
80100dda:	e8 41 42 00 00       	call   80105020 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 0f 11 80       	push   $0x80110fe0
80100dff:	e8 5c 41 00 00       	call   80104f60 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1c:	e8 ff 41 00 00       	call   80105020 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 7c 10 80       	push   $0x80107cf4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e51:	e8 0a 41 00 00       	call   80104f60 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 9f 41 00 00       	jmp    80105020 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 41 00 00       	call   80105020 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 fa 24 00 00       	call   801033d0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 3b 1d 00 00       	call   80102c20 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 91 1d 00 00       	jmp    80102c90 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 fc 7c 10 80       	push   $0x80107cfc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ae 25 00 00       	jmp    80103580 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 06 7d 10 80       	push   $0x80107d06
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 42 1c 00 00       	call   80102c90 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 a5 1b 00 00       	call   80102c20 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 de 1b 00 00       	call   80102c90 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 7e 23 00 00       	jmp    80103470 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 0f 7d 10 80       	push   $0x80107d0f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 7d 10 80       	push   $0x80107d15
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 92 1c 00 00       	call   80102df0 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 1f 7d 10 80       	push   $0x80107d1f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 f8 19 11 80    	add    0x801119f8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 32 7d 10 80       	push   $0x80107d32
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 ae 1b 00 00       	call   80102df0 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 06 3e 00 00       	call   80105070 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 7e 1b 00 00       	call   80102df0 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 1a 11 80       	push   $0x80111a00
801012aa:	e8 b1 3c 00 00       	call   80104f60 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 1a 11 80       	push   $0x80111a00
8010130f:	e8 0c 3d 00 00       	call   80105020 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 de 3c 00 00       	call   80105020 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 48 7d 10 80       	push   $0x80107d48
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 1d 1a 00 00       	call   80102df0 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 58 7d 10 80       	push   $0x80107d58
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 ba 3c 00 00       	call   80105120 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 6b 7d 10 80       	push   $0x80107d6b
80101491:	68 00 1a 11 80       	push   $0x80111a00
80101496:	e8 85 39 00 00       	call   80104e20 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 72 7d 10 80       	push   $0x80107d72
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 3c 38 00 00       	call   80104cf0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 e0 19 11 80       	push   $0x801119e0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014d5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014db:	ff 35 f0 19 11 80    	pushl  0x801119f0
801014e1:	ff 35 ec 19 11 80    	pushl  0x801119ec
801014e7:	ff 35 e8 19 11 80    	pushl  0x801119e8
801014ed:	ff 35 e4 19 11 80    	pushl  0x801119e4
801014f3:	ff 35 e0 19 11 80    	pushl  0x801119e0
801014f9:	68 d8 7d 10 80       	push   $0x80107dd8
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 dd 3a 00 00       	call   80105070 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 4b 18 00 00       	call   80102df0 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 78 7d 10 80       	push   $0x80107d78
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 ea 3a 00 00       	call   80105120 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 b2 17 00 00       	call   80102df0 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 00 1a 11 80       	push   $0x80111a00
8010165f:	e8 fc 38 00 00       	call   80104f60 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010166f:	e8 ac 39 00 00       	call   80105020 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 89 36 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 03 3a 00 00       	call   80105120 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 90 7d 10 80       	push   $0x80107d90
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 8a 7d 10 80       	push   $0x80107d8a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 58 36 00 00       	call   80104dd0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 fc 35 00 00       	jmp    80104d90 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 9f 7d 10 80       	push   $0x80107d9f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 6b 35 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 b1 35 00 00       	call   80104d90 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017e6:	e8 75 37 00 00       	call   80104f60 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 1b 38 00 00       	jmp    80105020 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 00 1a 11 80       	push   $0x80111a00
80101810:	e8 4b 37 00 00       	call   80104f60 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010181f:	e8 fc 37 00 00       	call   80105020 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 14 37 00 00       	call   80105120 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 18 36 00 00       	call   80105120 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 e0 12 00 00       	call   80102df0 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 ed 35 00 00       	call   80105190 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 8e 35 00 00       	call   80105190 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 b9 7d 10 80       	push   $0x80107db9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 a7 7d 10 80       	push   $0x80107da7
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 d2 21 00 00       	call   80103e50 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 00 1a 11 80       	push   $0x80111a00
80101c89:	e8 d2 32 00 00       	call   80104f60 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 82 33 00 00       	call   80105020 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 26 34 00 00       	call   80105120 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 93 33 00 00       	call   80105120 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 6e 33 00 00       	call   801051f0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 c8 7d 10 80       	push   $0x80107dc8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 03 82 10 80       	push   $0x80108203
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 34 7e 10 80       	push   $0x80107e34
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 2b 7e 10 80       	push   $0x80107e2b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 46 7e 10 80       	push   $0x80107e46
8010200b:	68 80 b5 10 80       	push   $0x8010b580
80102010:	e8 0b 2e 00 00       	call   80104e20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 80 b5 10 80       	push   $0x8010b580
8010208e:	e8 cd 2e 00 00       	call   80104f60 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 0a 28 00 00       	call   80104900 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 b5 10 80       	push   $0x8010b580
8010210f:	e8 0c 2f 00 00       	call   80105020 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 9d 2c 00 00       	call   80104dd0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 b5 10 80       	push   $0x8010b580
80102168:	e8 f3 2d 00 00       	call   80104f60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 b5 10 80       	push   $0x8010b580
801021b8:	53                   	push   %ebx
801021b9:	e8 92 25 00 00       	call   80104750 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 45 2e 00 00       	jmp    80105020 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 60 7e 10 80       	push   $0x80107e60
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 4a 7e 10 80       	push   $0x80107e4a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 75 7e 10 80       	push   $0x80107e75
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 54 36 11 80       	mov    0x80113654,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 94 7e 10 80       	push   $0x80107e94
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	0f 85 e3 00 00 00    	jne    80102409 <kfree+0xf9>
80102326:	81 fb dc 68 11 80    	cmp    $0x801168dc,%ebx
8010232c:	0f 82 d7 00 00 00    	jb     80102409 <kfree+0xf9>
80102332:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80102338:	81 fa ff ff ff 0d    	cmp    $0xdffffff,%edx
8010233e:	0f 87 c5 00 00 00    	ja     80102409 <kfree+0xf9>
80102344:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
8010234a:	89 d8                	mov    %ebx,%eax
8010234c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kfree");

  // Fill with junk to catch dangling refs.
  //memset(v, 1, PGSIZE);
  for(int i=0; i<PGSIZE; i++) v[i]= 1;
80102350:	c6 00 01             	movb   $0x1,(%eax)
80102353:	83 c0 01             	add    $0x1,%eax
80102356:	39 d0                	cmp    %edx,%eax
80102358:	75 f6                	jne    80102350 <kfree+0x40>

  if(kmem.use_lock)acquire(&kmem.lock);
8010235a:	a1 94 36 11 80       	mov    0x80113694,%eax
8010235f:	85 c0                	test   %eax,%eax
80102361:	0f 85 8d 00 00 00    	jne    801023f4 <kfree+0xe4>
  r = (struct run*)v;
  r->next = kmem.freelist;
80102367:	a1 98 36 11 80       	mov    0x80113698,%eax
8010236c:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock) release(&kmem.lock);
8010236e:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102373:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock) release(&kmem.lock);
80102379:	85 c0                	test   %eax,%eax
8010237b:	75 0e                	jne    8010238b <kfree+0x7b>
  // wake up process sleeping on sleeping channel
  if(kmem.use_lock) acquire(&sleeping_channel_lock);
  if(sleeping_channel_count){
8010237d:	a1 c8 b5 10 80       	mov    0x8010b5c8,%eax
80102382:	85 c0                	test   %eax,%eax
80102384:	75 39                	jne    801023bf <kfree+0xaf>
    wakeup(sleeping_channel);
    sleeping_channel_count = 0;
  }
  if(kmem.use_lock) release(&sleeping_channel_lock);
}
80102386:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102389:	c9                   	leave  
8010238a:	c3                   	ret    
  if(kmem.use_lock) release(&kmem.lock);
8010238b:	83 ec 0c             	sub    $0xc,%esp
8010238e:	68 60 36 11 80       	push   $0x80113660
80102393:	e8 88 2c 00 00       	call   80105020 <release>
  if(kmem.use_lock) acquire(&sleeping_channel_lock);
80102398:	8b 1d 94 36 11 80    	mov    0x80113694,%ebx
8010239e:	83 c4 10             	add    $0x10,%esp
801023a1:	85 db                	test   %ebx,%ebx
801023a3:	74 d8                	je     8010237d <kfree+0x6d>
801023a5:	83 ec 0c             	sub    $0xc,%esp
801023a8:	68 a0 68 11 80       	push   $0x801168a0
801023ad:	e8 ae 2b 00 00       	call   80104f60 <acquire>
  if(sleeping_channel_count){
801023b2:	8b 0d c8 b5 10 80    	mov    0x8010b5c8,%ecx
801023b8:	83 c4 10             	add    $0x10,%esp
801023bb:	85 c9                	test   %ecx,%ecx
801023bd:	74 1b                	je     801023da <kfree+0xca>
    wakeup(sleeping_channel);
801023bf:	83 ec 0c             	sub    $0xc,%esp
801023c2:	ff 35 d8 68 11 80    	pushl  0x801168d8
801023c8:	e8 33 25 00 00       	call   80104900 <wakeup>
    sleeping_channel_count = 0;
801023cd:	c7 05 c8 b5 10 80 00 	movl   $0x0,0x8010b5c8
801023d4:	00 00 00 
801023d7:	83 c4 10             	add    $0x10,%esp
  if(kmem.use_lock) release(&sleeping_channel_lock);
801023da:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801023e0:	85 d2                	test   %edx,%edx
801023e2:	74 a2                	je     80102386 <kfree+0x76>
801023e4:	c7 45 08 a0 68 11 80 	movl   $0x801168a0,0x8(%ebp)
}
801023eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ee:	c9                   	leave  
  if(kmem.use_lock) release(&sleeping_channel_lock);
801023ef:	e9 2c 2c 00 00       	jmp    80105020 <release>
  if(kmem.use_lock)acquire(&kmem.lock);
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 60 36 11 80       	push   $0x80113660
801023fc:	e8 5f 2b 00 00       	call   80104f60 <acquire>
80102401:	83 c4 10             	add    $0x10,%esp
80102404:	e9 5e ff ff ff       	jmp    80102367 <kfree+0x57>
    panic("kfree");
80102409:	83 ec 0c             	sub    $0xc,%esp
8010240c:	68 c6 7e 10 80       	push   $0x80107ec6
80102411:	e8 7a df ff ff       	call   80100390 <panic>
80102416:	8d 76 00             	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <freerange>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <freerange+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 b3 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 f3                	cmp    %esi,%ebx
80102462:	76 e4                	jbe    80102448 <freerange+0x28>
}
80102464:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102467:	5b                   	pop    %ebx
80102468:	5e                   	pop    %esi
80102469:	5d                   	pop    %ebp
8010246a:	c3                   	ret    
8010246b:	90                   	nop
8010246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102470 <kinit1>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
80102475:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102478:	83 ec 08             	sub    $0x8,%esp
8010247b:	68 cc 7e 10 80       	push   $0x80107ecc
80102480:	68 60 36 11 80       	push   $0x80113660
80102485:	e8 96 29 00 00       	call   80104e20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010248a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102490:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102497:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010249a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ac:	39 de                	cmp    %ebx,%esi
801024ae:	72 1c                	jb     801024cc <kinit1+0x5c>
    kfree(p);
801024b0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024b6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024bf:	50                   	push   %eax
801024c0:	e8 4b fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	39 de                	cmp    %ebx,%esi
801024ca:	73 e4                	jae    801024b0 <kinit1+0x40>
}
801024cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024cf:	5b                   	pop    %ebx
801024d0:	5e                   	pop    %esi
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kinit2>:
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	56                   	push   %esi
801024e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024fd:	39 de                	cmp    %ebx,%esi
801024ff:	72 23                	jb     80102524 <kinit2+0x44>
80102501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102508:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010250e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102511:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102517:	50                   	push   %eax
80102518:	e8 f3 fd ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	39 de                	cmp    %ebx,%esi
80102522:	73 e4                	jae    80102508 <kinit2+0x28>
  kmem.use_lock = 1;
80102524:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010252b:	00 00 00 
}
8010252e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102531:	5b                   	pop    %ebx
80102532:	5e                   	pop    %esi
80102533:	5d                   	pop    %ebp
80102534:	c3                   	ret    
80102535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102540:	a1 94 36 11 80       	mov    0x80113694,%eax
80102545:	85 c0                	test   %eax,%eax
80102547:	75 1f                	jne    80102568 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102549:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010254e:	85 c0                	test   %eax,%eax
80102550:	74 0e                	je     80102560 <kalloc+0x20>
    kmem.freelist = r->next;
80102552:	8b 10                	mov    (%eax),%edx
80102554:	89 15 98 36 11 80    	mov    %edx,0x80113698
8010255a:	c3                   	ret    
8010255b:	90                   	nop
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102560:	f3 c3                	repz ret 
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102568:	55                   	push   %ebp
80102569:	89 e5                	mov    %esp,%ebp
8010256b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010256e:	68 60 36 11 80       	push   $0x80113660
80102573:	e8 e8 29 00 00       	call   80104f60 <acquire>
  r = kmem.freelist;
80102578:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102586:	85 c0                	test   %eax,%eax
80102588:	74 08                	je     80102592 <kalloc+0x52>
    kmem.freelist = r->next;
8010258a:	8b 08                	mov    (%eax),%ecx
8010258c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102592:	85 d2                	test   %edx,%edx
80102594:	74 16                	je     801025ac <kalloc+0x6c>
    release(&kmem.lock);
80102596:	83 ec 0c             	sub    $0xc,%esp
80102599:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010259c:	68 60 36 11 80       	push   $0x80113660
801025a1:	e8 7a 2a 00 00       	call   80105020 <release>
  return (char*)r;
801025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801025a9:	83 c4 10             	add    $0x10,%esp
}
801025ac:	c9                   	leave  
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b0:	ba 64 00 00 00       	mov    $0x64,%edx
801025b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025b6:	a8 01                	test   $0x1,%al
801025b8:	0f 84 c2 00 00 00    	je     80102680 <kbdgetc+0xd0>
801025be:	ba 60 00 00 00       	mov    $0x60,%edx
801025c3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025c4:	0f b6 d0             	movzbl %al,%edx
801025c7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801025cd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025d3:	0f 84 7f 00 00 00    	je     80102658 <kbdgetc+0xa8>
{
801025d9:	55                   	push   %ebp
801025da:	89 e5                	mov    %esp,%ebp
801025dc:	53                   	push   %ebx
801025dd:	89 cb                	mov    %ecx,%ebx
801025df:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025e2:	84 c0                	test   %al,%al
801025e4:	78 4a                	js     80102630 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025e6:	85 db                	test   %ebx,%ebx
801025e8:	74 09                	je     801025f3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025ea:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ed:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025f0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025f3:	0f b6 82 00 80 10 80 	movzbl -0x7fef8000(%edx),%eax
801025fa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025fc:	0f b6 82 00 7f 10 80 	movzbl -0x7fef8100(%edx),%eax
80102603:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102605:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102607:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010260d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102610:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102613:	8b 04 85 e0 7e 10 80 	mov    -0x7fef8120(,%eax,4),%eax
8010261a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010261e:	74 31                	je     80102651 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102620:	8d 50 9f             	lea    -0x61(%eax),%edx
80102623:	83 fa 19             	cmp    $0x19,%edx
80102626:	77 40                	ja     80102668 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102628:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010262b:	5b                   	pop    %ebx
8010262c:	5d                   	pop    %ebp
8010262d:	c3                   	ret    
8010262e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102630:	83 e0 7f             	and    $0x7f,%eax
80102633:	85 db                	test   %ebx,%ebx
80102635:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102638:	0f b6 82 00 80 10 80 	movzbl -0x7fef8000(%edx),%eax
8010263f:	83 c8 40             	or     $0x40,%eax
80102642:	0f b6 c0             	movzbl %al,%eax
80102645:	f7 d0                	not    %eax
80102647:	21 c1                	and    %eax,%ecx
    return 0;
80102649:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010264b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102651:	5b                   	pop    %ebx
80102652:	5d                   	pop    %ebp
80102653:	c3                   	ret    
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102658:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010265b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010265d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102663:	c3                   	ret    
80102664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102668:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010266b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010266e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010266f:	83 f9 1a             	cmp    $0x1a,%ecx
80102672:	0f 42 c2             	cmovb  %edx,%eax
}
80102675:	5d                   	pop    %ebp
80102676:	c3                   	ret    
80102677:	89 f6                	mov    %esi,%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102685:	c3                   	ret    
80102686:	8d 76 00             	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <kbdintr>:

void
kbdintr(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102696:	68 b0 25 10 80       	push   $0x801025b0
8010269b:	e8 70 e1 ff ff       	call   80100810 <consoleintr>
}
801026a0:	83 c4 10             	add    $0x10,%esp
801026a3:	c9                   	leave  
801026a4:	c3                   	ret    
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026b0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026b8:	85 c0                	test   %eax,%eax
801026ba:	0f 84 c8 00 00 00    	je     80102788 <lapicinit+0xd8>
  lapic[index] = value;
801026c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102701:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102708:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010270e:	8b 50 30             	mov    0x30(%eax),%edx
80102711:	c1 ea 10             	shr    $0x10,%edx
80102714:	80 fa 03             	cmp    $0x3,%dl
80102717:	77 77                	ja     80102790 <lapicinit+0xe0>
  lapic[index] = value;
80102719:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102720:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102723:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102726:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102730:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102733:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102740:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102747:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102761:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102770:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102776:	80 e6 10             	and    $0x10,%dh
80102779:	75 f5                	jne    80102770 <lapicinit+0xc0>
  lapic[index] = value;
8010277b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102782:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102785:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102788:	5d                   	pop    %ebp
80102789:	c3                   	ret    
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102790:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102797:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010279a:	8b 50 20             	mov    0x20(%eax),%edx
8010279d:	e9 77 ff ff ff       	jmp    80102719 <lapicinit+0x69>
801027a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027b0:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
801027b6:	55                   	push   %ebp
801027b7:	31 c0                	xor    %eax,%eax
801027b9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027bb:	85 d2                	test   %edx,%edx
801027bd:	74 06                	je     801027c5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027bf:	8b 42 20             	mov    0x20(%edx),%eax
801027c2:	c1 e8 18             	shr    $0x18,%eax
}
801027c5:	5d                   	pop    %ebp
801027c6:	c3                   	ret    
801027c7:	89 f6                	mov    %esi,%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027d0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	74 0d                	je     801027e9 <lapiceoi+0x19>
  lapic[index] = value;
801027dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
}
801027f3:	5d                   	pop    %ebp
801027f4:	c3                   	ret    
801027f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102800:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	b8 0f 00 00 00       	mov    $0xf,%eax
80102806:	ba 70 00 00 00       	mov    $0x70,%edx
8010280b:	89 e5                	mov    %esp,%ebp
8010280d:	53                   	push   %ebx
8010280e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102811:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102814:	ee                   	out    %al,(%dx)
80102815:	b8 0a 00 00 00       	mov    $0xa,%eax
8010281a:	ba 71 00 00 00       	mov    $0x71,%edx
8010281f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102820:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102822:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102825:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010282b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010282d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102830:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102833:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102835:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102838:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010283e:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102843:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102849:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010284c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102853:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102856:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102859:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102860:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102866:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010286c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010286f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102878:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102881:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102887:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010288a:	5b                   	pop    %ebx
8010288b:	5d                   	pop    %ebp
8010288c:	c3                   	ret    
8010288d:	8d 76 00             	lea    0x0(%esi),%esi

80102890 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102890:	55                   	push   %ebp
80102891:	b8 0b 00 00 00       	mov    $0xb,%eax
80102896:	ba 70 00 00 00       	mov    $0x70,%edx
8010289b:	89 e5                	mov    %esp,%ebp
8010289d:	57                   	push   %edi
8010289e:	56                   	push   %esi
8010289f:	53                   	push   %ebx
801028a0:	83 ec 4c             	sub    $0x4c,%esp
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	ba 71 00 00 00       	mov    $0x71,%edx
801028a9:	ec                   	in     (%dx),%al
801028aa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ad:	bb 70 00 00 00       	mov    $0x70,%ebx
801028b2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
801028b8:	31 c0                	xor    %eax,%eax
801028ba:	89 da                	mov    %ebx,%edx
801028bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bd:	b9 71 00 00 00       	mov    $0x71,%ecx
801028c2:	89 ca                	mov    %ecx,%edx
801028c4:	ec                   	in     (%dx),%al
801028c5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c8:	89 da                	mov    %ebx,%edx
801028ca:	b8 02 00 00 00       	mov    $0x2,%eax
801028cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
801028d3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d6:	89 da                	mov    %ebx,%edx
801028d8:	b8 04 00 00 00       	mov    $0x4,%eax
801028dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028de:	89 ca                	mov    %ecx,%edx
801028e0:	ec                   	in     (%dx),%al
801028e1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e4:	89 da                	mov    %ebx,%edx
801028e6:	b8 07 00 00 00       	mov    $0x7,%eax
801028eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
801028ef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 da                	mov    %ebx,%edx
801028f4:	b8 08 00 00 00       	mov    $0x8,%eax
801028f9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fa:	89 ca                	mov    %ecx,%edx
801028fc:	ec                   	in     (%dx),%al
801028fd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ff:	89 da                	mov    %ebx,%edx
80102901:	b8 09 00 00 00       	mov    $0x9,%eax
80102906:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102907:	89 ca                	mov    %ecx,%edx
80102909:	ec                   	in     (%dx),%al
8010290a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290c:	89 da                	mov    %ebx,%edx
8010290e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102913:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	89 ca                	mov    %ecx,%edx
80102916:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102917:	84 c0                	test   %al,%al
80102919:	78 9d                	js     801028b8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010291b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010291f:	89 fa                	mov    %edi,%edx
80102921:	0f b6 fa             	movzbl %dl,%edi
80102924:	89 f2                	mov    %esi,%edx
80102926:	0f b6 f2             	movzbl %dl,%esi
80102929:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292c:	89 da                	mov    %ebx,%edx
8010292e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102931:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102934:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102938:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010293b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010293f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102942:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102946:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102949:	31 c0                	xor    %eax,%eax
8010294b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294c:	89 ca                	mov    %ecx,%edx
8010294e:	ec                   	in     (%dx),%al
8010294f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102952:	89 da                	mov    %ebx,%edx
80102954:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102957:	b8 02 00 00 00       	mov    $0x2,%eax
8010295c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295d:	89 ca                	mov    %ecx,%edx
8010295f:	ec                   	in     (%dx),%al
80102960:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102963:	89 da                	mov    %ebx,%edx
80102965:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102968:	b8 04 00 00 00       	mov    $0x4,%eax
8010296d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296e:	89 ca                	mov    %ecx,%edx
80102970:	ec                   	in     (%dx),%al
80102971:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102974:	89 da                	mov    %ebx,%edx
80102976:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102979:	b8 07 00 00 00       	mov    $0x7,%eax
8010297e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297f:	89 ca                	mov    %ecx,%edx
80102981:	ec                   	in     (%dx),%al
80102982:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102985:	89 da                	mov    %ebx,%edx
80102987:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010298a:	b8 08 00 00 00       	mov    $0x8,%eax
8010298f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	89 ca                	mov    %ecx,%edx
80102992:	ec                   	in     (%dx),%al
80102993:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102996:	89 da                	mov    %ebx,%edx
80102998:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010299b:	b8 09 00 00 00       	mov    $0x9,%eax
801029a0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a1:	89 ca                	mov    %ecx,%edx
801029a3:	ec                   	in     (%dx),%al
801029a4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029a7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029ad:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029b0:	6a 18                	push   $0x18
801029b2:	50                   	push   %eax
801029b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029b6:	50                   	push   %eax
801029b7:	e8 04 27 00 00       	call   801050c0 <memcmp>
801029bc:	83 c4 10             	add    $0x10,%esp
801029bf:	85 c0                	test   %eax,%eax
801029c1:	0f 85 f1 fe ff ff    	jne    801028b8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029c7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029cb:	75 78                	jne    80102a45 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d0:	89 c2                	mov    %eax,%edx
801029d2:	83 e0 0f             	and    $0xf,%eax
801029d5:	c1 ea 04             	shr    $0x4,%edx
801029d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029de:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e4:	89 c2                	mov    %eax,%edx
801029e6:	83 e0 0f             	and    $0xf,%eax
801029e9:	c1 ea 04             	shr    $0x4,%edx
801029ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f8:	89 c2                	mov    %eax,%edx
801029fa:	83 e0 0f             	and    $0xf,%eax
801029fd:	c1 ea 04             	shr    $0x4,%edx
80102a00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a06:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a0c:	89 c2                	mov    %eax,%edx
80102a0e:	83 e0 0f             	and    $0xf,%eax
80102a11:	c1 ea 04             	shr    $0x4,%edx
80102a14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a20:	89 c2                	mov    %eax,%edx
80102a22:	83 e0 0f             	and    $0xf,%eax
80102a25:	c1 ea 04             	shr    $0x4,%edx
80102a28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a34:	89 c2                	mov    %eax,%edx
80102a36:	83 e0 0f             	and    $0xf,%eax
80102a39:	c1 ea 04             	shr    $0x4,%edx
80102a3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a42:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a45:	8b 75 08             	mov    0x8(%ebp),%esi
80102a48:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a4b:	89 06                	mov    %eax,(%esi)
80102a4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a50:	89 46 04             	mov    %eax,0x4(%esi)
80102a53:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a56:	89 46 08             	mov    %eax,0x8(%esi)
80102a59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a5c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a62:	89 46 10             	mov    %eax,0x10(%esi)
80102a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a68:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a6b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a75:	5b                   	pop    %ebx
80102a76:	5e                   	pop    %esi
80102a77:	5f                   	pop    %edi
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	66 90                	xchg   %ax,%ax
80102a7c:	66 90                	xchg   %ax,%ax
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a80:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102a86:	85 c9                	test   %ecx,%ecx
80102a88:	0f 8e 8a 00 00 00    	jle    80102b18 <install_trans+0x98>
{
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	57                   	push   %edi
80102a92:	56                   	push   %esi
80102a93:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a94:	31 db                	xor    %ebx,%ebx
{
80102a96:	83 ec 0c             	sub    $0xc,%esp
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102aa0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	01 d8                	add    %ebx,%eax
80102aaa:	83 c0 01             	add    $0x1,%eax
80102aad:	50                   	push   %eax
80102aae:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
80102ab9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102abb:	58                   	pop    %eax
80102abc:	5a                   	pop    %edx
80102abd:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102ac4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102aca:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102acd:	e8 fe d5 ff ff       	call   801000d0 <bread>
80102ad2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ad4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ad7:	83 c4 0c             	add    $0xc,%esp
80102ada:	68 00 02 00 00       	push   $0x200
80102adf:	50                   	push   %eax
80102ae0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ae3:	50                   	push   %eax
80102ae4:	e8 37 26 00 00       	call   80105120 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ae9:	89 34 24             	mov    %esi,(%esp)
80102aec:	e8 af d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102af1:	89 3c 24             	mov    %edi,(%esp)
80102af4:	e8 e7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102af9:	89 34 24             	mov    %esi,(%esp)
80102afc:	e8 df d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b01:	83 c4 10             	add    $0x10,%esp
80102b04:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102b0a:	7f 94                	jg     80102aa0 <install_trans+0x20>
  }
}
80102b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5f                   	pop    %edi
80102b12:	5d                   	pop    %ebp
80102b13:	c3                   	ret    
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b18:	f3 c3                	repz ret 
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b25:	83 ec 08             	sub    $0x8,%esp
80102b28:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102b2e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102b34:	e8 97 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b39:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b3f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b42:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b44:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b46:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b49:	7e 16                	jle    80102b61 <write_head+0x41>
80102b4b:	c1 e3 02             	shl    $0x2,%ebx
80102b4e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b50:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102b56:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b5a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b5d:	39 da                	cmp    %ebx,%edx
80102b5f:	75 ef                	jne    80102b50 <write_head+0x30>
  }
  bwrite(buf);
80102b61:	83 ec 0c             	sub    $0xc,%esp
80102b64:	56                   	push   %esi
80102b65:	e8 36 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b6a:	89 34 24             	mov    %esi,(%esp)
80102b6d:	e8 6e d6 ff ff       	call   801001e0 <brelse>
}
80102b72:	83 c4 10             	add    $0x10,%esp
80102b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b78:	5b                   	pop    %ebx
80102b79:	5e                   	pop    %esi
80102b7a:	5d                   	pop    %ebp
80102b7b:	c3                   	ret    
80102b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b80 <initlog>:
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	53                   	push   %ebx
80102b84:	83 ec 2c             	sub    $0x2c,%esp
80102b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b8a:	68 00 81 10 80       	push   $0x80108100
80102b8f:	68 a0 36 11 80       	push   $0x801136a0
80102b94:	e8 87 22 00 00       	call   80104e20 <initlock>
  readsb(dev, &sb);
80102b99:	58                   	pop    %eax
80102b9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b9d:	5a                   	pop    %edx
80102b9e:	50                   	push   %eax
80102b9f:	53                   	push   %ebx
80102ba0:	e8 9b e8 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102ba5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bab:	59                   	pop    %ecx
  log.dev = dev;
80102bac:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102bb2:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102bb8:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102bbd:	5a                   	pop    %edx
80102bbe:	50                   	push   %eax
80102bbf:	53                   	push   %ebx
80102bc0:	e8 0b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102bc5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bc8:	83 c4 10             	add    $0x10,%esp
80102bcb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bcd:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102bd3:	7e 1c                	jle    80102bf1 <initlog+0x71>
80102bd5:	c1 e3 02             	shl    $0x2,%ebx
80102bd8:	31 d2                	xor    %edx,%edx
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102be0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102be4:	83 c2 04             	add    $0x4,%edx
80102be7:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bed:	39 d3                	cmp    %edx,%ebx
80102bef:	75 ef                	jne    80102be0 <initlog+0x60>
  brelse(buf);
80102bf1:	83 ec 0c             	sub    $0xc,%esp
80102bf4:	50                   	push   %eax
80102bf5:	e8 e6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bfa:	e8 81 fe ff ff       	call   80102a80 <install_trans>
  log.lh.n = 0;
80102bff:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102c06:	00 00 00 
  write_head(); // clear the log
80102c09:	e8 12 ff ff ff       	call   80102b20 <write_head>
}
80102c0e:	83 c4 10             	add    $0x10,%esp
80102c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c26:	68 a0 36 11 80       	push   $0x801136a0
80102c2b:	e8 30 23 00 00       	call   80104f60 <acquire>
80102c30:	83 c4 10             	add    $0x10,%esp
80102c33:	eb 18                	jmp    80102c4d <begin_op+0x2d>
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c38:	83 ec 08             	sub    $0x8,%esp
80102c3b:	68 a0 36 11 80       	push   $0x801136a0
80102c40:	68 a0 36 11 80       	push   $0x801136a0
80102c45:	e8 06 1b 00 00       	call   80104750 <sleep>
80102c4a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c4d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102c52:	85 c0                	test   %eax,%eax
80102c54:	75 e2                	jne    80102c38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c56:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102c5b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102c61:	83 c0 01             	add    $0x1,%eax
80102c64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c6a:	83 fa 1e             	cmp    $0x1e,%edx
80102c6d:	7f c9                	jg     80102c38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c6f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c72:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102c77:	68 a0 36 11 80       	push   $0x801136a0
80102c7c:	e8 9f 23 00 00       	call   80105020 <release>
      break;
    }
  }
}
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    
80102c86:	8d 76 00             	lea    0x0(%esi),%esi
80102c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c99:	68 a0 36 11 80       	push   $0x801136a0
80102c9e:	e8 bd 22 00 00       	call   80104f60 <acquire>
  log.outstanding -= 1;
80102ca3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102ca8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102cae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102cb1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102cb4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102cb6:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102cbc:	0f 85 1a 01 00 00    	jne    80102ddc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102cc2:	85 db                	test   %ebx,%ebx
80102cc4:	0f 85 ee 00 00 00    	jne    80102db8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cca:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ccd:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102cd4:	00 00 00 
  release(&log.lock);
80102cd7:	68 a0 36 11 80       	push   $0x801136a0
80102cdc:	e8 3f 23 00 00       	call   80105020 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ce1:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102ce7:	83 c4 10             	add    $0x10,%esp
80102cea:	85 c9                	test   %ecx,%ecx
80102cec:	0f 8e 85 00 00 00    	jle    80102d77 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cf2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102cf7:	83 ec 08             	sub    $0x8,%esp
80102cfa:	01 d8                	add    %ebx,%eax
80102cfc:	83 c0 01             	add    $0x1,%eax
80102cff:	50                   	push   %eax
80102d00:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102d06:	e8 c5 d3 ff ff       	call   801000d0 <bread>
80102d0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d0d:	58                   	pop    %eax
80102d0e:	5a                   	pop    %edx
80102d0f:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102d16:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d1f:	e8 ac d3 ff ff       	call   801000d0 <bread>
80102d24:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d26:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d29:	83 c4 0c             	add    $0xc,%esp
80102d2c:	68 00 02 00 00       	push   $0x200
80102d31:	50                   	push   %eax
80102d32:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d35:	50                   	push   %eax
80102d36:	e8 e5 23 00 00       	call   80105120 <memmove>
    bwrite(to);  // write the log
80102d3b:	89 34 24             	mov    %esi,(%esp)
80102d3e:	e8 5d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d43:	89 3c 24             	mov    %edi,(%esp)
80102d46:	e8 95 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d4b:	89 34 24             	mov    %esi,(%esp)
80102d4e:	e8 8d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d53:	83 c4 10             	add    $0x10,%esp
80102d56:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102d5c:	7c 94                	jl     80102cf2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d5e:	e8 bd fd ff ff       	call   80102b20 <write_head>
    install_trans(); // Now install writes to home locations
80102d63:	e8 18 fd ff ff       	call   80102a80 <install_trans>
    log.lh.n = 0;
80102d68:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d6f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d72:	e8 a9 fd ff ff       	call   80102b20 <write_head>
    acquire(&log.lock);
80102d77:	83 ec 0c             	sub    $0xc,%esp
80102d7a:	68 a0 36 11 80       	push   $0x801136a0
80102d7f:	e8 dc 21 00 00       	call   80104f60 <acquire>
    wakeup(&log);
80102d84:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102d8b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d92:	00 00 00 
    wakeup(&log);
80102d95:	e8 66 1b 00 00       	call   80104900 <wakeup>
    release(&log.lock);
80102d9a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102da1:	e8 7a 22 00 00       	call   80105020 <release>
80102da6:	83 c4 10             	add    $0x10,%esp
}
80102da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dac:	5b                   	pop    %ebx
80102dad:	5e                   	pop    %esi
80102dae:	5f                   	pop    %edi
80102daf:	5d                   	pop    %ebp
80102db0:	c3                   	ret    
80102db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102db8:	83 ec 0c             	sub    $0xc,%esp
80102dbb:	68 a0 36 11 80       	push   $0x801136a0
80102dc0:	e8 3b 1b 00 00       	call   80104900 <wakeup>
  release(&log.lock);
80102dc5:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102dcc:	e8 4f 22 00 00       	call   80105020 <release>
80102dd1:	83 c4 10             	add    $0x10,%esp
}
80102dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dd7:	5b                   	pop    %ebx
80102dd8:	5e                   	pop    %esi
80102dd9:	5f                   	pop    %edi
80102dda:	5d                   	pop    %ebp
80102ddb:	c3                   	ret    
    panic("log.committing");
80102ddc:	83 ec 0c             	sub    $0xc,%esp
80102ddf:	68 04 81 10 80       	push   $0x80108104
80102de4:	e8 a7 d5 ff ff       	call   80100390 <panic>
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102df0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102df7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e00:	83 fa 1d             	cmp    $0x1d,%edx
80102e03:	0f 8f 9d 00 00 00    	jg     80102ea6 <log_write+0xb6>
80102e09:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102e0e:	83 e8 01             	sub    $0x1,%eax
80102e11:	39 c2                	cmp    %eax,%edx
80102e13:	0f 8d 8d 00 00 00    	jge    80102ea6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e19:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	0f 8e 8d 00 00 00    	jle    80102eb3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 a0 36 11 80       	push   $0x801136a0
80102e2e:	e8 2d 21 00 00       	call   80104f60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e33:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e39:	83 c4 10             	add    $0x10,%esp
80102e3c:	83 f9 00             	cmp    $0x0,%ecx
80102e3f:	7e 57                	jle    80102e98 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e41:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e44:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e46:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
80102e4c:	75 0b                	jne    80102e59 <log_write+0x69>
80102e4e:	eb 38                	jmp    80102e88 <log_write+0x98>
80102e50:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80102e57:	74 2f                	je     80102e88 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e59:	83 c0 01             	add    $0x1,%eax
80102e5c:	39 c1                	cmp    %eax,%ecx
80102e5e:	75 f0                	jne    80102e50 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e60:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e67:	83 c0 01             	add    $0x1,%eax
80102e6a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102e6f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e72:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e7c:	c9                   	leave  
  release(&log.lock);
80102e7d:	e9 9e 21 00 00       	jmp    80105020 <release>
80102e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e88:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
80102e8f:	eb de                	jmp    80102e6f <log_write+0x7f>
80102e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e98:	8b 43 08             	mov    0x8(%ebx),%eax
80102e9b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102ea0:	75 cd                	jne    80102e6f <log_write+0x7f>
80102ea2:	31 c0                	xor    %eax,%eax
80102ea4:	eb c1                	jmp    80102e67 <log_write+0x77>
    panic("too big a transaction");
80102ea6:	83 ec 0c             	sub    $0xc,%esp
80102ea9:	68 13 81 10 80       	push   $0x80108113
80102eae:	e8 dd d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102eb3:	83 ec 0c             	sub    $0xc,%esp
80102eb6:	68 29 81 10 80       	push   $0x80108129
80102ebb:	e8 d0 d4 ff ff       	call   80100390 <panic>

80102ec0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	53                   	push   %ebx
80102ec4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ec7:	e8 34 0c 00 00       	call   80103b00 <cpuid>
80102ecc:	89 c3                	mov    %eax,%ebx
80102ece:	e8 2d 0c 00 00       	call   80103b00 <cpuid>
80102ed3:	83 ec 04             	sub    $0x4,%esp
80102ed6:	53                   	push   %ebx
80102ed7:	50                   	push   %eax
80102ed8:	68 44 81 10 80       	push   $0x80108144
80102edd:	e8 7e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ee2:	e8 49 35 00 00       	call   80106430 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ee7:	e8 94 0b 00 00       	call   80103a80 <mycpu>
80102eec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eee:	b8 01 00 00 00       	mov    $0x1,%eax
80102ef3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102efa:	e8 71 12 00 00       	call   80104170 <scheduler>
80102eff:	90                   	nop

80102f00 <mpenter>:
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f06:	e8 d5 45 00 00       	call   801074e0 <switchkvm>
  seginit();
80102f0b:	e8 b0 44 00 00       	call   801073c0 <seginit>
  lapicinit();
80102f10:	e8 9b f7 ff ff       	call   801026b0 <lapicinit>
  mpmain();
80102f15:	e8 a6 ff ff ff       	call   80102ec0 <mpmain>
80102f1a:	66 90                	xchg   %ax,%ax
80102f1c:	66 90                	xchg   %ax,%ax
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <main>:
{
80102f20:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f24:	83 e4 f0             	and    $0xfffffff0,%esp
80102f27:	ff 71 fc             	pushl  -0x4(%ecx)
80102f2a:	55                   	push   %ebp
80102f2b:	89 e5                	mov    %esp,%ebp
80102f2d:	53                   	push   %ebx
80102f2e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f2f:	83 ec 08             	sub    $0x8,%esp
80102f32:	68 00 00 40 80       	push   $0x80400000
80102f37:	68 dc 68 11 80       	push   $0x801168dc
80102f3c:	e8 2f f5 ff ff       	call   80102470 <kinit1>
  kvmalloc();      // kernel page table
80102f41:	e8 da 4a 00 00       	call   80107a20 <kvmalloc>
  mpinit();        // detect other processors
80102f46:	e8 75 01 00 00       	call   801030c0 <mpinit>
  lapicinit();     // interrupt controller
80102f4b:	e8 60 f7 ff ff       	call   801026b0 <lapicinit>
  seginit();       // segment descriptors
80102f50:	e8 6b 44 00 00       	call   801073c0 <seginit>
  picinit();       // disable pic
80102f55:	e8 46 03 00 00       	call   801032a0 <picinit>
  ioapicinit();    // another interrupt controller
80102f5a:	e8 c1 f2 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102f5f:	e8 5c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f64:	e8 b7 37 00 00       	call   80106720 <uartinit>
  pinit();         // process table
80102f69:	e8 c2 0a 00 00       	call   80103a30 <pinit>
  tvinit();        // trap vectors
80102f6e:	e8 3d 34 00 00       	call   801063b0 <tvinit>
  binit();         // buffer cache
80102f73:	e8 c8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f78:	e8 e3 dd ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f7d:	e8 7e f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f82:	83 c4 0c             	add    $0xc,%esp
80102f85:	68 8a 00 00 00       	push   $0x8a
80102f8a:	68 8c b4 10 80       	push   $0x8010b48c
80102f8f:	68 00 70 00 80       	push   $0x80007000
80102f94:	e8 87 21 00 00       	call   80105120 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f99:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80102fa0:	00 00 00 
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102fab:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80102fb0:	76 71                	jbe    80103023 <main+0x103>
80102fb2:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80102fb7:	89 f6                	mov    %esi,%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fc0:	e8 bb 0a 00 00       	call   80103a80 <mycpu>
80102fc5:	39 d8                	cmp    %ebx,%eax
80102fc7:	74 41                	je     8010300a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fc9:	e8 72 f5 ff ff       	call   80102540 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fce:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102fd3:	c7 05 f8 6f 00 80 00 	movl   $0x80102f00,0x80006ff8
80102fda:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fdd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fe4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fe7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fec:	0f b6 03             	movzbl (%ebx),%eax
80102fef:	83 ec 08             	sub    $0x8,%esp
80102ff2:	68 00 70 00 00       	push   $0x7000
80102ff7:	50                   	push   %eax
80102ff8:	e8 03 f8 ff ff       	call   80102800 <lapicstartap>
80102ffd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103000:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	74 f6                	je     80103000 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010300a:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103011:	00 00 00 
80103014:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010301a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010301f:	39 c3                	cmp    %eax,%ebx
80103021:	72 9d                	jb     80102fc0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103023:	83 ec 08             	sub    $0x8,%esp
80103026:	68 00 00 00 8e       	push   $0x8e000000
8010302b:	68 00 00 40 80       	push   $0x80400000
80103030:	e8 ab f4 ff ff       	call   801024e0 <kinit2>
  userinit();      // first user process
80103035:	e8 46 0e 00 00       	call   80103e80 <userinit>
  mpmain();        // finish this processor's setup
8010303a:	e8 81 fe ff ff       	call   80102ec0 <mpmain>
8010303f:	90                   	nop

80103040 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103045:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010304b:	53                   	push   %ebx
  e = addr+len;
8010304c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010304f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103052:	39 de                	cmp    %ebx,%esi
80103054:	72 10                	jb     80103066 <mpsearch1+0x26>
80103056:	eb 50                	jmp    801030a8 <mpsearch1+0x68>
80103058:	90                   	nop
80103059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103060:	39 fb                	cmp    %edi,%ebx
80103062:	89 fe                	mov    %edi,%esi
80103064:	76 42                	jbe    801030a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103066:	83 ec 04             	sub    $0x4,%esp
80103069:	8d 7e 10             	lea    0x10(%esi),%edi
8010306c:	6a 04                	push   $0x4
8010306e:	68 58 81 10 80       	push   $0x80108158
80103073:	56                   	push   %esi
80103074:	e8 47 20 00 00       	call   801050c0 <memcmp>
80103079:	83 c4 10             	add    $0x10,%esp
8010307c:	85 c0                	test   %eax,%eax
8010307e:	75 e0                	jne    80103060 <mpsearch1+0x20>
80103080:	89 f1                	mov    %esi,%ecx
80103082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103088:	0f b6 11             	movzbl (%ecx),%edx
8010308b:	83 c1 01             	add    $0x1,%ecx
8010308e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103090:	39 f9                	cmp    %edi,%ecx
80103092:	75 f4                	jne    80103088 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103094:	84 c0                	test   %al,%al
80103096:	75 c8                	jne    80103060 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	89 f0                	mov    %esi,%eax
8010309d:	5b                   	pop    %ebx
8010309e:	5e                   	pop    %esi
8010309f:	5f                   	pop    %edi
801030a0:	5d                   	pop    %ebp
801030a1:	c3                   	ret    
801030a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801030ab:	31 f6                	xor    %esi,%esi
}
801030ad:	89 f0                	mov    %esi,%eax
801030af:	5b                   	pop    %ebx
801030b0:	5e                   	pop    %esi
801030b1:	5f                   	pop    %edi
801030b2:	5d                   	pop    %ebp
801030b3:	c3                   	ret    
801030b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	57                   	push   %edi
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030d7:	c1 e0 08             	shl    $0x8,%eax
801030da:	09 d0                	or     %edx,%eax
801030dc:	c1 e0 04             	shl    $0x4,%eax
801030df:	85 c0                	test   %eax,%eax
801030e1:	75 1b                	jne    801030fe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030f1:	c1 e0 08             	shl    $0x8,%eax
801030f4:	09 d0                	or     %edx,%eax
801030f6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030f9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103103:	e8 38 ff ff ff       	call   80103040 <mpsearch1>
80103108:	85 c0                	test   %eax,%eax
8010310a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010310d:	0f 84 3d 01 00 00    	je     80103250 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103116:	8b 58 04             	mov    0x4(%eax),%ebx
80103119:	85 db                	test   %ebx,%ebx
8010311b:	0f 84 4f 01 00 00    	je     80103270 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103121:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103127:	83 ec 04             	sub    $0x4,%esp
8010312a:	6a 04                	push   $0x4
8010312c:	68 75 81 10 80       	push   $0x80108175
80103131:	56                   	push   %esi
80103132:	e8 89 1f 00 00       	call   801050c0 <memcmp>
80103137:	83 c4 10             	add    $0x10,%esp
8010313a:	85 c0                	test   %eax,%eax
8010313c:	0f 85 2e 01 00 00    	jne    80103270 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103142:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103149:	3c 01                	cmp    $0x1,%al
8010314b:	0f 95 c2             	setne  %dl
8010314e:	3c 04                	cmp    $0x4,%al
80103150:	0f 95 c0             	setne  %al
80103153:	20 c2                	and    %al,%dl
80103155:	0f 85 15 01 00 00    	jne    80103270 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010315b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103162:	66 85 ff             	test   %di,%di
80103165:	74 1a                	je     80103181 <mpinit+0xc1>
80103167:	89 f0                	mov    %esi,%eax
80103169:	01 f7                	add    %esi,%edi
  sum = 0;
8010316b:	31 d2                	xor    %edx,%edx
8010316d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103170:	0f b6 08             	movzbl (%eax),%ecx
80103173:	83 c0 01             	add    $0x1,%eax
80103176:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103178:	39 c7                	cmp    %eax,%edi
8010317a:	75 f4                	jne    80103170 <mpinit+0xb0>
8010317c:	84 d2                	test   %dl,%dl
8010317e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103181:	85 f6                	test   %esi,%esi
80103183:	0f 84 e7 00 00 00    	je     80103270 <mpinit+0x1b0>
80103189:	84 d2                	test   %dl,%dl
8010318b:	0f 85 df 00 00 00    	jne    80103270 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103191:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103197:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801031a3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801031a9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031ae:	01 d6                	add    %edx,%esi
801031b0:	39 c6                	cmp    %eax,%esi
801031b2:	76 23                	jbe    801031d7 <mpinit+0x117>
    switch(*p){
801031b4:	0f b6 10             	movzbl (%eax),%edx
801031b7:	80 fa 04             	cmp    $0x4,%dl
801031ba:	0f 87 ca 00 00 00    	ja     8010328a <mpinit+0x1ca>
801031c0:	ff 24 95 9c 81 10 80 	jmp    *-0x7fef7e64(,%edx,4)
801031c7:	89 f6                	mov    %esi,%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031d3:	39 c6                	cmp    %eax,%esi
801031d5:	77 dd                	ja     801031b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031d7:	85 db                	test   %ebx,%ebx
801031d9:	0f 84 9e 00 00 00    	je     8010327d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031e6:	74 15                	je     801031fd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ed:	ba 22 00 00 00       	mov    $0x22,%edx
801031f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f3:	ba 23 00 00 00       	mov    $0x23,%edx
801031f8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031f9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031fc:	ee                   	out    %al,(%dx)
  }
}
801031fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103200:	5b                   	pop    %ebx
80103201:	5e                   	pop    %esi
80103202:	5f                   	pop    %edi
80103203:	5d                   	pop    %ebp
80103204:	c3                   	ret    
80103205:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103208:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
8010320e:	83 f9 07             	cmp    $0x7,%ecx
80103211:	7f 19                	jg     8010322c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103213:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103217:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010321d:	83 c1 01             	add    $0x1,%ecx
80103220:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103226:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
8010322c:	83 c0 14             	add    $0x14,%eax
      continue;
8010322f:	e9 7c ff ff ff       	jmp    801031b0 <mpinit+0xf0>
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103238:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010323c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010323f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
80103245:	e9 66 ff ff ff       	jmp    801031b0 <mpinit+0xf0>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103250:	ba 00 00 01 00       	mov    $0x10000,%edx
80103255:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010325a:	e8 e1 fd ff ff       	call   80103040 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010325f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103264:	0f 85 a9 fe ff ff    	jne    80103113 <mpinit+0x53>
8010326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103270:	83 ec 0c             	sub    $0xc,%esp
80103273:	68 5d 81 10 80       	push   $0x8010815d
80103278:	e8 13 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010327d:	83 ec 0c             	sub    $0xc,%esp
80103280:	68 7c 81 10 80       	push   $0x8010817c
80103285:	e8 06 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010328a:	31 db                	xor    %ebx,%ebx
8010328c:	e9 26 ff ff ff       	jmp    801031b7 <mpinit+0xf7>
80103291:	66 90                	xchg   %ax,%ax
80103293:	66 90                	xchg   %ax,%ax
80103295:	66 90                	xchg   %ax,%ax
80103297:	66 90                	xchg   %ax,%ax
80103299:	66 90                	xchg   %ax,%ax
8010329b:	66 90                	xchg   %ax,%ax
8010329d:	66 90                	xchg   %ax,%ax
8010329f:	90                   	nop

801032a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a6:	ba 21 00 00 00       	mov    $0x21,%edx
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	ee                   	out    %al,(%dx)
801032ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801032b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032b4:	5d                   	pop    %ebp
801032b5:	c3                   	ret    
801032b6:	66 90                	xchg   %ax,%ax
801032b8:	66 90                	xchg   %ax,%ax
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032db:	e8 a0 da ff ff       	call   80100d80 <filealloc>
801032e0:	85 c0                	test   %eax,%eax
801032e2:	89 03                	mov    %eax,(%ebx)
801032e4:	74 22                	je     80103308 <pipealloc+0x48>
801032e6:	e8 95 da ff ff       	call   80100d80 <filealloc>
801032eb:	85 c0                	test   %eax,%eax
801032ed:	89 06                	mov    %eax,(%esi)
801032ef:	74 3f                	je     80103330 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032f1:	e8 4a f2 ff ff       	call   80102540 <kalloc>
801032f6:	85 c0                	test   %eax,%eax
801032f8:	89 c7                	mov    %eax,%edi
801032fa:	75 54                	jne    80103350 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032fc:	8b 03                	mov    (%ebx),%eax
801032fe:	85 c0                	test   %eax,%eax
80103300:	75 34                	jne    80103336 <pipealloc+0x76>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103308:	8b 06                	mov    (%esi),%eax
8010330a:	85 c0                	test   %eax,%eax
8010330c:	74 0c                	je     8010331a <pipealloc+0x5a>
    fileclose(*f1);
8010330e:	83 ec 0c             	sub    $0xc,%esp
80103311:	50                   	push   %eax
80103312:	e8 29 db ff ff       	call   80100e40 <fileclose>
80103317:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010331a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010331d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	89 f6                	mov    %esi,%esi
80103329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103330:	8b 03                	mov    (%ebx),%eax
80103332:	85 c0                	test   %eax,%eax
80103334:	74 e4                	je     8010331a <pipealloc+0x5a>
    fileclose(*f0);
80103336:	83 ec 0c             	sub    $0xc,%esp
80103339:	50                   	push   %eax
8010333a:	e8 01 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010333f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103341:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103344:	85 c0                	test   %eax,%eax
80103346:	75 c6                	jne    8010330e <pipealloc+0x4e>
80103348:	eb d0                	jmp    8010331a <pipealloc+0x5a>
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103350:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103353:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010335a:	00 00 00 
  p->writeopen = 1;
8010335d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103364:	00 00 00 
  p->nwrite = 0;
80103367:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010336e:	00 00 00 
  p->nread = 0;
80103371:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103378:	00 00 00 
  initlock(&p->lock, "pipe");
8010337b:	68 b0 81 10 80       	push   $0x801081b0
80103380:	50                   	push   %eax
80103381:	e8 9a 1a 00 00       	call   80104e20 <initlock>
  (*f0)->type = FD_PIPE;
80103386:	8b 03                	mov    (%ebx),%eax
  return 0;
80103388:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010338b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103391:	8b 03                	mov    (%ebx),%eax
80103393:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103397:	8b 03                	mov    (%ebx),%eax
80103399:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010339d:	8b 03                	mov    (%ebx),%eax
8010339f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033a2:	8b 06                	mov    (%esi),%eax
801033a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033aa:	8b 06                	mov    (%esi),%eax
801033ac:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033b0:	8b 06                	mov    (%esi),%eax
801033b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033b6:	8b 06                	mov    (%esi),%eax
801033b8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033be:	31 c0                	xor    %eax,%eax
}
801033c0:	5b                   	pop    %ebx
801033c1:	5e                   	pop    %esi
801033c2:	5f                   	pop    %edi
801033c3:	5d                   	pop    %ebp
801033c4:	c3                   	ret    
801033c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	56                   	push   %esi
801033d4:	53                   	push   %ebx
801033d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033db:	83 ec 0c             	sub    $0xc,%esp
801033de:	53                   	push   %ebx
801033df:	e8 7c 1b 00 00       	call   80104f60 <acquire>
  if(writable){
801033e4:	83 c4 10             	add    $0x10,%esp
801033e7:	85 f6                	test   %esi,%esi
801033e9:	74 45                	je     80103430 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033f1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033fb:	00 00 00 
    wakeup(&p->nread);
801033fe:	50                   	push   %eax
801033ff:	e8 fc 14 00 00       	call   80104900 <wakeup>
80103404:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103407:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010340d:	85 d2                	test   %edx,%edx
8010340f:	75 0a                	jne    8010341b <pipeclose+0x4b>
80103411:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103417:	85 c0                	test   %eax,%eax
80103419:	74 35                	je     80103450 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010341b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010341e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103421:	5b                   	pop    %ebx
80103422:	5e                   	pop    %esi
80103423:	5d                   	pop    %ebp
    release(&p->lock);
80103424:	e9 f7 1b 00 00       	jmp    80105020 <release>
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103430:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103436:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103439:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103440:	00 00 00 
    wakeup(&p->nwrite);
80103443:	50                   	push   %eax
80103444:	e8 b7 14 00 00       	call   80104900 <wakeup>
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	eb b9                	jmp    80103407 <pipeclose+0x37>
8010344e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	53                   	push   %ebx
80103454:	e8 c7 1b 00 00       	call   80105020 <release>
    kfree((char*)p);
80103459:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010345c:	83 c4 10             	add    $0x10,%esp
}
8010345f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103462:	5b                   	pop    %ebx
80103463:	5e                   	pop    %esi
80103464:	5d                   	pop    %ebp
    kfree((char*)p);
80103465:	e9 a6 ee ff ff       	jmp    80102310 <kfree>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103470 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 28             	sub    $0x28,%esp
80103479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010347c:	53                   	push   %ebx
8010347d:	e8 de 1a 00 00       	call   80104f60 <acquire>
  for(i = 0; i < n; i++){
80103482:	8b 45 10             	mov    0x10(%ebp),%eax
80103485:	83 c4 10             	add    $0x10,%esp
80103488:	85 c0                	test   %eax,%eax
8010348a:	0f 8e c9 00 00 00    	jle    80103559 <pipewrite+0xe9>
80103490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103493:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103499:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010349f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801034a2:	03 4d 10             	add    0x10(%ebp),%ecx
801034a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801034ae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034b4:	39 d0                	cmp    %edx,%eax
801034b6:	75 71                	jne    80103529 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034b8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	74 4e                	je     80103510 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034c8:	eb 3a                	jmp    80103504 <pipewrite+0x94>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	57                   	push   %edi
801034d4:	e8 27 14 00 00       	call   80104900 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034d9:	5a                   	pop    %edx
801034da:	59                   	pop    %ecx
801034db:	53                   	push   %ebx
801034dc:	56                   	push   %esi
801034dd:	e8 6e 12 00 00       	call   80104750 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034e8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ee:	83 c4 10             	add    $0x10,%esp
801034f1:	05 00 02 00 00       	add    $0x200,%eax
801034f6:	39 c2                	cmp    %eax,%edx
801034f8:	75 36                	jne    80103530 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034fa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103500:	85 c0                	test   %eax,%eax
80103502:	74 0c                	je     80103510 <pipewrite+0xa0>
80103504:	e8 47 09 00 00       	call   80103e50 <myproc>
80103509:	8b 40 24             	mov    0x24(%eax),%eax
8010350c:	85 c0                	test   %eax,%eax
8010350e:	74 c0                	je     801034d0 <pipewrite+0x60>
        release(&p->lock);
80103510:	83 ec 0c             	sub    $0xc,%esp
80103513:	53                   	push   %ebx
80103514:	e8 07 1b 00 00       	call   80105020 <release>
        return -1;
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103524:	5b                   	pop    %ebx
80103525:	5e                   	pop    %esi
80103526:	5f                   	pop    %edi
80103527:	5d                   	pop    %ebp
80103528:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103529:	89 c2                	mov    %eax,%edx
8010352b:	90                   	nop
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103530:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103533:	8d 42 01             	lea    0x1(%edx),%eax
80103536:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010353c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103542:	83 c6 01             	add    $0x1,%esi
80103545:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103549:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010354c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010354f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103553:	0f 85 4f ff ff ff    	jne    801034a8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103559:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	50                   	push   %eax
80103563:	e8 98 13 00 00       	call   80104900 <wakeup>
  release(&p->lock);
80103568:	89 1c 24             	mov    %ebx,(%esp)
8010356b:	e8 b0 1a 00 00       	call   80105020 <release>
  return n;
80103570:	83 c4 10             	add    $0x10,%esp
80103573:	8b 45 10             	mov    0x10(%ebp),%eax
80103576:	eb a9                	jmp    80103521 <pipewrite+0xb1>
80103578:	90                   	nop
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103580 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 18             	sub    $0x18,%esp
80103589:	8b 75 08             	mov    0x8(%ebp),%esi
8010358c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010358f:	56                   	push   %esi
80103590:	e8 cb 19 00 00       	call   80104f60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103595:	83 c4 10             	add    $0x10,%esp
80103598:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010359e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035a4:	75 6a                	jne    80103610 <piperead+0x90>
801035a6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035ac:	85 db                	test   %ebx,%ebx
801035ae:	0f 84 c4 00 00 00    	je     80103678 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035ba:	eb 2d                	jmp    801035e9 <piperead+0x69>
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c0:	83 ec 08             	sub    $0x8,%esp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	e8 86 11 00 00       	call   80104750 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ca:	83 c4 10             	add    $0x10,%esp
801035cd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035d3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035d9:	75 35                	jne    80103610 <piperead+0x90>
801035db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035e1:	85 d2                	test   %edx,%edx
801035e3:	0f 84 8f 00 00 00    	je     80103678 <piperead+0xf8>
    if(myproc()->killed){
801035e9:	e8 62 08 00 00       	call   80103e50 <myproc>
801035ee:	8b 48 24             	mov    0x24(%eax),%ecx
801035f1:	85 c9                	test   %ecx,%ecx
801035f3:	74 cb                	je     801035c0 <piperead+0x40>
      release(&p->lock);
801035f5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035f8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035fd:	56                   	push   %esi
801035fe:	e8 1d 1a 00 00       	call   80105020 <release>
      return -1;
80103603:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103609:	89 d8                	mov    %ebx,%eax
8010360b:	5b                   	pop    %ebx
8010360c:	5e                   	pop    %esi
8010360d:	5f                   	pop    %edi
8010360e:	5d                   	pop    %ebp
8010360f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103610:	8b 45 10             	mov    0x10(%ebp),%eax
80103613:	85 c0                	test   %eax,%eax
80103615:	7e 61                	jle    80103678 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103617:	31 db                	xor    %ebx,%ebx
80103619:	eb 13                	jmp    8010362e <piperead+0xae>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103620:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103626:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010362c:	74 1f                	je     8010364d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010362e:	8d 41 01             	lea    0x1(%ecx),%eax
80103631:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103637:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010363d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103642:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103645:	83 c3 01             	add    $0x1,%ebx
80103648:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010364b:	75 d3                	jne    80103620 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010364d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103653:	83 ec 0c             	sub    $0xc,%esp
80103656:	50                   	push   %eax
80103657:	e8 a4 12 00 00       	call   80104900 <wakeup>
  release(&p->lock);
8010365c:	89 34 24             	mov    %esi,(%esp)
8010365f:	e8 bc 19 00 00       	call   80105020 <release>
  return i;
80103664:	83 c4 10             	add    $0x10,%esp
}
80103667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366a:	89 d8                	mov    %ebx,%eax
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103678:	31 db                	xor    %ebx,%ebx
8010367a:	eb d1                	jmp    8010364d <piperead+0xcd>
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103684:	bb f4 3f 11 80       	mov    $0x80113ff4,%ebx
{
80103689:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010368c:	68 c0 3f 11 80       	push   $0x80113fc0
80103691:	e8 ca 18 00 00       	call   80104f60 <acquire>
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	eb 10                	jmp    801036ab <allocproc+0x2b>
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036a0:	83 eb 80             	sub    $0xffffff80,%ebx
801036a3:	81 fb f4 5f 11 80    	cmp    $0x80115ff4,%ebx
801036a9:	73 75                	jae    80103720 <allocproc+0xa0>
    if(p->state == UNUSED)
801036ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801036ae:	85 c0                	test   %eax,%eax
801036b0:	75 ee                	jne    801036a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036b2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801036b7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036c1:	8d 50 01             	lea    0x1(%eax),%edx
801036c4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801036c7:	68 c0 3f 11 80       	push   $0x80113fc0
  p->pid = nextpid++;
801036cc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801036d2:	e8 49 19 00 00       	call   80105020 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036d7:	e8 64 ee ff ff       	call   80102540 <kalloc>
801036dc:	83 c4 10             	add    $0x10,%esp
801036df:	85 c0                	test   %eax,%eax
801036e1:	89 43 08             	mov    %eax,0x8(%ebx)
801036e4:	74 53                	je     80103739 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036ec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036f4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036f7:	c7 40 14 e7 62 10 80 	movl   $0x801062e7,0x14(%eax)
  p->context = (struct context*)sp;
801036fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103701:	6a 14                	push   $0x14
80103703:	6a 00                	push   $0x0
80103705:	50                   	push   %eax
80103706:	e8 65 19 00 00       	call   80105070 <memset>
  p->context->eip = (uint)forkret;
8010370b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010370e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103711:	c7 40 10 50 37 10 80 	movl   $0x80103750,0x10(%eax)
}
80103718:	89 d8                	mov    %ebx,%eax
8010371a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010371d:	c9                   	leave  
8010371e:	c3                   	ret    
8010371f:	90                   	nop
  release(&ptable.lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103723:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103725:	68 c0 3f 11 80       	push   $0x80113fc0
8010372a:	e8 f1 18 00 00       	call   80105020 <release>
}
8010372f:	89 d8                	mov    %ebx,%eax
  return 0;
80103731:	83 c4 10             	add    $0x10,%esp
}
80103734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103737:	c9                   	leave  
80103738:	c3                   	ret    
    p->state = UNUSED;
80103739:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103740:	31 db                	xor    %ebx,%ebx
80103742:	eb d4                	jmp    80103718 <allocproc+0x98>
80103744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010374a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103750 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103756:	68 c0 3f 11 80       	push   $0x80113fc0
8010375b:	e8 c0 18 00 00       	call   80105020 <release>

  if (first) {
80103760:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	85 c0                	test   %eax,%eax
8010376a:	75 04                	jne    80103770 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010376c:	c9                   	leave  
8010376d:	c3                   	ret    
8010376e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103770:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103773:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010377a:	00 00 00 
    iinit(ROOTDEV);
8010377d:	6a 01                	push   $0x1
8010377f:	e8 fc dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103784:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010378b:	e8 f0 f3 ff ff       	call   80102b80 <initlog>
80103790:	83 c4 10             	add    $0x10,%esp
}
80103793:	c9                   	leave  
80103794:	c3                   	ret    
80103795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037a0 <int_to_string.part.1>:
void int_to_string(int x, char *c){
801037a0:	55                   	push   %ebp
  while(x>0){
801037a1:	85 c0                	test   %eax,%eax
void int_to_string(int x, char *c){
801037a3:	89 e5                	mov    %esp,%ebp
801037a5:	57                   	push   %edi
801037a6:	56                   	push   %esi
801037a7:	53                   	push   %ebx
801037a8:	89 d3                	mov    %edx,%ebx
  while(x>0){
801037aa:	7e 64                	jle    80103810 <int_to_string.part.1+0x70>
801037ac:	89 c1                	mov    %eax,%ecx
  int i=0;
801037ae:	31 f6                	xor    %esi,%esi
    c[i]=x%10+'0';
801037b0:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
801037b5:	8d 76 00             	lea    0x0(%esi),%esi
801037b8:	89 c8                	mov    %ecx,%eax
801037ba:	f7 e7                	mul    %edi
801037bc:	c1 ea 03             	shr    $0x3,%edx
801037bf:	8d 04 92             	lea    (%edx,%edx,4),%eax
801037c2:	01 c0                	add    %eax,%eax
801037c4:	29 c1                	sub    %eax,%ecx
801037c6:	83 c1 30             	add    $0x30,%ecx
801037c9:	88 0c 33             	mov    %cl,(%ebx,%esi,1)
    i++;
801037cc:	83 c6 01             	add    $0x1,%esi
  while(x>0){
801037cf:	85 d2                	test   %edx,%edx
    x/=10;
801037d1:	89 d1                	mov    %edx,%ecx
  while(x>0){
801037d3:	75 e3                	jne    801037b8 <int_to_string.part.1+0x18>
  for(int j=0;j<i/2;j++){
801037d5:	89 f2                	mov    %esi,%edx
  c[i]='\0';
801037d7:	c6 04 33 00          	movb   $0x0,(%ebx,%esi,1)
  for(int j=0;j<i/2;j++){
801037db:	d1 fa                	sar    %edx
801037dd:	74 27                	je     80103806 <int_to_string.part.1+0x66>
801037df:	8d 44 1e ff          	lea    -0x1(%esi,%ebx,1),%eax
801037e3:	89 c6                	mov    %eax,%esi
801037e5:	29 d6                	sub    %edx,%esi
801037e7:	89 f6                	mov    %esi,%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    char a=c[j];
801037f0:	0f b6 13             	movzbl (%ebx),%edx
    c[j]=c[i-j-1];
801037f3:	0f b6 08             	movzbl (%eax),%ecx
801037f6:	83 e8 01             	sub    $0x1,%eax
801037f9:	83 c3 01             	add    $0x1,%ebx
801037fc:	88 4b ff             	mov    %cl,-0x1(%ebx)
    c[i-j-1]=a;
801037ff:	88 50 01             	mov    %dl,0x1(%eax)
  for(int j=0;j<i/2;j++){
80103802:	39 f0                	cmp    %esi,%eax
80103804:	75 ea                	jne    801037f0 <int_to_string.part.1+0x50>
}
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret    
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c[i]='\0';
80103810:	c6 02 00             	movb   $0x0,(%edx)
}
80103813:	5b                   	pop    %ebx
80103814:	5e                   	pop    %esi
80103815:	5f                   	pop    %edi
80103816:	5d                   	pop    %ebp
80103817:	c3                   	ret    
80103818:	90                   	nop
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103820 <int_to_string>:
void int_to_string(int x, char *c){
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	8b 45 08             	mov    0x8(%ebp),%eax
80103826:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(x==0){
80103829:	85 c0                	test   %eax,%eax
8010382b:	74 0b                	je     80103838 <int_to_string+0x18>
}
8010382d:	5d                   	pop    %ebp
8010382e:	e9 6d ff ff ff       	jmp    801037a0 <int_to_string.part.1>
80103833:	90                   	nop
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c[0]='0';
80103838:	b8 30 00 00 00       	mov    $0x30,%eax
8010383d:	66 89 02             	mov    %ax,(%edx)
}
80103840:	5d                   	pop    %ebp
80103841:	c3                   	ret    
80103842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <rpop>:
struct proc* rpop(){
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 10             	sub    $0x10,%esp
  acquire(&rqueue.lock);
80103857:	68 40 3d 11 80       	push   $0x80113d40
8010385c:	e8 ff 16 00 00       	call   80104f60 <acquire>
  if(rqueue.s==rqueue.e){
80103861:	8b 15 74 3e 11 80    	mov    0x80113e74,%edx
80103867:	83 c4 10             	add    $0x10,%esp
8010386a:	3b 15 78 3e 11 80    	cmp    0x80113e78,%edx
80103870:	74 3e                	je     801038b0 <rpop+0x60>
  struct proc *p=rqueue.queue[rqueue.s];
80103872:	8b 1c 95 74 3d 11 80 	mov    -0x7feec28c(,%edx,4),%ebx
  (rqueue.s)++;
80103879:	83 c2 01             	add    $0x1,%edx
  release(&rqueue.lock);
8010387c:	83 ec 0c             	sub    $0xc,%esp
  (rqueue.s)%=NPROC;
8010387f:	89 d0                	mov    %edx,%eax
  release(&rqueue.lock);
80103881:	68 40 3d 11 80       	push   $0x80113d40
  (rqueue.s)%=NPROC;
80103886:	c1 f8 1f             	sar    $0x1f,%eax
80103889:	c1 e8 1a             	shr    $0x1a,%eax
8010388c:	01 c2                	add    %eax,%edx
8010388e:	83 e2 3f             	and    $0x3f,%edx
80103891:	29 c2                	sub    %eax,%edx
80103893:	89 15 74 3e 11 80    	mov    %edx,0x80113e74
  release(&rqueue.lock);
80103899:	e8 82 17 00 00       	call   80105020 <release>
  return p;
8010389e:	83 c4 10             	add    $0x10,%esp
}
801038a1:	89 d8                	mov    %ebx,%eax
801038a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a6:	c9                   	leave  
801038a7:	c3                   	ret    
801038a8:	90                   	nop
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  	release(&rqueue.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  	return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  	release(&rqueue.lock);
801038b5:	68 40 3d 11 80       	push   $0x80113d40
801038ba:	e8 61 17 00 00       	call   80105020 <release>
  	return 0;
801038bf:	83 c4 10             	add    $0x10,%esp
801038c2:	eb dd                	jmp    801038a1 <rpop+0x51>
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <rpop2>:
struct proc* rpop2(){
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 10             	sub    $0x10,%esp
	acquire(&rqueue2.lock);
801038d7:	68 80 3e 11 80       	push   $0x80113e80
801038dc:	e8 7f 16 00 00       	call   80104f60 <acquire>
	if(rqueue2.s==rqueue2.e){
801038e1:	8b 15 b4 3f 11 80    	mov    0x80113fb4,%edx
801038e7:	83 c4 10             	add    $0x10,%esp
801038ea:	3b 15 b8 3f 11 80    	cmp    0x80113fb8,%edx
801038f0:	74 3e                	je     80103930 <rpop2+0x60>
	struct proc* p=rqueue2.queue[rqueue2.s];
801038f2:	8b 1c 95 b4 3e 11 80 	mov    -0x7feec14c(,%edx,4),%ebx
	(rqueue2.s)++;
801038f9:	83 c2 01             	add    $0x1,%edx
	release(&rqueue2.lock);
801038fc:	83 ec 0c             	sub    $0xc,%esp
	(rqueue2.s)%=NPROC;
801038ff:	89 d0                	mov    %edx,%eax
	release(&rqueue2.lock);
80103901:	68 80 3e 11 80       	push   $0x80113e80
	(rqueue2.s)%=NPROC;
80103906:	c1 f8 1f             	sar    $0x1f,%eax
80103909:	c1 e8 1a             	shr    $0x1a,%eax
8010390c:	01 c2                	add    %eax,%edx
8010390e:	83 e2 3f             	and    $0x3f,%edx
80103911:	29 c2                	sub    %eax,%edx
80103913:	89 15 b4 3f 11 80    	mov    %edx,0x80113fb4
	release(&rqueue2.lock);
80103919:	e8 02 17 00 00       	call   80105020 <release>
	return p;
8010391e:	83 c4 10             	add    $0x10,%esp
}
80103921:	89 d8                	mov    %ebx,%eax
80103923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103926:	c9                   	leave  
80103927:	c3                   	ret    
80103928:	90                   	nop
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		release(&rqueue2.lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
		return 0;
80103933:	31 db                	xor    %ebx,%ebx
		release(&rqueue2.lock);
80103935:	68 80 3e 11 80       	push   $0x80113e80
8010393a:	e8 e1 16 00 00       	call   80105020 <release>
		return 0;
8010393f:	83 c4 10             	add    $0x10,%esp
80103942:	eb dd                	jmp    80103921 <rpop2+0x51>
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <rpush>:
int rpush(struct proc *p){
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 14             	sub    $0x14,%esp
  acquire(&rqueue.lock);
80103956:	68 40 3d 11 80       	push   $0x80113d40
8010395b:	e8 00 16 00 00       	call   80104f60 <acquire>
  if((rqueue.e+1)%NPROC==rqueue.s){
80103960:	8b 0d 78 3e 11 80    	mov    0x80113e78,%ecx
80103966:	83 c4 10             	add    $0x10,%esp
80103969:	8d 41 01             	lea    0x1(%ecx),%eax
8010396c:	99                   	cltd   
8010396d:	c1 ea 1a             	shr    $0x1a,%edx
80103970:	01 d0                	add    %edx,%eax
80103972:	83 e0 3f             	and    $0x3f,%eax
80103975:	29 d0                	sub    %edx,%eax
80103977:	3b 05 74 3e 11 80    	cmp    0x80113e74,%eax
8010397d:	74 29                	je     801039a8 <rpush+0x58>
  rqueue.queue[rqueue.e]=p;
8010397f:	8b 55 08             	mov    0x8(%ebp),%edx
  release(&rqueue.lock);
80103982:	83 ec 0c             	sub    $0xc,%esp
  (rqueue.e)%=NPROC;
80103985:	a3 78 3e 11 80       	mov    %eax,0x80113e78
  release(&rqueue.lock);
8010398a:	68 40 3d 11 80       	push   $0x80113d40
  rqueue.queue[rqueue.e]=p;
8010398f:	89 14 8d 74 3d 11 80 	mov    %edx,-0x7feec28c(,%ecx,4)
  release(&rqueue.lock);
80103996:	e8 85 16 00 00       	call   80105020 <release>
  return 1;
8010399b:	83 c4 10             	add    $0x10,%esp
8010399e:	b8 01 00 00 00       	mov    $0x1,%eax
}
801039a3:	c9                   	leave  
801039a4:	c3                   	ret    
801039a5:	8d 76 00             	lea    0x0(%esi),%esi
  	release(&rqueue.lock);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	68 40 3d 11 80       	push   $0x80113d40
801039b0:	e8 6b 16 00 00       	call   80105020 <release>
	return 0;
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	31 c0                	xor    %eax,%eax
}
801039ba:	c9                   	leave  
801039bb:	c3                   	ret    
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <rpush2>:
int rpush2(struct proc* p){
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
	acquire(&rqueue2.lock);
801039c6:	68 80 3e 11 80       	push   $0x80113e80
801039cb:	e8 90 15 00 00       	call   80104f60 <acquire>
	if((rqueue2.e+1)%NPROC==rqueue2.s){
801039d0:	8b 0d b8 3f 11 80    	mov    0x80113fb8,%ecx
801039d6:	83 c4 10             	add    $0x10,%esp
801039d9:	8d 41 01             	lea    0x1(%ecx),%eax
801039dc:	99                   	cltd   
801039dd:	c1 ea 1a             	shr    $0x1a,%edx
801039e0:	01 d0                	add    %edx,%eax
801039e2:	83 e0 3f             	and    $0x3f,%eax
801039e5:	29 d0                	sub    %edx,%eax
801039e7:	3b 05 b4 3f 11 80    	cmp    0x80113fb4,%eax
801039ed:	74 29                	je     80103a18 <rpush2+0x58>
	rqueue2.queue[rqueue2.e]=p;
801039ef:	8b 55 08             	mov    0x8(%ebp),%edx
	release(&rqueue2.lock);
801039f2:	83 ec 0c             	sub    $0xc,%esp
	(rqueue2.e)%=NPROC;
801039f5:	a3 b8 3f 11 80       	mov    %eax,0x80113fb8
	release(&rqueue2.lock);
801039fa:	68 80 3e 11 80       	push   $0x80113e80
	rqueue2.queue[rqueue2.e]=p;
801039ff:	89 14 8d b4 3e 11 80 	mov    %edx,-0x7feec14c(,%ecx,4)
	release(&rqueue2.lock);
80103a06:	e8 15 16 00 00       	call   80105020 <release>
	return 1;
80103a0b:	83 c4 10             	add    $0x10,%esp
80103a0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103a13:	c9                   	leave  
80103a14:	c3                   	ret    
80103a15:	8d 76 00             	lea    0x0(%esi),%esi
		release(&rqueue2.lock);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	68 80 3e 11 80       	push   $0x80113e80
80103a20:	e8 fb 15 00 00       	call   80105020 <release>
		return 0;
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	31 c0                	xor    %eax,%eax
}
80103a2a:	c9                   	leave  
80103a2b:	c3                   	ret    
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <pinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a36:	68 b5 81 10 80       	push   $0x801081b5
80103a3b:	68 c0 3f 11 80       	push   $0x80113fc0
80103a40:	e8 db 13 00 00       	call   80104e20 <initlock>
  initlock(&rqueue2.lock, "rqueue2");
80103a45:	58                   	pop    %eax
80103a46:	5a                   	pop    %edx
80103a47:	68 bc 81 10 80       	push   $0x801081bc
80103a4c:	68 80 3e 11 80       	push   $0x80113e80
80103a51:	e8 ca 13 00 00       	call   80104e20 <initlock>
  initlock(&rqueue.lock, "rqueue");
80103a56:	59                   	pop    %ecx
80103a57:	58                   	pop    %eax
80103a58:	68 c4 81 10 80       	push   $0x801081c4
80103a5d:	68 40 3d 11 80       	push   $0x80113d40
80103a62:	e8 b9 13 00 00       	call   80104e20 <initlock>
  initlock(&sleeping_channel_lock, "sleeping_channel");
80103a67:	58                   	pop    %eax
80103a68:	5a                   	pop    %edx
80103a69:	68 cb 81 10 80       	push   $0x801081cb
80103a6e:	68 a0 68 11 80       	push   $0x801168a0
80103a73:	e8 a8 13 00 00       	call   80104e20 <initlock>
}
80103a78:	83 c4 10             	add    $0x10,%esp
80103a7b:	c9                   	leave  
80103a7c:	c3                   	ret    
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi

80103a80 <mycpu>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a85:	9c                   	pushf  
80103a86:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a87:	f6 c4 02             	test   $0x2,%ah
80103a8a:	75 5e                	jne    80103aea <mycpu+0x6a>
  apicid = lapicid();
80103a8c:	e8 1f ed ff ff       	call   801027b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a91:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103a97:	85 f6                	test   %esi,%esi
80103a99:	7e 42                	jle    80103add <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a9b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103aa2:	39 d0                	cmp    %edx,%eax
80103aa4:	74 30                	je     80103ad6 <mycpu+0x56>
80103aa6:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103aab:	31 d2                	xor    %edx,%edx
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
80103ab0:	83 c2 01             	add    $0x1,%edx
80103ab3:	39 f2                	cmp    %esi,%edx
80103ab5:	74 26                	je     80103add <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103ab7:	0f b6 19             	movzbl (%ecx),%ebx
80103aba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ac0:	39 c3                	cmp    %eax,%ebx
80103ac2:	75 ec                	jne    80103ab0 <mycpu+0x30>
80103ac4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103aca:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
80103acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad2:	5b                   	pop    %ebx
80103ad3:	5e                   	pop    %esi
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103ad6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
80103adb:	eb f2                	jmp    80103acf <mycpu+0x4f>
  panic("unknown apicid\n");
80103add:	83 ec 0c             	sub    $0xc,%esp
80103ae0:	68 dc 81 10 80       	push   $0x801081dc
80103ae5:	e8 a6 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 60 83 10 80       	push   $0x80108360
80103af2:	e8 99 c8 ff ff       	call   80100390 <panic>
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <cpuid>:
cpuid() {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b06:	e8 75 ff ff ff       	call   80103a80 <mycpu>
80103b0b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103b10:	c9                   	leave  
  return mycpu()-cpus;
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1a:	c3                   	ret    
80103b1b:	90                   	nop
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b20 <proc_write>:
int proc_write(int fd, char *p, int n){
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
80103b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103b2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(fd>= NOFILE || fd<0|| (f=myproc()->ofile[fd])== 0)return -1;
80103b32:	83 fb 0f             	cmp    $0xf,%ebx
80103b35:	77 39                	ja     80103b70 <proc_write+0x50>
  pushcli();
80103b37:	e8 54 13 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103b3c:	e8 3f ff ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103b41:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103b47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80103b4a:	e8 81 13 00 00       	call   80104ed0 <popcli>
  if(fd>= NOFILE || fd<0|| (f=myproc()->ofile[fd])== 0)return -1;
80103b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b52:	8b 44 98 28          	mov    0x28(%eax,%ebx,4),%eax
80103b56:	85 c0                	test   %eax,%eax
80103b58:	74 16                	je     80103b70 <proc_write+0x50>
  return filewrite(f, p, n);
80103b5a:	89 7d 10             	mov    %edi,0x10(%ebp)
80103b5d:	89 75 0c             	mov    %esi,0xc(%ebp)
80103b60:	89 45 08             	mov    %eax,0x8(%ebp)
}
80103b63:	83 c4 1c             	add    $0x1c,%esp
80103b66:	5b                   	pop    %ebx
80103b67:	5e                   	pop    %esi
80103b68:	5f                   	pop    %edi
80103b69:	5d                   	pop    %ebp
  return filewrite(f, p, n);
80103b6a:	e9 81 d4 ff ff       	jmp    80100ff0 <filewrite>
80103b6f:	90                   	nop
}
80103b70:	83 c4 1c             	add    $0x1c,%esp
80103b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b78:	5b                   	pop    %ebx
80103b79:	5e                   	pop    %esi
80103b7a:	5f                   	pop    %edi
80103b7b:	5d                   	pop    %ebp
80103b7c:	c3                   	ret    
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi

80103b80 <proc_close>:
int proc_close(int fd){
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 0c             	sub    $0xc,%esp
80103b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)return -1;
80103b8c:	83 fb 0f             	cmp    $0xf,%ebx
80103b8f:	77 57                	ja     80103be8 <proc_close+0x68>
  pushcli();
80103b91:	e8 fa 12 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103b96:	e8 e5 fe ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103b9b:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)return -1;
80103ba1:	83 c3 08             	add    $0x8,%ebx
  popcli();
80103ba4:	e8 27 13 00 00       	call   80104ed0 <popcli>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)return -1;
80103ba9:	8b 74 9e 08          	mov    0x8(%esi,%ebx,4),%esi
80103bad:	85 f6                	test   %esi,%esi
80103baf:	74 37                	je     80103be8 <proc_close+0x68>
  pushcli();
80103bb1:	e8 da 12 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103bb6:	e8 c5 fe ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103bbb:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103bc1:	e8 0a 13 00 00       	call   80104ed0 <popcli>
  fileclose(f);
80103bc6:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80103bc9:	c7 44 9f 08 00 00 00 	movl   $0x0,0x8(%edi,%ebx,4)
80103bd0:	00 
  fileclose(f);
80103bd1:	56                   	push   %esi
80103bd2:	e8 69 d2 ff ff       	call   80100e40 <fileclose>
  return 0;
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	31 c0                	xor    %eax,%eax
}
80103bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bdf:	5b                   	pop    %ebx
80103be0:	5e                   	pop    %esi
80103be1:	5f                   	pop    %edi
80103be2:	5d                   	pop    %ebp
80103be3:	c3                   	ret    
80103be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)return -1;
80103be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bed:	eb ed                	jmp    80103bdc <proc_close+0x5c>
80103bef:	90                   	nop

80103bf0 <proc_read>:
int proc_read(int fd, int n, char *p){
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
80103bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103bff:	8b 75 10             	mov    0x10(%ebp),%esi
  if(fd >= NOFILE|| fd<0 || (f=myproc()->ofile[fd]) == 0)return -1;
80103c02:	83 fb 0f             	cmp    $0xf,%ebx
80103c05:	77 39                	ja     80103c40 <proc_read+0x50>
  pushcli();
80103c07:	e8 84 12 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103c0c:	e8 6f fe ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103c11:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103c17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80103c1a:	e8 b1 12 00 00       	call   80104ed0 <popcli>
  if(fd >= NOFILE|| fd<0 || (f=myproc()->ofile[fd]) == 0)return -1;
80103c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c22:	8b 44 98 28          	mov    0x28(%eax,%ebx,4),%eax
80103c26:	85 c0                	test   %eax,%eax
80103c28:	74 16                	je     80103c40 <proc_read+0x50>
  return fileread(f, p, n);
80103c2a:	89 7d 10             	mov    %edi,0x10(%ebp)
80103c2d:	89 75 0c             	mov    %esi,0xc(%ebp)
80103c30:	89 45 08             	mov    %eax,0x8(%ebp)
}
80103c33:	83 c4 1c             	add    $0x1c,%esp
80103c36:	5b                   	pop    %ebx
80103c37:	5e                   	pop    %esi
80103c38:	5f                   	pop    %edi
80103c39:	5d                   	pop    %ebp
  return fileread(f, p, n);
80103c3a:	e9 21 d3 ff ff       	jmp    80100f60 <fileread>
80103c3f:	90                   	nop
}
80103c40:	83 c4 1c             	add    $0x1c,%esp
80103c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c48:	5b                   	pop    %ebx
80103c49:	5e                   	pop    %esi
80103c4a:	5f                   	pop    %edi
80103c4b:	5d                   	pop    %ebp
80103c4c:	c3                   	ret    
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <proc_open>:
int proc_open(char *path, int omode){
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 2c             	sub    $0x2c,%esp
80103c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  begin_op();
80103c5c:	e8 bf ef ff ff       	call   80102c20 <begin_op>
  if(omode & O_CREATE){
80103c61:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
80103c68:	74 76                	je     80103ce0 <proc_open+0x90>
  if((dp = nameiparent(path, name)) == 0)
80103c6a:	8d 7d da             	lea    -0x26(%ebp),%edi
80103c6d:	83 ec 08             	sub    $0x8,%esp
80103c70:	57                   	push   %edi
80103c71:	53                   	push   %ebx
80103c72:	e8 89 e2 ff ff       	call   80101f00 <nameiparent>
80103c77:	83 c4 10             	add    $0x10,%esp
80103c7a:	85 c0                	test   %eax,%eax
80103c7c:	89 c6                	mov    %eax,%esi
80103c7e:	74 49                	je     80103cc9 <proc_open+0x79>
  ilock(dp);
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	50                   	push   %eax
80103c84:	e8 f7 d9 ff ff       	call   80101680 <ilock>
  if((ip = dirlookup(dp, name, 0)) != 0){
80103c89:	83 c4 0c             	add    $0xc,%esp
80103c8c:	6a 00                	push   $0x0
80103c8e:	57                   	push   %edi
80103c8f:	56                   	push   %esi
80103c90:	e8 1b df ff ff       	call   80101bb0 <dirlookup>
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	85 c0                	test   %eax,%eax
80103c9a:	89 c3                	mov    %eax,%ebx
80103c9c:	0f 84 fe 00 00 00    	je     80103da0 <proc_open+0x150>
    iunlockput(dp);
80103ca2:	83 ec 0c             	sub    $0xc,%esp
80103ca5:	56                   	push   %esi
80103ca6:	e8 65 dc ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80103cab:	89 1c 24             	mov    %ebx,(%esp)
80103cae:	e8 cd d9 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80103cbb:	74 53                	je     80103d10 <proc_open+0xc0>
    iunlockput(ip);
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	53                   	push   %ebx
80103cc1:	e8 4a dc ff ff       	call   80101910 <iunlockput>
80103cc6:	83 c4 10             	add    $0x10,%esp
      end_op();
80103cc9:	e8 c2 ef ff ff       	call   80102c90 <end_op>
      return -1;
80103cce:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103cd3:	e9 ba 00 00 00       	jmp    80103d92 <proc_open+0x142>
80103cd8:	90                   	nop
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	53                   	push   %ebx
80103ce4:	e8 f7 e1 ff ff       	call   80101ee0 <namei>
80103ce9:	83 c4 10             	add    $0x10,%esp
80103cec:	85 c0                	test   %eax,%eax
80103cee:	89 c3                	mov    %eax,%ebx
80103cf0:	74 d7                	je     80103cc9 <proc_open+0x79>
    ilock(ip);
80103cf2:	83 ec 0c             	sub    $0xc,%esp
80103cf5:	50                   	push   %eax
80103cf6:	e8 85 d9 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80103cfb:	83 c4 10             	add    $0x10,%esp
80103cfe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80103d03:	75 0b                	jne    80103d10 <proc_open+0xc0>
80103d05:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d08:	85 d2                	test   %edx,%edx
80103d0a:	0f 85 fc 00 00 00    	jne    80103e0c <proc_open+0x1bc>
  if((f = filealloc()) == 0 || (fd = proc_fdalloc(f)) < 0){
80103d10:	e8 6b d0 ff ff       	call   80100d80 <filealloc>
80103d15:	85 c0                	test   %eax,%eax
80103d17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d1a:	0f 84 ec 00 00 00    	je     80103e0c <proc_open+0x1bc>
  pushcli();
80103d20:	e8 6b 11 00 00       	call   80104e90 <pushcli>
  for(fd = 0; fd < NOFILE; fd++){
80103d25:	31 f6                	xor    %esi,%esi
  c = mycpu();
80103d27:	e8 54 fd ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103d2c:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103d32:	e8 99 11 00 00       	call   80104ed0 <popcli>
  for(fd = 0; fd < NOFILE; fd++){
80103d37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103d3a:	eb 10                	jmp    80103d4c <proc_open+0xfc>
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d40:	83 c6 01             	add    $0x1,%esi
80103d43:	83 fe 10             	cmp    $0x10,%esi
80103d46:	0f 84 b4 00 00 00    	je     80103e00 <proc_open+0x1b0>
    if(curproc->ofile[fd] == 0){
80103d4c:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
80103d50:	85 c0                	test   %eax,%eax
80103d52:	75 ec                	jne    80103d40 <proc_open+0xf0>
  iunlock(ip);
80103d54:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80103d57:	89 54 b7 28          	mov    %edx,0x28(%edi,%esi,4)
80103d5b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  iunlock(ip);
80103d5e:	53                   	push   %ebx
80103d5f:	e8 fc d9 ff ff       	call   80101760 <iunlock>
  end_op();
80103d64:	e8 27 ef ff ff       	call   80102c90 <end_op>
  f->readable = !(omode & O_WRONLY);
80103d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80103d6c:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80103d6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  f->readable = !(omode & O_WRONLY);
80103d72:	f7 d0                	not    %eax
  f->ip = ip;
80103d74:	89 5a 10             	mov    %ebx,0x10(%edx)
  f->off = 0;
80103d77:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
  f->readable = !(omode & O_WRONLY);
80103d7e:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80103d81:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  f->type = FD_INODE;
80103d85:	c7 02 02 00 00 00    	movl   $0x2,(%edx)
  f->readable = !(omode & O_WRONLY);
80103d8b:	88 42 08             	mov    %al,0x8(%edx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80103d8e:	0f 95 42 09          	setne  0x9(%edx)
}
80103d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d95:	89 f0                	mov    %esi,%eax
80103d97:	5b                   	pop    %ebx
80103d98:	5e                   	pop    %esi
80103d99:	5f                   	pop    %edi
80103d9a:	5d                   	pop    %ebp
80103d9b:	c3                   	ret    
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80103da0:	83 ec 08             	sub    $0x8,%esp
80103da3:	6a 02                	push   $0x2
80103da5:	ff 36                	pushl  (%esi)
80103da7:	e8 64 d7 ff ff       	call   80101510 <ialloc>
80103dac:	83 c4 10             	add    $0x10,%esp
80103daf:	85 c0                	test   %eax,%eax
80103db1:	89 c3                	mov    %eax,%ebx
80103db3:	74 7f                	je     80103e34 <proc_open+0x1e4>
  ilock(ip);
80103db5:	83 ec 0c             	sub    $0xc,%esp
80103db8:	50                   	push   %eax
80103db9:	e8 c2 d8 ff ff       	call   80101680 <ilock>
  ip->minor = minor;
80103dbe:	b9 01 00 00 00       	mov    $0x1,%ecx
  ip->major = major;
80103dc3:	c7 43 52 00 00 00 00 	movl   $0x0,0x52(%ebx)
  ip->minor = minor;
80103dca:	66 89 4b 56          	mov    %cx,0x56(%ebx)
  iupdate(ip);
80103dce:	89 1c 24             	mov    %ebx,(%esp)
80103dd1:	e8 fa d7 ff ff       	call   801015d0 <iupdate>
  if(dirlink(dp, name, ip->inum) < 0)panic("create: dirlink");
80103dd6:	83 c4 0c             	add    $0xc,%esp
80103dd9:	ff 73 04             	pushl  0x4(%ebx)
80103ddc:	57                   	push   %edi
80103ddd:	56                   	push   %esi
80103dde:	e8 3d e0 ff ff       	call   80101e20 <dirlink>
80103de3:	83 c4 10             	add    $0x10,%esp
80103de6:	85 c0                	test   %eax,%eax
80103de8:	78 3d                	js     80103e27 <proc_open+0x1d7>
  iunlockput(dp);
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	56                   	push   %esi
80103dee:	e8 1d db ff ff       	call   80101910 <iunlockput>
80103df3:	83 c4 10             	add    $0x10,%esp
80103df6:	e9 15 ff ff ff       	jmp    80103d10 <proc_open+0xc0>
80103dfb:	90                   	nop
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(f)fileclose(f);
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	52                   	push   %edx
80103e04:	e8 37 d0 ff ff       	call   80100e40 <fileclose>
80103e09:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103e0f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    iunlockput(ip);
80103e14:	53                   	push   %ebx
80103e15:	e8 f6 da ff ff       	call   80101910 <iunlockput>
    end_op();
80103e1a:	e8 71 ee ff ff       	call   80102c90 <end_op>
    return -1;
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	e9 6b ff ff ff       	jmp    80103d92 <proc_open+0x142>
  if(dirlink(dp, name, ip->inum) < 0)panic("create: dirlink");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 fb 81 10 80       	push   $0x801081fb
80103e2f:	e8 5c c5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 ec 81 10 80       	push   $0x801081ec
80103e3c:	e8 4f c5 ff ff       	call   80100390 <panic>
80103e41:	eb 0d                	jmp    80103e50 <myproc>
80103e43:	90                   	nop
80103e44:	90                   	nop
80103e45:	90                   	nop
80103e46:	90                   	nop
80103e47:	90                   	nop
80103e48:	90                   	nop
80103e49:	90                   	nop
80103e4a:	90                   	nop
80103e4b:	90                   	nop
80103e4c:	90                   	nop
80103e4d:	90                   	nop
80103e4e:	90                   	nop
80103e4f:	90                   	nop

80103e50 <myproc>:
myproc(void) {
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e57:	e8 34 10 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103e5c:	e8 1f fc ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103e61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e67:	e8 64 10 00 00       	call   80104ed0 <popcli>
}
80103e6c:	83 c4 04             	add    $0x4,%esp
80103e6f:	89 d8                	mov    %ebx,%eax
80103e71:	5b                   	pop    %ebx
80103e72:	5d                   	pop    %ebp
80103e73:	c3                   	ret    
80103e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e80 <userinit>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	53                   	push   %ebx
80103e84:	83 ec 10             	sub    $0x10,%esp
  acquire(&rqueue.lock);
80103e87:	68 40 3d 11 80       	push   $0x80113d40
80103e8c:	e8 cf 10 00 00       	call   80104f60 <acquire>
  release(&rqueue.lock);
80103e91:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
  rqueue.s=0;
80103e98:	c7 05 74 3e 11 80 00 	movl   $0x0,0x80113e74
80103e9f:	00 00 00 
  rqueue.e=0;
80103ea2:	c7 05 78 3e 11 80 00 	movl   $0x0,0x80113e78
80103ea9:	00 00 00 
  release(&rqueue.lock);
80103eac:	e8 6f 11 00 00       	call   80105020 <release>
  acquire(&rqueue2.lock);
80103eb1:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80103eb8:	e8 a3 10 00 00       	call   80104f60 <acquire>
  release(&rqueue2.lock);
80103ebd:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
  rqueue2.s=0;
80103ec4:	c7 05 b4 3f 11 80 00 	movl   $0x0,0x80113fb4
80103ecb:	00 00 00 
  rqueue2.e=0;
80103ece:	c7 05 b8 3f 11 80 00 	movl   $0x0,0x80113fb8
80103ed5:	00 00 00 
  release(&rqueue2.lock);
80103ed8:	e8 43 11 00 00       	call   80105020 <release>
  p = allocproc();
80103edd:	e8 9e f7 ff ff       	call   80103680 <allocproc>
80103ee2:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ee4:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  if((p->pgdir = setupkvm()) == 0)
80103ee9:	e8 b2 3a 00 00       	call   801079a0 <setupkvm>
80103eee:	83 c4 10             	add    $0x10,%esp
80103ef1:	85 c0                	test   %eax,%eax
80103ef3:	89 43 04             	mov    %eax,0x4(%ebx)
80103ef6:	0f 84 bd 00 00 00    	je     80103fb9 <userinit+0x139>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103efc:	83 ec 04             	sub    $0x4,%esp
80103eff:	68 2c 00 00 00       	push   $0x2c
80103f04:	68 60 b4 10 80       	push   $0x8010b460
80103f09:	50                   	push   %eax
80103f0a:	e8 01 37 00 00       	call   80107610 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f0f:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f12:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f18:	6a 4c                	push   $0x4c
80103f1a:	6a 00                	push   $0x0
80103f1c:	ff 73 18             	pushl  0x18(%ebx)
80103f1f:	e8 4c 11 00 00       	call   80105070 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f24:	8b 43 18             	mov    0x18(%ebx),%eax
80103f27:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f2c:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f31:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f34:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f38:	8b 43 18             	mov    0x18(%ebx),%eax
80103f3b:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f42:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f46:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f51:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f55:	8b 43 18             	mov    0x18(%ebx),%eax
80103f58:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f62:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f69:	8b 43 18             	mov    0x18(%ebx),%eax
80103f6c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f73:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f76:	6a 10                	push   $0x10
80103f78:	68 24 82 10 80       	push   $0x80108224
80103f7d:	50                   	push   %eax
80103f7e:	e8 cd 12 00 00       	call   80105250 <safestrcpy>
  p->cwd = namei("/");
80103f83:	c7 04 24 2d 82 10 80 	movl   $0x8010822d,(%esp)
80103f8a:	e8 51 df ff ff       	call   80101ee0 <namei>
80103f8f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f92:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80103f99:	e8 c2 0f 00 00       	call   80104f60 <acquire>
  p->state = RUNNABLE;
80103f9e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fa5:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80103fac:	e8 6f 10 00 00       	call   80105020 <release>
}
80103fb1:	83 c4 10             	add    $0x10,%esp
80103fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb7:	c9                   	leave  
80103fb8:	c3                   	ret    
    panic("userinit: out of memory?");
80103fb9:	83 ec 0c             	sub    $0xc,%esp
80103fbc:	68 0b 82 10 80       	push   $0x8010820b
80103fc1:	e8 ca c3 ff ff       	call   80100390 <panic>
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <growproc>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103fd8:	e8 b3 0e 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80103fdd:	e8 9e fa ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103fe2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe8:	e8 e3 0e 00 00       	call   80104ed0 <popcli>
  if(n > 0){
80103fed:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ff0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ff2:	7f 1c                	jg     80104010 <growproc+0x40>
  } else if(n < 0){
80103ff4:	75 3a                	jne    80104030 <growproc+0x60>
  switchuvm(curproc);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ff9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ffb:	53                   	push   %ebx
80103ffc:	e8 ff 34 00 00       	call   80107500 <switchuvm>
  return 0;
80104001:	83 c4 10             	add    $0x10,%esp
80104004:	31 c0                	xor    %eax,%eax
}
80104006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
8010400c:	c3                   	ret    
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104010:	83 ec 04             	sub    $0x4,%esp
80104013:	01 c6                	add    %eax,%esi
80104015:	56                   	push   %esi
80104016:	50                   	push   %eax
80104017:	ff 73 04             	pushl  0x4(%ebx)
8010401a:	e8 31 37 00 00       	call   80107750 <allocuvm>
8010401f:	83 c4 10             	add    $0x10,%esp
80104022:	85 c0                	test   %eax,%eax
80104024:	75 d0                	jne    80103ff6 <growproc+0x26>
      return -1;
80104026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010402b:	eb d9                	jmp    80104006 <growproc+0x36>
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104030:	83 ec 04             	sub    $0x4,%esp
80104033:	01 c6                	add    %eax,%esi
80104035:	56                   	push   %esi
80104036:	50                   	push   %eax
80104037:	ff 73 04             	pushl  0x4(%ebx)
8010403a:	e8 b1 38 00 00       	call   801078f0 <deallocuvm>
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	85 c0                	test   %eax,%eax
80104044:	75 b0                	jne    80103ff6 <growproc+0x26>
80104046:	eb de                	jmp    80104026 <growproc+0x56>
80104048:	90                   	nop
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104050 <fork>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104059:	e8 32 0e 00 00       	call   80104e90 <pushcli>
  c = mycpu();
8010405e:	e8 1d fa ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80104063:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104069:	e8 62 0e 00 00       	call   80104ed0 <popcli>
  if((np = allocproc()) == 0){
8010406e:	e8 0d f6 ff ff       	call   80103680 <allocproc>
80104073:	85 c0                	test   %eax,%eax
80104075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104078:	0f 84 b7 00 00 00    	je     80104135 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010407e:	83 ec 08             	sub    $0x8,%esp
80104081:	ff 33                	pushl  (%ebx)
80104083:	ff 73 04             	pushl  0x4(%ebx)
80104086:	89 c7                	mov    %eax,%edi
80104088:	e8 e3 39 00 00       	call   80107a70 <copyuvm>
8010408d:	83 c4 10             	add    $0x10,%esp
80104090:	85 c0                	test   %eax,%eax
80104092:	89 47 04             	mov    %eax,0x4(%edi)
80104095:	0f 84 a1 00 00 00    	je     8010413c <fork+0xec>
  np->sz = curproc->sz;
8010409b:	8b 03                	mov    (%ebx),%eax
8010409d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040a0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801040a2:	89 59 14             	mov    %ebx,0x14(%ecx)
801040a5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
801040a7:	8b 79 18             	mov    0x18(%ecx),%edi
801040aa:	8b 73 18             	mov    0x18(%ebx),%esi
801040ad:	b9 13 00 00 00       	mov    $0x13,%ecx
801040b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040b4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040b6:	8b 40 18             	mov    0x18(%eax),%eax
801040b9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801040c0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040c4:	85 c0                	test   %eax,%eax
801040c6:	74 13                	je     801040db <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	50                   	push   %eax
801040cc:	e8 1f cd ff ff       	call   80100df0 <filedup>
801040d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040d4:	83 c4 10             	add    $0x10,%esp
801040d7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801040db:	83 c6 01             	add    $0x1,%esi
801040de:	83 fe 10             	cmp    $0x10,%esi
801040e1:	75 dd                	jne    801040c0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040e9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801040ec:	e8 5f d5 ff ff       	call   80101650 <idup>
801040f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040f4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801040f7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040fa:	8d 47 6c             	lea    0x6c(%edi),%eax
801040fd:	6a 10                	push   $0x10
801040ff:	53                   	push   %ebx
80104100:	50                   	push   %eax
80104101:	e8 4a 11 00 00       	call   80105250 <safestrcpy>
  pid = np->pid;
80104106:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104109:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80104110:	e8 4b 0e 00 00       	call   80104f60 <acquire>
  np->state = RUNNABLE;
80104115:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010411c:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80104123:	e8 f8 0e 00 00       	call   80105020 <release>
  return pid;
80104128:	83 c4 10             	add    $0x10,%esp
}
8010412b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010412e:	89 d8                	mov    %ebx,%eax
80104130:	5b                   	pop    %ebx
80104131:	5e                   	pop    %esi
80104132:	5f                   	pop    %edi
80104133:	5d                   	pop    %ebp
80104134:	c3                   	ret    
    return -1;
80104135:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010413a:	eb ef                	jmp    8010412b <fork+0xdb>
    kfree(np->kstack);
8010413c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010413f:	83 ec 0c             	sub    $0xc,%esp
80104142:	ff 73 08             	pushl  0x8(%ebx)
80104145:	e8 c6 e1 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
8010414a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104151:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104158:	83 c4 10             	add    $0x10,%esp
8010415b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104160:	eb c9                	jmp    8010412b <fork+0xdb>
80104162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104170 <scheduler>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104179:	e8 02 f9 ff ff       	call   80103a80 <mycpu>
  c->proc = 0;
8010417e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104185:	00 00 00 
  struct cpu *c = mycpu();
80104188:	89 c3                	mov    %eax,%ebx
8010418a:	8d 40 04             	lea    0x4(%eax),%eax
8010418d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80104190:	fb                   	sti    
    acquire(&ptable.lock);
80104191:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104194:	bf f4 3f 11 80       	mov    $0x80113ff4,%edi
    acquire(&ptable.lock);
80104199:	68 c0 3f 11 80       	push   $0x80113fc0
8010419e:	e8 bd 0d 00 00       	call   80104f60 <acquire>
801041a3:	83 c4 10             	add    $0x10,%esp
801041a6:	eb 21                	jmp    801041c9 <scheduler+0x59>
801041a8:	90                   	nop
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->state==UNUSED && p->name[0]=='*'){
801041b0:	80 7f 6c 2a          	cmpb   $0x2a,0x6c(%edi)
801041b4:	0f 84 d6 00 00 00    	je     80104290 <scheduler+0x120>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ba:	83 ef 80             	sub    $0xffffff80,%edi
801041bd:	81 ff f4 5f 11 80    	cmp    $0x80115ff4,%edi
801041c3:	0f 83 b1 00 00 00    	jae    8010427a <scheduler+0x10a>
      if(p->state==UNUSED && p->name[0]=='*'){
801041c9:	8b 47 0c             	mov    0xc(%edi),%eax
801041cc:	85 c0                	test   %eax,%eax
801041ce:	74 e0                	je     801041b0 <scheduler+0x40>
      if(p->state != RUNNABLE)
801041d0:	83 f8 03             	cmp    $0x3,%eax
801041d3:	75 e5                	jne    801041ba <scheduler+0x4a>
801041d5:	31 f6                	xor    %esi,%esi
801041d7:	eb 12                	jmp    801041eb <scheduler+0x7b>
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e0:	83 c6 04             	add    $0x4,%esi
      for(int i=0;i<NPDENTRIES;i++){
801041e3:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801041e9:	74 4b                	je     80104236 <scheduler+0xc6>
        if(((p->pgdir)[i])&PTE_P && ((p->pgdir)[i])&PTE_A){
801041eb:	8b 47 04             	mov    0x4(%edi),%eax
801041ee:	8b 0c 30             	mov    (%eax,%esi,1),%ecx
801041f1:	89 c8                	mov    %ecx,%eax
801041f3:	83 e0 21             	and    $0x21,%eax
801041f6:	83 f8 21             	cmp    $0x21,%eax
801041f9:	75 e5                	jne    801041e0 <scheduler+0x70>
          pte_t* pgtab = (pte_t*)P2V(PTE_ADDR((p->pgdir)[i]));
801041fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80104201:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80104207:	81 e9 00 f0 ff 7f    	sub    $0x7ffff000,%ecx
8010420d:	8d 76 00             	lea    0x0(%esi),%esi
            if(pgtab[j]&PTE_A){
80104210:	8b 10                	mov    (%eax),%edx
80104212:	f6 c2 20             	test   $0x20,%dl
80104215:	74 05                	je     8010421c <scheduler+0xac>
              pgtab[j]^=PTE_A;
80104217:	83 f2 20             	xor    $0x20,%edx
8010421a:	89 10                	mov    %edx,(%eax)
8010421c:	83 c0 04             	add    $0x4,%eax
          for(int j=0;j<NPTENTRIES;j++){
8010421f:	39 c1                	cmp    %eax,%ecx
80104221:	75 ed                	jne    80104210 <scheduler+0xa0>
          ((p->pgdir)[i])^=PTE_A;
80104223:	8b 47 04             	mov    0x4(%edi),%eax
80104226:	01 f0                	add    %esi,%eax
80104228:	83 c6 04             	add    $0x4,%esi
8010422b:	83 30 20             	xorl   $0x20,(%eax)
      for(int i=0;i<NPDENTRIES;i++){
8010422e:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80104234:	75 b5                	jne    801041eb <scheduler+0x7b>
      switchuvm(p);
80104236:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104239:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
8010423f:	57                   	push   %edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104240:	83 ef 80             	sub    $0xffffff80,%edi
      switchuvm(p);
80104243:	e8 b8 32 00 00       	call   80107500 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104248:	58                   	pop    %eax
80104249:	5a                   	pop    %edx
8010424a:	ff 77 9c             	pushl  -0x64(%edi)
8010424d:	ff 75 e4             	pushl  -0x1c(%ebp)
      p->state = RUNNING;
80104250:	c7 47 8c 04 00 00 00 	movl   $0x4,-0x74(%edi)
      swtch(&(c->scheduler), p->context);
80104257:	e8 4f 10 00 00       	call   801052ab <swtch>
      switchkvm();
8010425c:	e8 7f 32 00 00       	call   801074e0 <switchkvm>
      c->proc = 0;
80104261:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104264:	81 ff f4 5f 11 80    	cmp    $0x80115ff4,%edi
      c->proc = 0;
8010426a:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104271:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104274:	0f 82 4f ff ff ff    	jb     801041c9 <scheduler+0x59>
    release(&ptable.lock);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 c0 3f 11 80       	push   $0x80113fc0
80104282:	e8 99 0d 00 00       	call   80105020 <release>
    sti();
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	e9 01 ff ff ff       	jmp    80104190 <scheduler+0x20>
8010428f:	90                   	nop
        kfree(p->kstack);
80104290:	83 ec 0c             	sub    $0xc,%esp
80104293:	ff 77 08             	pushl  0x8(%edi)
80104296:	e8 75 e0 ff ff       	call   80102310 <kfree>
        p->pid=0;
8010429b:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->kstack=0;
801042a2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
801042a9:	83 c4 10             	add    $0x10,%esp
        p->name[0]=0;
801042ac:	c6 47 6c 00          	movb   $0x0,0x6c(%edi)
801042b0:	8b 47 0c             	mov    0xc(%edi),%eax
801042b3:	e9 18 ff ff ff       	jmp    801041d0 <scheduler+0x60>
801042b8:	90                   	nop
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <sched>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
  pushcli();
801042c5:	e8 c6 0b 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801042ca:	e8 b1 f7 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
801042cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d5:	e8 f6 0b 00 00       	call   80104ed0 <popcli>
  if(!holding(&ptable.lock))
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 c0 3f 11 80       	push   $0x80113fc0
801042e2:	e8 49 0c 00 00       	call   80104f30 <holding>
801042e7:	83 c4 10             	add    $0x10,%esp
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 4f                	je     8010433d <sched+0x7d>
  if(mycpu()->ncli != 1)
801042ee:	e8 8d f7 ff ff       	call   80103a80 <mycpu>
801042f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042fa:	75 68                	jne    80104364 <sched+0xa4>
  if(p->state == RUNNING)
801042fc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104300:	74 55                	je     80104357 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104302:	9c                   	pushf  
80104303:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104304:	f6 c4 02             	test   $0x2,%ah
80104307:	75 41                	jne    8010434a <sched+0x8a>
  intena = mycpu()->intena;
80104309:	e8 72 f7 ff ff       	call   80103a80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010430e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104311:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104317:	e8 64 f7 ff ff       	call   80103a80 <mycpu>
8010431c:	83 ec 08             	sub    $0x8,%esp
8010431f:	ff 70 04             	pushl  0x4(%eax)
80104322:	53                   	push   %ebx
80104323:	e8 83 0f 00 00       	call   801052ab <swtch>
  mycpu()->intena = intena;
80104328:	e8 53 f7 ff ff       	call   80103a80 <mycpu>
}
8010432d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104330:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104339:	5b                   	pop    %ebx
8010433a:	5e                   	pop    %esi
8010433b:	5d                   	pop    %ebp
8010433c:	c3                   	ret    
    panic("sched ptable.lock");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 2f 82 10 80       	push   $0x8010822f
80104345:	e8 46 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 5b 82 10 80       	push   $0x8010825b
80104352:	e8 39 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 4d 82 10 80       	push   $0x8010824d
8010435f:	e8 2c c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	68 41 82 10 80       	push   $0x80108241
8010436c:	e8 1f c0 ff ff       	call   80100390 <panic>
80104371:	eb 0d                	jmp    80104380 <swap_out_process_function>
80104373:	90                   	nop
80104374:	90                   	nop
80104375:	90                   	nop
80104376:	90                   	nop
80104377:	90                   	nop
80104378:	90                   	nop
80104379:	90                   	nop
8010437a:	90                   	nop
8010437b:	90                   	nop
8010437c:	90                   	nop
8010437d:	90                   	nop
8010437e:	90                   	nop
8010437f:	90                   	nop

80104380 <swap_out_process_function>:
void swap_out_process_function(){
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	83 ec 68             	sub    $0x68,%esp
  acquire(&rqueue.lock);
80104389:	68 40 3d 11 80       	push   $0x80113d40
8010438e:	e8 cd 0b 00 00       	call   80104f60 <acquire>
  while(rqueue.s!=rqueue.e){
80104393:	83 c4 10             	add    $0x10,%esp
80104396:	a1 78 3e 11 80       	mov    0x80113e78,%eax
8010439b:	39 05 74 3e 11 80    	cmp    %eax,0x80113e74
801043a1:	74 75                	je     80104418 <swap_out_process_function+0x98>
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct proc *p=rpop();
801043a8:	e8 a3 f4 ff ff       	call   80103850 <rpop>
801043ad:	89 45 9c             	mov    %eax,-0x64(%ebp)
    pde_t* pd = p->pgdir;
801043b0:	8b 40 04             	mov    0x4(%eax),%eax
    for(int i=0;i<NPDENTRIES;i++){
801043b3:	31 f6                	xor    %esi,%esi
    pde_t* pd = p->pgdir;
801043b5:	89 45 a0             	mov    %eax,-0x60(%ebp)
801043b8:	90                   	nop
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pd[i]&PTE_A)continue;
801043c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
801043c3:	8b 1c b0             	mov    (%eax,%esi,4),%ebx
801043c6:	f6 c3 20             	test   $0x20,%bl
801043c9:	75 35                	jne    80104400 <swap_out_process_function+0x80>
      pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(pd[i]));
801043cb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
      for(int j=0;j<NPTENTRIES;j++){
801043d1:	31 d2                	xor    %edx,%edx
      pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(pd[i]));
801043d3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
        if((pgtab[j]&PTE_A) || !(pgtab[j]&PTE_P))continue;
801043d9:	8b 03                	mov    (%ebx),%eax
801043db:	89 c1                	mov    %eax,%ecx
801043dd:	83 e1 21             	and    $0x21,%ecx
801043e0:	83 f9 01             	cmp    $0x1,%ecx
801043e3:	0f 84 8f 00 00 00    	je     80104478 <swap_out_process_function+0xf8>
      for(int j=0;j<NPTENTRIES;j++){
801043e9:	83 c2 01             	add    $0x1,%edx
801043ec:	83 c3 04             	add    $0x4,%ebx
801043ef:	81 fa 00 04 00 00    	cmp    $0x400,%edx
801043f5:	75 e2                	jne    801043d9 <swap_out_process_function+0x59>
801043f7:	89 f6                	mov    %esi,%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(int i=0;i<NPDENTRIES;i++){
80104400:	83 c6 01             	add    $0x1,%esi
80104403:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80104409:	75 b5                	jne    801043c0 <swap_out_process_function+0x40>
  while(rqueue.s!=rqueue.e){
8010440b:	a1 78 3e 11 80       	mov    0x80113e78,%eax
80104410:	39 05 74 3e 11 80    	cmp    %eax,0x80113e74
80104416:	75 90                	jne    801043a8 <swap_out_process_function+0x28>
  release(&rqueue.lock);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 40 3d 11 80       	push   $0x80113d40
80104420:	e8 fb 0b 00 00       	call   80105020 <release>
  pushcli();
80104425:	e8 66 0a 00 00       	call   80104e90 <pushcli>
  c = mycpu();
8010442a:	e8 51 f6 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
8010442f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104435:	e8 96 0a 00 00       	call   80104ed0 <popcli>
  if((p=myproc())==0) panic("swap out process");
8010443a:	83 c4 10             	add    $0x10,%esp
8010443d:	85 db                	test   %ebx,%ebx
8010443f:	0f 84 71 01 00 00    	je     801045b6 <swap_out_process_function+0x236>
  p->killed = 0;
80104445:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  p->state = UNUSED;
8010444c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  p->parent = 0;
80104453:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  p->name[0] = '*';
8010445a:	c6 43 6c 2a          	movb   $0x2a,0x6c(%ebx)
  swap_out_process_exists=0;
8010445e:	c7 05 b8 b5 10 80 00 	movl   $0x0,0x8010b5b8
80104465:	00 00 00 
  sched();
80104468:	e8 53 fe ff ff       	call   801042c0 <sched>
}
8010446d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104470:	5b                   	pop    %ebx
80104471:	5e                   	pop    %esi
80104472:	5f                   	pop    %edi
80104473:	5d                   	pop    %ebp
80104474:	c3                   	ret    
80104475:	8d 76 00             	lea    0x0(%esi),%esi
        pte_t *pte=(pte_t*)P2V(PTE_ADDR(pgtab[j]));
80104478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        int virt = ((1<<22)*i)+((1<<12)*j);
8010447d:	89 f7                	mov    %esi,%edi
        pte_t *pte=(pte_t*)P2V(PTE_ADDR(pgtab[j]));
8010447f:	05 00 00 00 80       	add    $0x80000000,%eax
        int virt = ((1<<22)*i)+((1<<12)*j);
80104484:	c1 e7 0a             	shl    $0xa,%edi
        pte_t *pte=(pte_t*)P2V(PTE_ADDR(pgtab[j]));
80104487:	89 45 a4             	mov    %eax,-0x5c(%ebp)
        int pid=p->pid;
8010448a:	8b 45 9c             	mov    -0x64(%ebp),%eax
        int virt = ((1<<22)*i)+((1<<12)*j);
8010448d:	01 d7                	add    %edx,%edi
8010448f:	c1 e7 0c             	shl    $0xc,%edi
        int pid=p->pid;
80104492:	8b 40 10             	mov    0x10(%eax),%eax
  if(x==0){
80104495:	85 c0                	test   %eax,%eax
80104497:	0f 85 c3 00 00 00    	jne    80104560 <swap_out_process_function+0x1e0>
    c[0]='0';
8010449d:	b8 30 00 00 00       	mov    $0x30,%eax
801044a2:	66 89 45 b6          	mov    %ax,-0x4a(%ebp)
        int x=strlen(c);
801044a6:	8d 45 b6             	lea    -0x4a(%ebp),%eax
801044a9:	83 ec 0c             	sub    $0xc,%esp
801044ac:	50                   	push   %eax
801044ad:	e8 de 0d 00 00       	call   80105290 <strlen>
  if(x==0){
801044b2:	83 c4 10             	add    $0x10,%esp
801044b5:	85 ff                	test   %edi,%edi
        c[x]='_';
801044b7:	c6 44 05 b6 5f       	movb   $0x5f,-0x4a(%ebp,%eax,1)
        int_to_string(virt,c+x+1);
801044bc:	8d 54 05 b7          	lea    -0x49(%ebp,%eax,1),%edx
  if(x==0){
801044c0:	0f 85 aa 00 00 00    	jne    80104570 <swap_out_process_function+0x1f0>
    c[0]='0';
801044c6:	bf 30 00 00 00       	mov    $0x30,%edi
801044cb:	66 89 3a             	mov    %di,(%edx)
        safestrcpy(c+strlen(c),".swp",5);
801044ce:	8d 45 b6             	lea    -0x4a(%ebp),%eax
801044d1:	83 ec 0c             	sub    $0xc,%esp
801044d4:	50                   	push   %eax
801044d5:	e8 b6 0d 00 00       	call   80105290 <strlen>
801044da:	8d 4d b6             	lea    -0x4a(%ebp),%ecx
801044dd:	83 c4 0c             	add    $0xc,%esp
801044e0:	6a 05                	push   $0x5
801044e2:	68 6f 82 10 80       	push   $0x8010826f
801044e7:	01 c8                	add    %ecx,%eax
801044e9:	50                   	push   %eax
801044ea:	e8 61 0d 00 00       	call   80105250 <safestrcpy>
        int fd=proc_open(c, O_CREATE | O_RDWR);
801044ef:	5a                   	pop    %edx
801044f0:	8d 45 b6             	lea    -0x4a(%ebp),%eax
801044f3:	59                   	pop    %ecx
801044f4:	68 02 02 00 00       	push   $0x202
801044f9:	50                   	push   %eax
801044fa:	e8 51 f7 ff ff       	call   80103c50 <proc_open>
        if(fd<0){
801044ff:	83 c4 10             	add    $0x10,%esp
80104502:	85 c0                	test   %eax,%eax
        int fd=proc_open(c, O_CREATE | O_RDWR);
80104504:	89 c7                	mov    %eax,%edi
        if(fd<0){
80104506:	78 74                	js     8010457c <swap_out_process_function+0x1fc>
        if(proc_write(fd,(char *)pte, PGSIZE) != PGSIZE){
80104508:	83 ec 04             	sub    $0x4,%esp
8010450b:	68 00 10 00 00       	push   $0x1000
80104510:	ff 75 a4             	pushl  -0x5c(%ebp)
80104513:	50                   	push   %eax
80104514:	e8 07 f6 ff ff       	call   80103b20 <proc_write>
80104519:	83 c4 10             	add    $0x10,%esp
8010451c:	3d 00 10 00 00       	cmp    $0x1000,%eax
80104521:	75 76                	jne    80104599 <swap_out_process_function+0x219>
        proc_close(fd);
80104523:	83 ec 0c             	sub    $0xc,%esp
    for(int i=0;i<NPDENTRIES;i++){
80104526:	83 c6 01             	add    $0x1,%esi
        proc_close(fd);
80104529:	57                   	push   %edi
8010452a:	e8 51 f6 ff ff       	call   80103b80 <proc_close>
        kfree((char*)pte);
8010452f:	58                   	pop    %eax
80104530:	ff 75 a4             	pushl  -0x5c(%ebp)
80104533:	e8 d8 dd ff ff       	call   80102310 <kfree>
        memset(&pgtab[j],0,sizeof(pgtab[j]));
80104538:	83 c4 0c             	add    $0xc,%esp
8010453b:	6a 04                	push   $0x4
8010453d:	6a 00                	push   $0x0
8010453f:	53                   	push   %ebx
80104540:	e8 2b 0b 00 00       	call   80105070 <memset>
        pgtab[j]=((pgtab[j])^(0x080));
80104545:	81 33 80 00 00 00    	xorl   $0x80,(%ebx)
        break;
8010454b:	83 c4 10             	add    $0x10,%esp
    for(int i=0;i<NPDENTRIES;i++){
8010454e:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80104554:	0f 85 66 fe ff ff    	jne    801043c0 <swap_out_process_function+0x40>
8010455a:	e9 ac fe ff ff       	jmp    8010440b <swap_out_process_function+0x8b>
8010455f:	90                   	nop
80104560:	8d 55 b6             	lea    -0x4a(%ebp),%edx
80104563:	e8 38 f2 ff ff       	call   801037a0 <int_to_string.part.1>
80104568:	e9 39 ff ff ff       	jmp    801044a6 <swap_out_process_function+0x126>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	89 f8                	mov    %edi,%eax
80104572:	e8 29 f2 ff ff       	call   801037a0 <int_to_string.part.1>
80104577:	e9 52 ff ff ff       	jmp    801044ce <swap_out_process_function+0x14e>
          cprintf("error creating or opening file: %s\n", c);
8010457c:	8d 45 b6             	lea    -0x4a(%ebp),%eax
8010457f:	83 ec 08             	sub    $0x8,%esp
80104582:	50                   	push   %eax
80104583:	68 88 83 10 80       	push   $0x80108388
80104588:	e8 d3 c0 ff ff       	call   80100660 <cprintf>
          panic("swap_out_process");
8010458d:	c7 04 24 74 82 10 80 	movl   $0x80108274,(%esp)
80104594:	e8 f7 bd ff ff       	call   80100390 <panic>
          cprintf("error writing to file: %s\n", c);
80104599:	8d 45 b6             	lea    -0x4a(%ebp),%eax
8010459c:	83 ec 08             	sub    $0x8,%esp
8010459f:	50                   	push   %eax
801045a0:	68 85 82 10 80       	push   $0x80108285
801045a5:	e8 b6 c0 ff ff       	call   80100660 <cprintf>
          panic("swap_out_process");
801045aa:	c7 04 24 74 82 10 80 	movl   $0x80108274,(%esp)
801045b1:	e8 da bd ff ff       	call   80100390 <panic>
  if((p=myproc())==0) panic("swap out process");
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	68 a0 82 10 80       	push   $0x801082a0
801045be:	e8 cd bd ff ff       	call   80100390 <panic>
801045c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <exit>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045d9:	e8 b2 08 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801045de:	e8 9d f4 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
801045e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045e9:	e8 e2 08 00 00       	call   80104ed0 <popcli>
  if(curproc == initproc)
801045ee:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
801045f4:	8d 5e 28             	lea    0x28(%esi),%ebx
801045f7:	8d 7e 68             	lea    0x68(%esi),%edi
801045fa:	0f 84 e7 00 00 00    	je     801046e7 <exit+0x117>
    if(curproc->ofile[fd]){
80104600:	8b 03                	mov    (%ebx),%eax
80104602:	85 c0                	test   %eax,%eax
80104604:	74 12                	je     80104618 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104606:	83 ec 0c             	sub    $0xc,%esp
80104609:	50                   	push   %eax
8010460a:	e8 31 c8 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010460f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104615:	83 c4 10             	add    $0x10,%esp
80104618:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010461b:	39 fb                	cmp    %edi,%ebx
8010461d:	75 e1                	jne    80104600 <exit+0x30>
  begin_op();
8010461f:	e8 fc e5 ff ff       	call   80102c20 <begin_op>
  iput(curproc->cwd);
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	ff 76 68             	pushl  0x68(%esi)
8010462a:	e8 81 d1 ff ff       	call   801017b0 <iput>
  end_op();
8010462f:	e8 5c e6 ff ff       	call   80102c90 <end_op>
  curproc->cwd = 0;
80104634:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010463b:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80104642:	e8 19 09 00 00       	call   80104f60 <acquire>
  wakeup1(curproc->parent);
80104647:	8b 56 14             	mov    0x14(%esi),%edx
8010464a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464d:	b8 f4 3f 11 80       	mov    $0x80113ff4,%eax
80104652:	eb 0e                	jmp    80104662 <exit+0x92>
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104658:	83 e8 80             	sub    $0xffffff80,%eax
8010465b:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
80104660:	73 1c                	jae    8010467e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104662:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104666:	75 f0                	jne    80104658 <exit+0x88>
80104668:	3b 50 20             	cmp    0x20(%eax),%edx
8010466b:	75 eb                	jne    80104658 <exit+0x88>
      p->state = RUNNABLE;
8010466d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104674:	83 e8 80             	sub    $0xffffff80,%eax
80104677:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
8010467c:	72 e4                	jb     80104662 <exit+0x92>
      p->parent = initproc;
8010467e:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104684:	ba f4 3f 11 80       	mov    $0x80113ff4,%edx
80104689:	eb 10                	jmp    8010469b <exit+0xcb>
8010468b:	90                   	nop
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104690:	83 ea 80             	sub    $0xffffff80,%edx
80104693:	81 fa f4 5f 11 80    	cmp    $0x80115ff4,%edx
80104699:	73 33                	jae    801046ce <exit+0xfe>
    if(p->parent == curproc){
8010469b:	39 72 14             	cmp    %esi,0x14(%edx)
8010469e:	75 f0                	jne    80104690 <exit+0xc0>
      if(p->state == ZOMBIE)
801046a0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046a4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046a7:	75 e7                	jne    80104690 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a9:	b8 f4 3f 11 80       	mov    $0x80113ff4,%eax
801046ae:	eb 0a                	jmp    801046ba <exit+0xea>
801046b0:	83 e8 80             	sub    $0xffffff80,%eax
801046b3:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
801046b8:	73 d6                	jae    80104690 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801046ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046be:	75 f0                	jne    801046b0 <exit+0xe0>
801046c0:	3b 48 20             	cmp    0x20(%eax),%ecx
801046c3:	75 eb                	jne    801046b0 <exit+0xe0>
      p->state = RUNNABLE;
801046c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046cc:	eb e2                	jmp    801046b0 <exit+0xe0>
  curproc->state = ZOMBIE;
801046ce:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801046d5:	e8 e6 fb ff ff       	call   801042c0 <sched>
  panic("zombie exit");
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 be 82 10 80       	push   $0x801082be
801046e2:	e8 a9 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
801046e7:	83 ec 0c             	sub    $0xc,%esp
801046ea:	68 b1 82 10 80       	push   $0x801082b1
801046ef:	e8 9c bc ff ff       	call   80100390 <panic>
801046f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104700 <yield>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104707:	68 c0 3f 11 80       	push   $0x80113fc0
8010470c:	e8 4f 08 00 00       	call   80104f60 <acquire>
  pushcli();
80104711:	e8 7a 07 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80104716:	e8 65 f3 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
8010471b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104721:	e8 aa 07 00 00       	call   80104ed0 <popcli>
  myproc()->state = RUNNABLE;
80104726:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010472d:	e8 8e fb ff ff       	call   801042c0 <sched>
  release(&ptable.lock);
80104732:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80104739:	e8 e2 08 00 00       	call   80105020 <release>
}
8010473e:	83 c4 10             	add    $0x10,%esp
80104741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104744:	c9                   	leave  
80104745:	c3                   	ret    
80104746:	8d 76 00             	lea    0x0(%esi),%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <sleep>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	8b 7d 08             	mov    0x8(%ebp),%edi
8010475c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010475f:	e8 2c 07 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80104764:	e8 17 f3 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80104769:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010476f:	e8 5c 07 00 00       	call   80104ed0 <popcli>
  if(p == 0)
80104774:	85 db                	test   %ebx,%ebx
80104776:	0f 84 87 00 00 00    	je     80104803 <sleep+0xb3>
  if(lk == 0)
8010477c:	85 f6                	test   %esi,%esi
8010477e:	74 76                	je     801047f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104780:	81 fe c0 3f 11 80    	cmp    $0x80113fc0,%esi
80104786:	74 50                	je     801047d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 c0 3f 11 80       	push   $0x80113fc0
80104790:	e8 cb 07 00 00       	call   80104f60 <acquire>
    release(lk);
80104795:	89 34 24             	mov    %esi,(%esp)
80104798:	e8 83 08 00 00       	call   80105020 <release>
  p->chan = chan;
8010479d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047a7:	e8 14 fb ff ff       	call   801042c0 <sched>
  p->chan = 0;
801047ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801047b3:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
801047ba:	e8 61 08 00 00       	call   80105020 <release>
    acquire(lk);
801047bf:	89 75 08             	mov    %esi,0x8(%ebp)
801047c2:	83 c4 10             	add    $0x10,%esp
}
801047c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c8:	5b                   	pop    %ebx
801047c9:	5e                   	pop    %esi
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
    acquire(lk);
801047cc:	e9 8f 07 00 00       	jmp    80104f60 <acquire>
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801047d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047e2:	e8 d9 fa ff ff       	call   801042c0 <sched>
  p->chan = 0;
801047e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f1:	5b                   	pop    %ebx
801047f2:	5e                   	pop    %esi
801047f3:	5f                   	pop    %edi
801047f4:	5d                   	pop    %ebp
801047f5:	c3                   	ret    
    panic("sleep without lk");
801047f6:	83 ec 0c             	sub    $0xc,%esp
801047f9:	68 d0 82 10 80       	push   $0x801082d0
801047fe:	e8 8d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104803:	83 ec 0c             	sub    $0xc,%esp
80104806:	68 ca 82 10 80       	push   $0x801082ca
8010480b:	e8 80 bb ff ff       	call   80100390 <panic>

80104810 <wait>:
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
  pushcli();
80104815:	e8 76 06 00 00       	call   80104e90 <pushcli>
  c = mycpu();
8010481a:	e8 61 f2 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
8010481f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104825:	e8 a6 06 00 00       	call   80104ed0 <popcli>
  acquire(&ptable.lock);
8010482a:	83 ec 0c             	sub    $0xc,%esp
8010482d:	68 c0 3f 11 80       	push   $0x80113fc0
80104832:	e8 29 07 00 00       	call   80104f60 <acquire>
80104837:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010483a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010483c:	bb f4 3f 11 80       	mov    $0x80113ff4,%ebx
80104841:	eb 10                	jmp    80104853 <wait+0x43>
80104843:	90                   	nop
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104848:	83 eb 80             	sub    $0xffffff80,%ebx
8010484b:	81 fb f4 5f 11 80    	cmp    $0x80115ff4,%ebx
80104851:	73 1b                	jae    8010486e <wait+0x5e>
      if(p->parent != curproc)
80104853:	39 73 14             	cmp    %esi,0x14(%ebx)
80104856:	75 f0                	jne    80104848 <wait+0x38>
      if(p->state == ZOMBIE){
80104858:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010485c:	74 32                	je     80104890 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010485e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104861:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104866:	81 fb f4 5f 11 80    	cmp    $0x80115ff4,%ebx
8010486c:	72 e5                	jb     80104853 <wait+0x43>
    if(!havekids || curproc->killed){
8010486e:	85 c0                	test   %eax,%eax
80104870:	74 74                	je     801048e6 <wait+0xd6>
80104872:	8b 46 24             	mov    0x24(%esi),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	75 6d                	jne    801048e6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104879:	83 ec 08             	sub    $0x8,%esp
8010487c:	68 c0 3f 11 80       	push   $0x80113fc0
80104881:	56                   	push   %esi
80104882:	e8 c9 fe ff ff       	call   80104750 <sleep>
    havekids = 0;
80104887:	83 c4 10             	add    $0x10,%esp
8010488a:	eb ae                	jmp    8010483a <wait+0x2a>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104896:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104899:	e8 72 da ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
8010489e:	5a                   	pop    %edx
8010489f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801048a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801048a9:	e8 72 30 00 00       	call   80107920 <freevm>
        release(&ptable.lock);
801048ae:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
        p->pid = 0;
801048b5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048bc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048c3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048c7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048ce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048d5:	e8 46 07 00 00       	call   80105020 <release>
        return pid;
801048da:	83 c4 10             	add    $0x10,%esp
}
801048dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e0:	89 f0                	mov    %esi,%eax
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
      release(&ptable.lock);
801048e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048ee:	68 c0 3f 11 80       	push   $0x80113fc0
801048f3:	e8 28 07 00 00       	call   80105020 <release>
      return -1;
801048f8:	83 c4 10             	add    $0x10,%esp
801048fb:	eb e0                	jmp    801048dd <wait+0xcd>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 10             	sub    $0x10,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010490a:	68 c0 3f 11 80       	push   $0x80113fc0
8010490f:	e8 4c 06 00 00       	call   80104f60 <acquire>
80104914:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104917:	b8 f4 3f 11 80       	mov    $0x80113ff4,%eax
8010491c:	eb 0c                	jmp    8010492a <wakeup+0x2a>
8010491e:	66 90                	xchg   %ax,%ax
80104920:	83 e8 80             	sub    $0xffffff80,%eax
80104923:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
80104928:	73 1c                	jae    80104946 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010492a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010492e:	75 f0                	jne    80104920 <wakeup+0x20>
80104930:	3b 58 20             	cmp    0x20(%eax),%ebx
80104933:	75 eb                	jne    80104920 <wakeup+0x20>
      p->state = RUNNABLE;
80104935:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010493c:	83 e8 80             	sub    $0xffffff80,%eax
8010493f:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
80104944:	72 e4                	jb     8010492a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104946:	c7 45 08 c0 3f 11 80 	movl   $0x80113fc0,0x8(%ebp)
}
8010494d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104950:	c9                   	leave  
  release(&ptable.lock);
80104951:	e9 ca 06 00 00       	jmp    80105020 <release>
80104956:	8d 76 00             	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104960 <swap_in_process_function>:
void swap_in_process_function(){
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	83 ec 68             	sub    $0x68,%esp
	acquire(&rqueue2.lock);
80104969:	68 80 3e 11 80       	push   $0x80113e80
8010496e:	e8 ed 05 00 00       	call   80104f60 <acquire>
	while(rqueue2.s!=rqueue2.e){
80104973:	83 c4 10             	add    $0x10,%esp
80104976:	a1 b4 3f 11 80       	mov    0x80113fb4,%eax
8010497b:	39 05 b8 3f 11 80    	cmp    %eax,0x80113fb8
80104981:	0f 84 01 01 00 00    	je     80104a88 <swap_in_process_function+0x128>
80104987:	8d 5d b6             	lea    -0x4a(%ebp),%ebx
8010498a:	e9 bf 00 00 00       	jmp    80104a4e <swap_in_process_function+0xee>
8010498f:	90                   	nop
    c[0]='0';
80104990:	b8 30 00 00 00       	mov    $0x30,%eax
80104995:	66 89 45 b6          	mov    %ax,-0x4a(%ebp)
	    	int x=strlen(c);
80104999:	83 ec 0c             	sub    $0xc,%esp
8010499c:	53                   	push   %ebx
8010499d:	e8 ee 08 00 00       	call   80105290 <strlen>
  if(x==0){
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	85 f6                	test   %esi,%esi
	    	c[x]='_';
801049a7:	c6 44 05 b6 5f       	movb   $0x5f,-0x4a(%ebp,%eax,1)
	    	int_to_string(virt,c+x+1);
801049ac:	8d 54 03 01          	lea    0x1(%ebx,%eax,1),%edx
  if(x==0){
801049b0:	0f 85 c2 00 00 00    	jne    80104a78 <swap_in_process_function+0x118>
    c[0]='0';
801049b6:	b8 30 00 00 00       	mov    $0x30,%eax
801049bb:	66 89 02             	mov    %ax,(%edx)
	    	safestrcpy(c+strlen(c),".swp",5);
801049be:	83 ec 0c             	sub    $0xc,%esp
801049c1:	53                   	push   %ebx
801049c2:	e8 c9 08 00 00       	call   80105290 <strlen>
801049c7:	83 c4 0c             	add    $0xc,%esp
801049ca:	01 d8                	add    %ebx,%eax
801049cc:	6a 05                	push   $0x5
801049ce:	68 6f 82 10 80       	push   $0x8010826f
801049d3:	50                   	push   %eax
801049d4:	e8 77 08 00 00       	call   80105250 <safestrcpy>
	    	int fd=proc_open(c,O_RDONLY);
801049d9:	59                   	pop    %ecx
801049da:	58                   	pop    %eax
801049db:	6a 00                	push   $0x0
801049dd:	53                   	push   %ebx
801049de:	e8 6d f2 ff ff       	call   80103c50 <proc_open>
	    	if(fd<0){
801049e3:	83 c4 10             	add    $0x10,%esp
801049e6:	85 c0                	test   %eax,%eax
801049e8:	0f 88 f3 00 00 00    	js     80104ae1 <swap_in_process_function+0x181>
801049ee:	89 45 a0             	mov    %eax,-0x60(%ebp)
	    	char *mem=kalloc();
801049f1:	e8 4a db ff ff       	call   80102540 <kalloc>
	    	proc_read(fd,PGSIZE,mem);
801049f6:	8b 4d a0             	mov    -0x60(%ebp),%ecx
801049f9:	83 ec 04             	sub    $0x4,%esp
801049fc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
801049ff:	50                   	push   %eax
80104a00:	68 00 10 00 00       	push   $0x1000
80104a05:	51                   	push   %ecx
80104a06:	e8 e5 f1 ff ff       	call   80103bf0 <proc_read>
	    	if(mappages(p->pgdir, (void *)virt, PGSIZE, V2P(mem), PTE_W|PTE_U)<0){
80104a0b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80104a0e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80104a15:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80104a1b:	52                   	push   %edx
80104a1c:	68 00 10 00 00       	push   $0x1000
80104a21:	56                   	push   %esi
80104a22:	ff 77 04             	pushl  0x4(%edi)
80104a25:	e8 26 2a 00 00       	call   80107450 <mappages>
80104a2a:	83 c4 20             	add    $0x20,%esp
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	0f 88 d2 00 00 00    	js     80104b07 <swap_in_process_function+0x1a7>
	    	wakeup(p);
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	57                   	push   %edi
80104a39:	e8 c2 fe ff ff       	call   80104900 <wakeup>
	while(rqueue2.s!=rqueue2.e){
80104a3e:	83 c4 10             	add    $0x10,%esp
80104a41:	a1 b8 3f 11 80       	mov    0x80113fb8,%eax
80104a46:	39 05 b4 3f 11 80    	cmp    %eax,0x80113fb4
80104a4c:	74 3a                	je     80104a88 <swap_in_process_function+0x128>
		struct proc *p=rpop2();
80104a4e:	e8 7d ee ff ff       	call   801038d0 <rpop2>
80104a53:	89 c7                	mov    %eax,%edi
		int pid=p->pid;
80104a55:	8b 40 10             	mov    0x10(%eax),%eax
		int virt=PTE_ADDR(p->addr);
80104a58:	8b 77 7c             	mov    0x7c(%edi),%esi
80104a5b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if(x==0){
80104a61:	85 c0                	test   %eax,%eax
80104a63:	0f 84 27 ff ff ff    	je     80104990 <swap_in_process_function+0x30>
80104a69:	89 da                	mov    %ebx,%edx
80104a6b:	e8 30 ed ff ff       	call   801037a0 <int_to_string.part.1>
80104a70:	e9 24 ff ff ff       	jmp    80104999 <swap_in_process_function+0x39>
80104a75:	8d 76 00             	lea    0x0(%esi),%esi
80104a78:	89 f0                	mov    %esi,%eax
80104a7a:	e8 21 ed ff ff       	call   801037a0 <int_to_string.part.1>
80104a7f:	e9 3a ff ff ff       	jmp    801049be <swap_in_process_function+0x5e>
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&rqueue2.lock);
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	68 80 3e 11 80       	push   $0x80113e80
80104a90:	e8 8b 05 00 00       	call   80105020 <release>
  pushcli();
80104a95:	e8 f6 03 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80104a9a:	e8 e1 ef ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80104a9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aa5:	e8 26 04 00 00       	call   80104ed0 <popcli>
	if((p=myproc())==0)panic("swap_in_process");
80104aaa:	83 c4 10             	add    $0x10,%esp
80104aad:	85 db                	test   %ebx,%ebx
80104aaf:	74 6f                	je     80104b20 <swap_in_process_function+0x1c0>
	p->killed = 0;
80104ab1:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->state = UNUSED;
80104ab8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	p->parent = 0;
80104abf:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	p->name[0] = '*';
80104ac6:	c6 43 6c 2a          	movb   $0x2a,0x6c(%ebx)
	swap_in_process_exists=0;
80104aca:	c7 05 bc b5 10 80 00 	movl   $0x0,0x8010b5bc
80104ad1:	00 00 00 
	sched();
80104ad4:	e8 e7 f7 ff ff       	call   801042c0 <sched>
}
80104ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104adc:	5b                   	pop    %ebx
80104add:	5e                   	pop    %esi
80104ade:	5f                   	pop    %edi
80104adf:	5d                   	pop    %ebp
80104ae0:	c3                   	ret    
	    		release(&rqueue2.lock);
80104ae1:	83 ec 0c             	sub    $0xc,%esp
80104ae4:	68 80 3e 11 80       	push   $0x80113e80
80104ae9:	e8 32 05 00 00       	call   80105020 <release>
	    		cprintf("could not find page file in memory: %s\n", c);
80104aee:	58                   	pop    %eax
80104aef:	5a                   	pop    %edx
80104af0:	53                   	push   %ebx
80104af1:	68 ac 83 10 80       	push   $0x801083ac
80104af6:	e8 65 bb ff ff       	call   80100660 <cprintf>
	    		panic("swap_in_process");
80104afb:	c7 04 24 e1 82 10 80 	movl   $0x801082e1,(%esp)
80104b02:	e8 89 b8 ff ff       	call   80100390 <panic>
	    		release(&rqueue2.lock);
80104b07:	83 ec 0c             	sub    $0xc,%esp
80104b0a:	68 80 3e 11 80       	push   $0x80113e80
80104b0f:	e8 0c 05 00 00       	call   80105020 <release>
	    		panic("mappages");
80104b14:	c7 04 24 f1 82 10 80 	movl   $0x801082f1,(%esp)
80104b1b:	e8 70 b8 ff ff       	call   80100390 <panic>
	if((p=myproc())==0)panic("swap_in_process");
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	68 e1 82 10 80       	push   $0x801082e1
80104b28:	e8 63 b8 ff ff       	call   80100390 <panic>
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi

80104b30 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 10             	sub    $0x10,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b3a:	68 c0 3f 11 80       	push   $0x80113fc0
80104b3f:	e8 1c 04 00 00       	call   80104f60 <acquire>
80104b44:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b47:	b8 f4 3f 11 80       	mov    $0x80113ff4,%eax
80104b4c:	eb 0c                	jmp    80104b5a <kill+0x2a>
80104b4e:	66 90                	xchg   %ax,%ax
80104b50:	83 e8 80             	sub    $0xffffff80,%eax
80104b53:	3d f4 5f 11 80       	cmp    $0x80115ff4,%eax
80104b58:	73 36                	jae    80104b90 <kill+0x60>
    if(p->pid == pid){
80104b5a:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b5d:	75 f1                	jne    80104b50 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b5f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b63:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b6a:	75 07                	jne    80104b73 <kill+0x43>
        p->state = RUNNABLE;
80104b6c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b73:	83 ec 0c             	sub    $0xc,%esp
80104b76:	68 c0 3f 11 80       	push   $0x80113fc0
80104b7b:	e8 a0 04 00 00       	call   80105020 <release>
      return 0;
80104b80:	83 c4 10             	add    $0x10,%esp
80104b83:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b88:	c9                   	leave  
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 c0 3f 11 80       	push   $0x80113fc0
80104b98:	e8 83 04 00 00       	call   80105020 <release>
  return -1;
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba8:	c9                   	leave  
80104ba9:	c3                   	ret    
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bb0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb9:	bb f4 3f 11 80       	mov    $0x80113ff4,%ebx
{
80104bbe:	83 ec 3c             	sub    $0x3c,%esp
80104bc1:	eb 24                	jmp    80104be7 <procdump+0x37>
80104bc3:	90                   	nop
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	68 bb 87 10 80       	push   $0x801087bb
80104bd0:	e8 8b ba ff ff       	call   80100660 <cprintf>
80104bd5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd8:	83 eb 80             	sub    $0xffffff80,%ebx
80104bdb:	81 fb f4 5f 11 80    	cmp    $0x80115ff4,%ebx
80104be1:	0f 83 81 00 00 00    	jae    80104c68 <procdump+0xb8>
    if(p->state == UNUSED)
80104be7:	8b 43 0c             	mov    0xc(%ebx),%eax
80104bea:	85 c0                	test   %eax,%eax
80104bec:	74 ea                	je     80104bd8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bee:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104bf1:	ba fa 82 10 80       	mov    $0x801082fa,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bf6:	77 11                	ja     80104c09 <procdump+0x59>
80104bf8:	8b 14 85 d4 83 10 80 	mov    -0x7fef7c2c(,%eax,4),%edx
      state = "???";
80104bff:	b8 fa 82 10 80       	mov    $0x801082fa,%eax
80104c04:	85 d2                	test   %edx,%edx
80104c06:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c09:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104c0c:	50                   	push   %eax
80104c0d:	52                   	push   %edx
80104c0e:	ff 73 10             	pushl  0x10(%ebx)
80104c11:	68 fe 82 10 80       	push   $0x801082fe
80104c16:	e8 45 ba ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104c1b:	83 c4 10             	add    $0x10,%esp
80104c1e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104c22:	75 a4                	jne    80104bc8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c24:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c27:	83 ec 08             	sub    $0x8,%esp
80104c2a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c2d:	50                   	push   %eax
80104c2e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c31:	8b 40 0c             	mov    0xc(%eax),%eax
80104c34:	83 c0 08             	add    $0x8,%eax
80104c37:	50                   	push   %eax
80104c38:	e8 03 02 00 00       	call   80104e40 <getcallerpcs>
80104c3d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104c40:	8b 17                	mov    (%edi),%edx
80104c42:	85 d2                	test   %edx,%edx
80104c44:	74 82                	je     80104bc8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104c46:	83 ec 08             	sub    $0x8,%esp
80104c49:	83 c7 04             	add    $0x4,%edi
80104c4c:	52                   	push   %edx
80104c4d:	68 a1 7c 10 80       	push   $0x80107ca1
80104c52:	e8 09 ba ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c57:	83 c4 10             	add    $0x10,%esp
80104c5a:	39 fe                	cmp    %edi,%esi
80104c5c:	75 e2                	jne    80104c40 <procdump+0x90>
80104c5e:	e9 65 ff ff ff       	jmp    80104bc8 <procdump+0x18>
80104c63:	90                   	nop
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c6b:	5b                   	pop    %ebx
80104c6c:	5e                   	pop    %esi
80104c6d:	5f                   	pop    %edi
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret    

80104c70 <create_kernel_process>:

void create_kernel_process(const char *name, void (*entrypoint)()){
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	83 ec 0c             	sub    $0xc,%esp
80104c79:	8b 75 08             	mov    0x8(%ebp),%esi
80104c7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    
  struct proc *p = allocproc();
80104c7f:	e8 fc e9 ff ff       	call   80103680 <allocproc>
  if(p == 0) panic("create_kernel_process failed");
80104c84:	85 c0                	test   %eax,%eax
80104c86:	74 4c                	je     80104cd4 <create_kernel_process+0x64>
80104c88:	89 c3                	mov    %eax,%ebx
  if((p->pgdir = setupkvm()) == 0) panic("setupkvm failed");
80104c8a:	e8 11 2d 00 00       	call   801079a0 <setupkvm>
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	89 43 04             	mov    %eax,0x4(%ebx)
80104c94:	74 4b                	je     80104ce1 <create_kernel_process+0x71>

  //This is a kernel process. Trap frame stores user space registers. We don't need to initialise tf. Also, since this doesn't need to have a userspace, we don't need to assign a size to this process. eip stores address of next instruction to be executed
  p->context->eip = (uint)entrypoint;
80104c96:	8b 43 1c             	mov    0x1c(%ebx),%eax
  safestrcpy(p->name, name, sizeof(p->name));
80104c99:	83 ec 04             	sub    $0x4,%esp
  p->context->eip = (uint)entrypoint;
80104c9c:	89 78 10             	mov    %edi,0x10(%eax)
  safestrcpy(p->name, name, sizeof(p->name));
80104c9f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ca2:	6a 10                	push   $0x10
80104ca4:	56                   	push   %esi
80104ca5:	50                   	push   %eax
80104ca6:	e8 a5 05 00 00       	call   80105250 <safestrcpy>

  acquire(&ptable.lock);
80104cab:	c7 04 24 c0 3f 11 80 	movl   $0x80113fc0,(%esp)
80104cb2:	e8 a9 02 00 00       	call   80104f60 <acquire>
  p->state = RUNNABLE;
80104cb7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104cbe:	83 c4 10             	add    $0x10,%esp
80104cc1:	c7 45 08 c0 3f 11 80 	movl   $0x80113fc0,0x8(%ebp)

}
80104cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ccb:	5b                   	pop    %ebx
80104ccc:	5e                   	pop    %esi
80104ccd:	5f                   	pop    %edi
80104cce:	5d                   	pop    %ebp
  release(&ptable.lock);
80104ccf:	e9 4c 03 00 00       	jmp    80105020 <release>
  if(p == 0) panic("create_kernel_process failed");
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	68 07 83 10 80       	push   $0x80108307
80104cdc:	e8 af b6 ff ff       	call   80100390 <panic>
  if((p->pgdir = setupkvm()) == 0) panic("setupkvm failed");
80104ce1:	83 ec 0c             	sub    $0xc,%esp
80104ce4:	68 24 83 10 80       	push   $0x80108324
80104ce9:	e8 a2 b6 ff ff       	call   80100390 <panic>
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104cfa:	68 ec 83 10 80       	push   $0x801083ec
80104cff:	8d 43 04             	lea    0x4(%ebx),%eax
80104d02:	50                   	push   %eax
80104d03:	e8 18 01 00 00       	call   80104e20 <initlock>
  lk->name = name;
80104d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d11:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d14:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d1b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d21:	c9                   	leave  
80104d22:	c3                   	ret    
80104d23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 5d 08             	mov    0x8(%ebp),%ebx

  acquire(&lk->lk);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d3e:	56                   	push   %esi
80104d3f:	e8 1c 02 00 00       	call   80104f60 <acquire>

  while (lk->locked) {
80104d44:	8b 13                	mov    (%ebx),%edx
80104d46:	83 c4 10             	add    $0x10,%esp
80104d49:	85 d2                	test   %edx,%edx
80104d4b:	74 16                	je     80104d63 <acquiresleep+0x33>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104d50:	83 ec 08             	sub    $0x8,%esp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	e8 f6 f9 ff ff       	call   80104750 <sleep>
  while (lk->locked) {
80104d5a:	8b 03                	mov    (%ebx),%eax
80104d5c:	83 c4 10             	add    $0x10,%esp
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	75 ed                	jne    80104d50 <acquiresleep+0x20>
  }

  lk->locked = 1;
80104d63:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d69:	e8 e2 f0 ff ff       	call   80103e50 <myproc>
80104d6e:	8b 40 10             	mov    0x10(%eax),%eax
80104d71:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d74:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7a:	5b                   	pop    %ebx
80104d7b:	5e                   	pop    %esi
80104d7c:	5d                   	pop    %ebp
  release(&lk->lk);
80104d7d:	e9 9e 02 00 00       	jmp    80105020 <release>
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d9e:	56                   	push   %esi
80104d9f:	e8 bc 01 00 00       	call   80104f60 <acquire>
  lk->locked = 0;
80104da4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104daa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104db1:	89 1c 24             	mov    %ebx,(%esp)
80104db4:	e8 47 fb ff ff       	call   80104900 <wakeup>
  release(&lk->lk);
80104db9:	89 75 08             	mov    %esi,0x8(%ebp)
80104dbc:	83 c4 10             	add    $0x10,%esp
}
80104dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dc5:	e9 56 02 00 00       	jmp    80105020 <release>
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	31 ff                	xor    %edi,%edi
80104dd8:	83 ec 18             	sub    $0x18,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104dde:	8d 73 04             	lea    0x4(%ebx),%esi
80104de1:	56                   	push   %esi
80104de2:	e8 79 01 00 00       	call   80104f60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104de7:	8b 03                	mov    (%ebx),%eax
80104de9:	83 c4 10             	add    $0x10,%esp
80104dec:	85 c0                	test   %eax,%eax
80104dee:	74 13                	je     80104e03 <holdingsleep+0x33>
80104df0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104df3:	e8 58 f0 ff ff       	call   80103e50 <myproc>
80104df8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dfb:	0f 94 c0             	sete   %al
80104dfe:	0f b6 c0             	movzbl %al,%eax
80104e01:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104e03:	83 ec 0c             	sub    $0xc,%esp
80104e06:	56                   	push   %esi
80104e07:	e8 14 02 00 00       	call   80105020 <release>
  return r;
}
80104e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e0f:	89 f8                	mov    %edi,%eax
80104e11:	5b                   	pop    %ebx
80104e12:	5e                   	pop    %esi
80104e13:	5f                   	pop    %edi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	66 90                	xchg   %ax,%ax
80104e18:	66 90                	xchg   %ax,%ax
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e40:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e41:	31 d2                	xor    %edx,%edx
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e46:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e4c:	83 e8 08             	sub    $0x8,%eax
80104e4f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e50:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e5c:	77 1a                	ja     80104e78 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e5e:	8b 58 04             	mov    0x4(%eax),%ebx
80104e61:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e64:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e67:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e69:	83 fa 0a             	cmp    $0xa,%edx
80104e6c:	75 e2                	jne    80104e50 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e6e:	5b                   	pop    %ebx
80104e6f:	5d                   	pop    %ebp
80104e70:	c3                   	ret    
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e78:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e7b:	83 c1 28             	add    $0x28,%ecx
80104e7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e89:	39 c1                	cmp    %eax,%ecx
80104e8b:	75 f3                	jne    80104e80 <getcallerpcs+0x40>
}
80104e8d:	5b                   	pop    %ebx
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret    

80104e90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 04             	sub    $0x4,%esp
80104e97:	9c                   	pushf  
80104e98:	5b                   	pop    %ebx
  asm volatile("cli");
80104e99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e9a:	e8 e1 eb ff ff       	call   80103a80 <mycpu>
80104e9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	75 11                	jne    80104eba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ea9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104eaf:	e8 cc eb ff ff       	call   80103a80 <mycpu>
80104eb4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104eba:	e8 c1 eb ff ff       	call   80103a80 <mycpu>
80104ebf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ec6:	83 c4 04             	add    $0x4,%esp
80104ec9:	5b                   	pop    %ebx
80104eca:	5d                   	pop    %ebp
80104ecb:	c3                   	ret    
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <popcli>:

void
popcli(void)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ed6:	9c                   	pushf  
80104ed7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ed8:	f6 c4 02             	test   $0x2,%ah
80104edb:	75 35                	jne    80104f12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104edd:	e8 9e eb ff ff       	call   80103a80 <mycpu>
80104ee2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ee9:	78 34                	js     80104f1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104eeb:	e8 90 eb ff ff       	call   80103a80 <mycpu>
80104ef0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ef6:	85 d2                	test   %edx,%edx
80104ef8:	74 06                	je     80104f00 <popcli+0x30>
    sti();
}
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f00:	e8 7b eb ff ff       	call   80103a80 <mycpu>
80104f05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	74 eb                	je     80104efa <popcli+0x2a>
  asm volatile("sti");
80104f0f:	fb                   	sti    
}
80104f10:	c9                   	leave  
80104f11:	c3                   	ret    
    panic("popcli - interruptible");
80104f12:	83 ec 0c             	sub    $0xc,%esp
80104f15:	68 f7 83 10 80       	push   $0x801083f7
80104f1a:	e8 71 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f1f:	83 ec 0c             	sub    $0xc,%esp
80104f22:	68 0e 84 10 80       	push   $0x8010840e
80104f27:	e8 64 b4 ff ff       	call   80100390 <panic>
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f30 <holding>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
80104f35:	8b 75 08             	mov    0x8(%ebp),%esi
80104f38:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f3a:	e8 51 ff ff ff       	call   80104e90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f3f:	8b 06                	mov    (%esi),%eax
80104f41:	85 c0                	test   %eax,%eax
80104f43:	74 10                	je     80104f55 <holding+0x25>
80104f45:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f48:	e8 33 eb ff ff       	call   80103a80 <mycpu>
80104f4d:	39 c3                	cmp    %eax,%ebx
80104f4f:	0f 94 c3             	sete   %bl
80104f52:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104f55:	e8 76 ff ff ff       	call   80104ed0 <popcli>
}
80104f5a:	89 d8                	mov    %ebx,%eax
80104f5c:	5b                   	pop    %ebx
80104f5d:	5e                   	pop    %esi
80104f5e:	5d                   	pop    %ebp
80104f5f:	c3                   	ret    

80104f60 <acquire>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f65:	e8 26 ff ff ff       	call   80104e90 <pushcli>
  if(holding(lk))
80104f6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	53                   	push   %ebx
80104f71:	e8 ba ff ff ff       	call   80104f30 <holding>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	0f 85 83 00 00 00    	jne    80105004 <acquire+0xa4>
80104f81:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f83:	ba 01 00 00 00       	mov    $0x1,%edx
80104f88:	eb 09                	jmp    80104f93 <acquire+0x33>
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f93:	89 d0                	mov    %edx,%eax
80104f95:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f98:	85 c0                	test   %eax,%eax
80104f9a:	75 f4                	jne    80104f90 <acquire+0x30>
  __sync_synchronize();
80104f9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fa4:	e8 d7 ea ff ff       	call   80103a80 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104fa9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104fac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104faf:	89 e8                	mov    %ebp,%eax
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fb8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104fbe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104fc4:	77 1a                	ja     80104fe0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104fc6:	8b 48 04             	mov    0x4(%eax),%ecx
80104fc9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104fcc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104fcf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fd1:	83 fe 0a             	cmp    $0xa,%esi
80104fd4:	75 e2                	jne    80104fb8 <acquire+0x58>
}
80104fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104fe3:	83 c2 28             	add    $0x28,%edx
80104fe6:	8d 76 00             	lea    0x0(%esi),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ff6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ff9:	39 d0                	cmp    %edx,%eax
80104ffb:	75 f3                	jne    80104ff0 <acquire+0x90>
}
80104ffd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105000:	5b                   	pop    %ebx
80105001:	5e                   	pop    %esi
80105002:	5d                   	pop    %ebp
80105003:	c3                   	ret    
    panic("acquire");
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	68 15 84 10 80       	push   $0x80108415
8010500c:	e8 7f b3 ff ff       	call   80100390 <panic>
80105011:	eb 0d                	jmp    80105020 <release>
80105013:	90                   	nop
80105014:	90                   	nop
80105015:	90                   	nop
80105016:	90                   	nop
80105017:	90                   	nop
80105018:	90                   	nop
80105019:	90                   	nop
8010501a:	90                   	nop
8010501b:	90                   	nop
8010501c:	90                   	nop
8010501d:	90                   	nop
8010501e:	90                   	nop
8010501f:	90                   	nop

80105020 <release>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 10             	sub    $0x10,%esp
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010502a:	53                   	push   %ebx
8010502b:	e8 00 ff ff ff       	call   80104f30 <holding>
80105030:	83 c4 10             	add    $0x10,%esp
80105033:	85 c0                	test   %eax,%eax
80105035:	74 22                	je     80105059 <release+0x39>
  lk->pcs[0] = 0;
80105037:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010503e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105045:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010504a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105053:	c9                   	leave  
  popcli();
80105054:	e9 77 fe ff ff       	jmp    80104ed0 <popcli>
    panic("release");
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	68 1d 84 10 80       	push   $0x8010841d
80105061:	e8 2a b3 ff ff       	call   80100390 <panic>
80105066:	66 90                	xchg   %ax,%ax
80105068:	66 90                	xchg   %ax,%ax
8010506a:	66 90                	xchg   %ax,%ax
8010506c:	66 90                	xchg   %ax,%ax
8010506e:	66 90                	xchg   %ax,%ax

80105070 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	53                   	push   %ebx
80105075:	8b 55 08             	mov    0x8(%ebp),%edx
80105078:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010507b:	f6 c2 03             	test   $0x3,%dl
8010507e:	75 05                	jne    80105085 <memset+0x15>
80105080:	f6 c1 03             	test   $0x3,%cl
80105083:	74 13                	je     80105098 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105085:	89 d7                	mov    %edx,%edi
80105087:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508a:	fc                   	cld    
8010508b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010508d:	5b                   	pop    %ebx
8010508e:	89 d0                	mov    %edx,%eax
80105090:	5f                   	pop    %edi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	90                   	nop
80105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105098:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010509c:	c1 e9 02             	shr    $0x2,%ecx
8010509f:	89 f8                	mov    %edi,%eax
801050a1:	89 fb                	mov    %edi,%ebx
801050a3:	c1 e0 18             	shl    $0x18,%eax
801050a6:	c1 e3 10             	shl    $0x10,%ebx
801050a9:	09 d8                	or     %ebx,%eax
801050ab:	09 f8                	or     %edi,%eax
801050ad:	c1 e7 08             	shl    $0x8,%edi
801050b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801050b2:	89 d7                	mov    %edx,%edi
801050b4:	fc                   	cld    
801050b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801050b7:	5b                   	pop    %ebx
801050b8:	89 d0                	mov    %edx,%eax
801050ba:	5f                   	pop    %edi
801050bb:	5d                   	pop    %ebp
801050bc:	c3                   	ret    
801050bd:	8d 76 00             	lea    0x0(%esi),%esi

801050c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
801050c5:	53                   	push   %ebx
801050c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801050c9:	8b 75 08             	mov    0x8(%ebp),%esi
801050cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050cf:	85 db                	test   %ebx,%ebx
801050d1:	74 29                	je     801050fc <memcmp+0x3c>
    if(*s1 != *s2)
801050d3:	0f b6 16             	movzbl (%esi),%edx
801050d6:	0f b6 0f             	movzbl (%edi),%ecx
801050d9:	38 d1                	cmp    %dl,%cl
801050db:	75 2b                	jne    80105108 <memcmp+0x48>
801050dd:	b8 01 00 00 00       	mov    $0x1,%eax
801050e2:	eb 14                	jmp    801050f8 <memcmp+0x38>
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801050ec:	83 c0 01             	add    $0x1,%eax
801050ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801050f4:	38 ca                	cmp    %cl,%dl
801050f6:	75 10                	jne    80105108 <memcmp+0x48>
  while(n-- > 0){
801050f8:	39 d8                	cmp    %ebx,%eax
801050fa:	75 ec                	jne    801050e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801050fc:	5b                   	pop    %ebx
  return 0;
801050fd:	31 c0                	xor    %eax,%eax
}
801050ff:	5e                   	pop    %esi
80105100:	5f                   	pop    %edi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105108:	0f b6 c2             	movzbl %dl,%eax
}
8010510b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010510c:	29 c8                	sub    %ecx,%eax
}
8010510e:	5e                   	pop    %esi
8010510f:	5f                   	pop    %edi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 45 08             	mov    0x8(%ebp),%eax
80105128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010512b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010512e:	39 c3                	cmp    %eax,%ebx
80105130:	73 26                	jae    80105158 <memmove+0x38>
80105132:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105135:	39 c8                	cmp    %ecx,%eax
80105137:	73 1f                	jae    80105158 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105139:	85 f6                	test   %esi,%esi
8010513b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010513e:	74 0f                	je     8010514f <memmove+0x2f>
      *--d = *--s;
80105140:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105144:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105147:	83 ea 01             	sub    $0x1,%edx
8010514a:	83 fa ff             	cmp    $0xffffffff,%edx
8010514d:	75 f1                	jne    80105140 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	90                   	nop
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105158:	31 d2                	xor    %edx,%edx
8010515a:	85 f6                	test   %esi,%esi
8010515c:	74 f1                	je     8010514f <memmove+0x2f>
8010515e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105160:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105164:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105167:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010516a:	39 d6                	cmp    %edx,%esi
8010516c:	75 f2                	jne    80105160 <memmove+0x40>
}
8010516e:	5b                   	pop    %ebx
8010516f:	5e                   	pop    %esi
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret    
80105172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105183:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105184:	eb 9a                	jmp    80105120 <memmove>
80105186:	8d 76 00             	lea    0x0(%esi),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	8b 7d 10             	mov    0x10(%ebp),%edi
80105198:	53                   	push   %ebx
80105199:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010519c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010519f:	85 ff                	test   %edi,%edi
801051a1:	74 2f                	je     801051d2 <strncmp+0x42>
801051a3:	0f b6 01             	movzbl (%ecx),%eax
801051a6:	0f b6 1e             	movzbl (%esi),%ebx
801051a9:	84 c0                	test   %al,%al
801051ab:	74 37                	je     801051e4 <strncmp+0x54>
801051ad:	38 c3                	cmp    %al,%bl
801051af:	75 33                	jne    801051e4 <strncmp+0x54>
801051b1:	01 f7                	add    %esi,%edi
801051b3:	eb 13                	jmp    801051c8 <strncmp+0x38>
801051b5:	8d 76 00             	lea    0x0(%esi),%esi
801051b8:	0f b6 01             	movzbl (%ecx),%eax
801051bb:	84 c0                	test   %al,%al
801051bd:	74 21                	je     801051e0 <strncmp+0x50>
801051bf:	0f b6 1a             	movzbl (%edx),%ebx
801051c2:	89 d6                	mov    %edx,%esi
801051c4:	38 d8                	cmp    %bl,%al
801051c6:	75 1c                	jne    801051e4 <strncmp+0x54>
    n--, p++, q++;
801051c8:	8d 56 01             	lea    0x1(%esi),%edx
801051cb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801051ce:	39 fa                	cmp    %edi,%edx
801051d0:	75 e6                	jne    801051b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801051d2:	5b                   	pop    %ebx
    return 0;
801051d3:	31 c0                	xor    %eax,%eax
}
801051d5:	5e                   	pop    %esi
801051d6:	5f                   	pop    %edi
801051d7:	5d                   	pop    %ebp
801051d8:	c3                   	ret    
801051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051e0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801051e4:	29 d8                	sub    %ebx,%eax
}
801051e6:	5b                   	pop    %ebx
801051e7:	5e                   	pop    %esi
801051e8:	5f                   	pop    %edi
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
801051f5:	8b 45 08             	mov    0x8(%ebp),%eax
801051f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801051fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801051fe:	89 c2                	mov    %eax,%edx
80105200:	eb 19                	jmp    8010521b <strncpy+0x2b>
80105202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105208:	83 c3 01             	add    $0x1,%ebx
8010520b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010520f:	83 c2 01             	add    $0x1,%edx
80105212:	84 c9                	test   %cl,%cl
80105214:	88 4a ff             	mov    %cl,-0x1(%edx)
80105217:	74 09                	je     80105222 <strncpy+0x32>
80105219:	89 f1                	mov    %esi,%ecx
8010521b:	85 c9                	test   %ecx,%ecx
8010521d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105220:	7f e6                	jg     80105208 <strncpy+0x18>
    ;
  while(n-- > 0)
80105222:	31 c9                	xor    %ecx,%ecx
80105224:	85 f6                	test   %esi,%esi
80105226:	7e 17                	jle    8010523f <strncpy+0x4f>
80105228:	90                   	nop
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105230:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105234:	89 f3                	mov    %esi,%ebx
80105236:	83 c1 01             	add    $0x1,%ecx
80105239:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010523b:	85 db                	test   %ebx,%ebx
8010523d:	7f f1                	jg     80105230 <strncpy+0x40>
  return os;
}
8010523f:	5b                   	pop    %ebx
80105240:	5e                   	pop    %esi
80105241:	5d                   	pop    %ebp
80105242:	c3                   	ret    
80105243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
80105255:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105258:	8b 45 08             	mov    0x8(%ebp),%eax
8010525b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010525e:	85 c9                	test   %ecx,%ecx
80105260:	7e 26                	jle    80105288 <safestrcpy+0x38>
80105262:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105266:	89 c1                	mov    %eax,%ecx
80105268:	eb 17                	jmp    80105281 <safestrcpy+0x31>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105270:	83 c2 01             	add    $0x1,%edx
80105273:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105277:	83 c1 01             	add    $0x1,%ecx
8010527a:	84 db                	test   %bl,%bl
8010527c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010527f:	74 04                	je     80105285 <safestrcpy+0x35>
80105281:	39 f2                	cmp    %esi,%edx
80105283:	75 eb                	jne    80105270 <safestrcpy+0x20>
    ;
  *s = 0;
80105285:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105288:	5b                   	pop    %ebx
80105289:	5e                   	pop    %esi
8010528a:	5d                   	pop    %ebp
8010528b:	c3                   	ret    
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <strlen>:

int
strlen(const char *s)
{
80105290:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105291:	31 c0                	xor    %eax,%eax
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105298:	80 3a 00             	cmpb   $0x0,(%edx)
8010529b:	74 0c                	je     801052a9 <strlen+0x19>
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
801052a0:	83 c0 01             	add    $0x1,%eax
801052a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801052a7:	75 f7                	jne    801052a0 <strlen+0x10>
    ;
  return n;
}
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    

801052ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801052b3:	55                   	push   %ebp
  pushl %ebx
801052b4:	53                   	push   %ebx
  pushl %esi
801052b5:	56                   	push   %esi
  pushl %edi
801052b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801052bb:	5f                   	pop    %edi
  popl %esi
801052bc:	5e                   	pop    %esi
  popl %ebx
801052bd:	5b                   	pop    %ebx
  popl %ebp
801052be:	5d                   	pop    %ebp
  ret
801052bf:	c3                   	ret    

801052c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 04             	sub    $0x4,%esp
801052c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052ca:	e8 81 eb ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052cf:	8b 00                	mov    (%eax),%eax
801052d1:	39 d8                	cmp    %ebx,%eax
801052d3:	76 1b                	jbe    801052f0 <fetchint+0x30>
801052d5:	8d 53 04             	lea    0x4(%ebx),%edx
801052d8:	39 d0                	cmp    %edx,%eax
801052da:	72 14                	jb     801052f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801052df:	8b 13                	mov    (%ebx),%edx
801052e1:	89 10                	mov    %edx,(%eax)
  return 0;
801052e3:	31 c0                	xor    %eax,%eax
}
801052e5:	83 c4 04             	add    $0x4,%esp
801052e8:	5b                   	pop    %ebx
801052e9:	5d                   	pop    %ebp
801052ea:	c3                   	ret    
801052eb:	90                   	nop
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f5:	eb ee                	jmp    801052e5 <fetchint+0x25>
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 04             	sub    $0x4,%esp
80105307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010530a:	e8 41 eb ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz)
8010530f:	39 18                	cmp    %ebx,(%eax)
80105311:	76 29                	jbe    8010533c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105316:	89 da                	mov    %ebx,%edx
80105318:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010531a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010531c:	39 c3                	cmp    %eax,%ebx
8010531e:	73 1c                	jae    8010533c <fetchstr+0x3c>
    if(*s == 0)
80105320:	80 3b 00             	cmpb   $0x0,(%ebx)
80105323:	75 10                	jne    80105335 <fetchstr+0x35>
80105325:	eb 39                	jmp    80105360 <fetchstr+0x60>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105330:	80 3a 00             	cmpb   $0x0,(%edx)
80105333:	74 1b                	je     80105350 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105335:	83 c2 01             	add    $0x1,%edx
80105338:	39 d0                	cmp    %edx,%eax
8010533a:	77 f4                	ja     80105330 <fetchstr+0x30>
    return -1;
8010533c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105341:	83 c4 04             	add    $0x4,%esp
80105344:	5b                   	pop    %ebx
80105345:	5d                   	pop    %ebp
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105350:	83 c4 04             	add    $0x4,%esp
80105353:	89 d0                	mov    %edx,%eax
80105355:	29 d8                	sub    %ebx,%eax
80105357:	5b                   	pop    %ebx
80105358:	5d                   	pop    %ebp
80105359:	c3                   	ret    
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105360:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105362:	eb dd                	jmp    80105341 <fetchstr+0x41>
80105364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010536a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105370 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105375:	e8 d6 ea ff ff       	call   80103e50 <myproc>
8010537a:	8b 40 18             	mov    0x18(%eax),%eax
8010537d:	8b 55 08             	mov    0x8(%ebp),%edx
80105380:	8b 40 44             	mov    0x44(%eax),%eax
80105383:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105386:	e8 c5 ea ff ff       	call   80103e50 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010538b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010538d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105390:	39 c6                	cmp    %eax,%esi
80105392:	73 1c                	jae    801053b0 <argint+0x40>
80105394:	8d 53 08             	lea    0x8(%ebx),%edx
80105397:	39 d0                	cmp    %edx,%eax
80105399:	72 15                	jb     801053b0 <argint+0x40>
  *ip = *(int*)(addr);
8010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539e:	8b 53 04             	mov    0x4(%ebx),%edx
801053a1:	89 10                	mov    %edx,(%eax)
  return 0;
801053a3:	31 c0                	xor    %eax,%eax
}
801053a5:	5b                   	pop    %ebx
801053a6:	5e                   	pop    %esi
801053a7:	5d                   	pop    %ebp
801053a8:	c3                   	ret    
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053b5:	eb ee                	jmp    801053a5 <argint+0x35>
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
801053c5:	83 ec 10             	sub    $0x10,%esp
801053c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801053cb:	e8 80 ea ff ff       	call   80103e50 <myproc>
801053d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801053d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	50                   	push   %eax
801053d9:	ff 75 08             	pushl  0x8(%ebp)
801053dc:	e8 8f ff ff ff       	call   80105370 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 28                	js     80105410 <argptr+0x50>
801053e8:	85 db                	test   %ebx,%ebx
801053ea:	78 24                	js     80105410 <argptr+0x50>
801053ec:	8b 16                	mov    (%esi),%edx
801053ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f1:	39 c2                	cmp    %eax,%edx
801053f3:	76 1b                	jbe    80105410 <argptr+0x50>
801053f5:	01 c3                	add    %eax,%ebx
801053f7:	39 da                	cmp    %ebx,%edx
801053f9:	72 15                	jb     80105410 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801053fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801053fe:	89 02                	mov    %eax,(%edx)
  return 0;
80105400:	31 c0                	xor    %eax,%eax
}
80105402:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105415:	eb eb                	jmp    80105402 <argptr+0x42>
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105426:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105429:	50                   	push   %eax
8010542a:	ff 75 08             	pushl  0x8(%ebp)
8010542d:	e8 3e ff ff ff       	call   80105370 <argint>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	78 17                	js     80105450 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	ff 75 0c             	pushl  0xc(%ebp)
8010543f:	ff 75 f4             	pushl  -0xc(%ebp)
80105442:	e8 b9 fe ff ff       	call   80105300 <fetchstr>
80105447:	83 c4 10             	add    $0x10,%esp
}
8010544a:	c9                   	leave  
8010544b:	c3                   	ret    
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <syscall>:
[SYS_draw]  sys_draw,
};

void
syscall(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105467:	e8 e4 e9 ff ff       	call   80103e50 <myproc>
8010546c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010546e:	8b 40 18             	mov    0x18(%eax),%eax
80105471:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105474:	8d 50 ff             	lea    -0x1(%eax),%edx
80105477:	83 fa 15             	cmp    $0x15,%edx
8010547a:	77 1c                	ja     80105498 <syscall+0x38>
8010547c:	8b 14 85 60 84 10 80 	mov    -0x7fef7ba0(,%eax,4),%edx
80105483:	85 d2                	test   %edx,%edx
80105485:	74 11                	je     80105498 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105487:	ff d2                	call   *%edx
80105489:	8b 53 18             	mov    0x18(%ebx),%edx
8010548c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010548f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105492:	c9                   	leave  
80105493:	c3                   	ret    
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105498:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105499:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010549c:	50                   	push   %eax
8010549d:	ff 73 10             	pushl  0x10(%ebx)
801054a0:	68 25 84 10 80       	push   $0x80108425
801054a5:	e8 b6 b1 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801054aa:	8b 43 18             	mov    0x18(%ebx),%eax
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801054b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054ba:	c9                   	leave  
801054bb:	c3                   	ret    
801054bc:	66 90                	xchg   %ax,%ax
801054be:	66 90                	xchg   %ax,%ax

801054c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
801054c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801054c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801054c9:	83 ec 34             	sub    $0x34,%esp
801054cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801054cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801054d2:	56                   	push   %esi
801054d3:	50                   	push   %eax
{
801054d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801054d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801054da:	e8 21 ca ff ff       	call   80101f00 <nameiparent>
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	85 c0                	test   %eax,%eax
801054e4:	0f 84 46 01 00 00    	je     80105630 <create+0x170>
    return 0;
  ilock(dp);
801054ea:	83 ec 0c             	sub    $0xc,%esp
801054ed:	89 c3                	mov    %eax,%ebx
801054ef:	50                   	push   %eax
801054f0:	e8 8b c1 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801054f5:	83 c4 0c             	add    $0xc,%esp
801054f8:	6a 00                	push   $0x0
801054fa:	56                   	push   %esi
801054fb:	53                   	push   %ebx
801054fc:	e8 af c6 ff ff       	call   80101bb0 <dirlookup>
80105501:	83 c4 10             	add    $0x10,%esp
80105504:	85 c0                	test   %eax,%eax
80105506:	89 c7                	mov    %eax,%edi
80105508:	74 36                	je     80105540 <create+0x80>
    iunlockput(dp);
8010550a:	83 ec 0c             	sub    $0xc,%esp
8010550d:	53                   	push   %ebx
8010550e:	e8 fd c3 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105513:	89 3c 24             	mov    %edi,(%esp)
80105516:	e8 65 c1 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010551b:	83 c4 10             	add    $0x10,%esp
8010551e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105523:	0f 85 97 00 00 00    	jne    801055c0 <create+0x100>
80105529:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010552e:	0f 85 8c 00 00 00    	jne    801055c0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105537:	89 f8                	mov    %edi,%eax
80105539:	5b                   	pop    %ebx
8010553a:	5e                   	pop    %esi
8010553b:	5f                   	pop    %edi
8010553c:	5d                   	pop    %ebp
8010553d:	c3                   	ret    
8010553e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105540:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	50                   	push   %eax
80105548:	ff 33                	pushl  (%ebx)
8010554a:	e8 c1 bf ff ff       	call   80101510 <ialloc>
8010554f:	83 c4 10             	add    $0x10,%esp
80105552:	85 c0                	test   %eax,%eax
80105554:	89 c7                	mov    %eax,%edi
80105556:	0f 84 e8 00 00 00    	je     80105644 <create+0x184>
  ilock(ip);
8010555c:	83 ec 0c             	sub    $0xc,%esp
8010555f:	50                   	push   %eax
80105560:	e8 1b c1 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105565:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105569:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010556d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105571:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105575:	b8 01 00 00 00       	mov    $0x1,%eax
8010557a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010557e:	89 3c 24             	mov    %edi,(%esp)
80105581:	e8 4a c0 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105586:	83 c4 10             	add    $0x10,%esp
80105589:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010558e:	74 50                	je     801055e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105590:	83 ec 04             	sub    $0x4,%esp
80105593:	ff 77 04             	pushl  0x4(%edi)
80105596:	56                   	push   %esi
80105597:	53                   	push   %ebx
80105598:	e8 83 c8 ff ff       	call   80101e20 <dirlink>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	0f 88 8f 00 00 00    	js     80105637 <create+0x177>
  iunlockput(dp);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	53                   	push   %ebx
801055ac:	e8 5f c3 ff ff       	call   80101910 <iunlockput>
  return ip;
801055b1:	83 c4 10             	add    $0x10,%esp
}
801055b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b7:	89 f8                	mov    %edi,%eax
801055b9:	5b                   	pop    %ebx
801055ba:	5e                   	pop    %esi
801055bb:	5f                   	pop    %edi
801055bc:	5d                   	pop    %ebp
801055bd:	c3                   	ret    
801055be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	57                   	push   %edi
    return 0;
801055c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801055c6:	e8 45 c3 ff ff       	call   80101910 <iunlockput>
    return 0;
801055cb:	83 c4 10             	add    $0x10,%esp
}
801055ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d1:	89 f8                	mov    %edi,%eax
801055d3:	5b                   	pop    %ebx
801055d4:	5e                   	pop    %esi
801055d5:	5f                   	pop    %edi
801055d6:	5d                   	pop    %ebp
801055d7:	c3                   	ret    
801055d8:	90                   	nop
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801055e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	53                   	push   %ebx
801055e9:	e8 e2 bf ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801055ee:	83 c4 0c             	add    $0xc,%esp
801055f1:	ff 77 04             	pushl  0x4(%edi)
801055f4:	68 c9 84 10 80       	push   $0x801084c9
801055f9:	57                   	push   %edi
801055fa:	e8 21 c8 ff ff       	call   80101e20 <dirlink>
801055ff:	83 c4 10             	add    $0x10,%esp
80105602:	85 c0                	test   %eax,%eax
80105604:	78 1c                	js     80105622 <create+0x162>
80105606:	83 ec 04             	sub    $0x4,%esp
80105609:	ff 73 04             	pushl  0x4(%ebx)
8010560c:	68 c8 84 10 80       	push   $0x801084c8
80105611:	57                   	push   %edi
80105612:	e8 09 c8 ff ff       	call   80101e20 <dirlink>
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	85 c0                	test   %eax,%eax
8010561c:	0f 89 6e ff ff ff    	jns    80105590 <create+0xd0>
      panic("create dots");
80105622:	83 ec 0c             	sub    $0xc,%esp
80105625:	68 bc 84 10 80       	push   $0x801084bc
8010562a:	e8 61 ad ff ff       	call   80100390 <panic>
8010562f:	90                   	nop
    return 0;
80105630:	31 ff                	xor    %edi,%edi
80105632:	e9 fd fe ff ff       	jmp    80105534 <create+0x74>
    panic("create: dirlink");
80105637:	83 ec 0c             	sub    $0xc,%esp
8010563a:	68 fb 81 10 80       	push   $0x801081fb
8010563f:	e8 4c ad ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	68 ec 81 10 80       	push   $0x801081ec
8010564c:	e8 3f ad ff ff       	call   80100390 <panic>
80105651:	eb 0d                	jmp    80105660 <argfd.constprop.0>
80105653:	90                   	nop
80105654:	90                   	nop
80105655:	90                   	nop
80105656:	90                   	nop
80105657:	90                   	nop
80105658:	90                   	nop
80105659:	90                   	nop
8010565a:	90                   	nop
8010565b:	90                   	nop
8010565c:	90                   	nop
8010565d:	90                   	nop
8010565e:	90                   	nop
8010565f:	90                   	nop

80105660 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
80105665:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010566a:	89 d6                	mov    %edx,%esi
8010566c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010566f:	50                   	push   %eax
80105670:	6a 00                	push   $0x0
80105672:	e8 f9 fc ff ff       	call   80105370 <argint>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	78 2a                	js     801056a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010567e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105682:	77 24                	ja     801056a8 <argfd.constprop.0+0x48>
80105684:	e8 c7 e7 ff ff       	call   80103e50 <myproc>
80105689:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010568c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105690:	85 c0                	test   %eax,%eax
80105692:	74 14                	je     801056a8 <argfd.constprop.0+0x48>
  if(pfd)
80105694:	85 db                	test   %ebx,%ebx
80105696:	74 02                	je     8010569a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105698:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010569a:	89 06                	mov    %eax,(%esi)
  return 0;
8010569c:	31 c0                	xor    %eax,%eax
}
8010569e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056a1:	5b                   	pop    %ebx
801056a2:	5e                   	pop    %esi
801056a3:	5d                   	pop    %ebp
801056a4:	c3                   	ret    
801056a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ad:	eb ef                	jmp    8010569e <argfd.constprop.0+0x3e>
801056af:	90                   	nop

801056b0 <sys_dup>:
{
801056b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801056b1:	31 c0                	xor    %eax,%eax
{
801056b3:	89 e5                	mov    %esp,%ebp
801056b5:	56                   	push   %esi
801056b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801056b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801056ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801056bd:	e8 9e ff ff ff       	call   80105660 <argfd.constprop.0>
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 42                	js     80105708 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801056c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056cb:	e8 80 e7 ff ff       	call   80103e50 <myproc>
801056d0:	eb 0e                	jmp    801056e0 <sys_dup+0x30>
801056d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056d8:	83 c3 01             	add    $0x1,%ebx
801056db:	83 fb 10             	cmp    $0x10,%ebx
801056de:	74 28                	je     80105708 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801056e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056e4:	85 d2                	test   %edx,%edx
801056e6:	75 f0                	jne    801056d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801056e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801056ec:	83 ec 0c             	sub    $0xc,%esp
801056ef:	ff 75 f4             	pushl  -0xc(%ebp)
801056f2:	e8 f9 b6 ff ff       	call   80100df0 <filedup>
  return fd;
801056f7:	83 c4 10             	add    $0x10,%esp
}
801056fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056fd:	89 d8                	mov    %ebx,%eax
801056ff:	5b                   	pop    %ebx
80105700:	5e                   	pop    %esi
80105701:	5d                   	pop    %ebp
80105702:	c3                   	ret    
80105703:	90                   	nop
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105708:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010570b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105710:	89 d8                	mov    %ebx,%eax
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    
80105716:	8d 76 00             	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_read>:
{
80105720:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105721:	31 c0                	xor    %eax,%eax
{
80105723:	89 e5                	mov    %esp,%ebp
80105725:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105728:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010572b:	e8 30 ff ff ff       	call   80105660 <argfd.constprop.0>
80105730:	85 c0                	test   %eax,%eax
80105732:	78 4c                	js     80105780 <sys_read+0x60>
80105734:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105737:	83 ec 08             	sub    $0x8,%esp
8010573a:	50                   	push   %eax
8010573b:	6a 02                	push   $0x2
8010573d:	e8 2e fc ff ff       	call   80105370 <argint>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 37                	js     80105780 <sys_read+0x60>
80105749:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574c:	83 ec 04             	sub    $0x4,%esp
8010574f:	ff 75 f0             	pushl  -0x10(%ebp)
80105752:	50                   	push   %eax
80105753:	6a 01                	push   $0x1
80105755:	e8 66 fc ff ff       	call   801053c0 <argptr>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	78 1f                	js     80105780 <sys_read+0x60>
  return fileread(f, p, n);
80105761:	83 ec 04             	sub    $0x4,%esp
80105764:	ff 75 f0             	pushl  -0x10(%ebp)
80105767:	ff 75 f4             	pushl  -0xc(%ebp)
8010576a:	ff 75 ec             	pushl  -0x14(%ebp)
8010576d:	e8 ee b7 ff ff       	call   80100f60 <fileread>
80105772:	83 c4 10             	add    $0x10,%esp
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_write>:
{
80105790:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105791:	31 c0                	xor    %eax,%eax
{
80105793:	89 e5                	mov    %esp,%ebp
80105795:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105798:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010579b:	e8 c0 fe ff ff       	call   80105660 <argfd.constprop.0>
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 4c                	js     801057f0 <sys_write+0x60>
801057a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a7:	83 ec 08             	sub    $0x8,%esp
801057aa:	50                   	push   %eax
801057ab:	6a 02                	push   $0x2
801057ad:	e8 be fb ff ff       	call   80105370 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 37                	js     801057f0 <sys_write+0x60>
801057b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057bc:	83 ec 04             	sub    $0x4,%esp
801057bf:	ff 75 f0             	pushl  -0x10(%ebp)
801057c2:	50                   	push   %eax
801057c3:	6a 01                	push   $0x1
801057c5:	e8 f6 fb ff ff       	call   801053c0 <argptr>
801057ca:	83 c4 10             	add    $0x10,%esp
801057cd:	85 c0                	test   %eax,%eax
801057cf:	78 1f                	js     801057f0 <sys_write+0x60>
  return filewrite(f, p, n);
801057d1:	83 ec 04             	sub    $0x4,%esp
801057d4:	ff 75 f0             	pushl  -0x10(%ebp)
801057d7:	ff 75 f4             	pushl  -0xc(%ebp)
801057da:	ff 75 ec             	pushl  -0x14(%ebp)
801057dd:	e8 0e b8 ff ff       	call   80100ff0 <filewrite>
801057e2:	83 c4 10             	add    $0x10,%esp
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <sys_close>:
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105806:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105809:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010580c:	e8 4f fe ff ff       	call   80105660 <argfd.constprop.0>
80105811:	85 c0                	test   %eax,%eax
80105813:	78 2b                	js     80105840 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105815:	e8 36 e6 ff ff       	call   80103e50 <myproc>
8010581a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010581d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105820:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105827:	00 
  fileclose(f);
80105828:	ff 75 f4             	pushl  -0xc(%ebp)
8010582b:	e8 10 b6 ff ff       	call   80100e40 <fileclose>
  return 0;
80105830:	83 c4 10             	add    $0x10,%esp
80105833:	31 c0                	xor    %eax,%eax
}
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105845:	c9                   	leave  
80105846:	c3                   	ret    
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_fstat>:
{
80105850:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105851:	31 c0                	xor    %eax,%eax
{
80105853:	89 e5                	mov    %esp,%ebp
80105855:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105858:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010585b:	e8 00 fe ff ff       	call   80105660 <argfd.constprop.0>
80105860:	85 c0                	test   %eax,%eax
80105862:	78 2c                	js     80105890 <sys_fstat+0x40>
80105864:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105867:	83 ec 04             	sub    $0x4,%esp
8010586a:	6a 14                	push   $0x14
8010586c:	50                   	push   %eax
8010586d:	6a 01                	push   $0x1
8010586f:	e8 4c fb ff ff       	call   801053c0 <argptr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	78 15                	js     80105890 <sys_fstat+0x40>
  return filestat(f, st);
8010587b:	83 ec 08             	sub    $0x8,%esp
8010587e:	ff 75 f4             	pushl  -0xc(%ebp)
80105881:	ff 75 f0             	pushl  -0x10(%ebp)
80105884:	e8 87 b6 ff ff       	call   80100f10 <filestat>
80105889:	83 c4 10             	add    $0x10,%esp
}
8010588c:	c9                   	leave  
8010588d:	c3                   	ret    
8010588e:	66 90                	xchg   %ax,%ax
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_link>:
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
801058a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801058a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058ac:	50                   	push   %eax
801058ad:	6a 00                	push   $0x0
801058af:	e8 6c fb ff ff       	call   80105420 <argstr>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	0f 88 fb 00 00 00    	js     801059ba <sys_link+0x11a>
801058bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801058c2:	83 ec 08             	sub    $0x8,%esp
801058c5:	50                   	push   %eax
801058c6:	6a 01                	push   $0x1
801058c8:	e8 53 fb ff ff       	call   80105420 <argstr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	0f 88 e2 00 00 00    	js     801059ba <sys_link+0x11a>
  begin_op();
801058d8:	e8 43 d3 ff ff       	call   80102c20 <begin_op>
  if((ip = namei(old)) == 0){
801058dd:	83 ec 0c             	sub    $0xc,%esp
801058e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801058e3:	e8 f8 c5 ff ff       	call   80101ee0 <namei>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	89 c3                	mov    %eax,%ebx
801058ef:	0f 84 ea 00 00 00    	je     801059df <sys_link+0x13f>
  ilock(ip);
801058f5:	83 ec 0c             	sub    $0xc,%esp
801058f8:	50                   	push   %eax
801058f9:	e8 82 bd ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105906:	0f 84 bb 00 00 00    	je     801059c7 <sys_link+0x127>
  ip->nlink++;
8010590c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105911:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105914:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105917:	53                   	push   %ebx
80105918:	e8 b3 bc ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010591d:	89 1c 24             	mov    %ebx,(%esp)
80105920:	e8 3b be ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105925:	58                   	pop    %eax
80105926:	5a                   	pop    %edx
80105927:	57                   	push   %edi
80105928:	ff 75 d0             	pushl  -0x30(%ebp)
8010592b:	e8 d0 c5 ff ff       	call   80101f00 <nameiparent>
80105930:	83 c4 10             	add    $0x10,%esp
80105933:	85 c0                	test   %eax,%eax
80105935:	89 c6                	mov    %eax,%esi
80105937:	74 5b                	je     80105994 <sys_link+0xf4>
  ilock(dp);
80105939:	83 ec 0c             	sub    $0xc,%esp
8010593c:	50                   	push   %eax
8010593d:	e8 3e bd ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	8b 03                	mov    (%ebx),%eax
80105947:	39 06                	cmp    %eax,(%esi)
80105949:	75 3d                	jne    80105988 <sys_link+0xe8>
8010594b:	83 ec 04             	sub    $0x4,%esp
8010594e:	ff 73 04             	pushl  0x4(%ebx)
80105951:	57                   	push   %edi
80105952:	56                   	push   %esi
80105953:	e8 c8 c4 ff ff       	call   80101e20 <dirlink>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	85 c0                	test   %eax,%eax
8010595d:	78 29                	js     80105988 <sys_link+0xe8>
  iunlockput(dp);
8010595f:	83 ec 0c             	sub    $0xc,%esp
80105962:	56                   	push   %esi
80105963:	e8 a8 bf ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105968:	89 1c 24             	mov    %ebx,(%esp)
8010596b:	e8 40 be ff ff       	call   801017b0 <iput>
  end_op();
80105970:	e8 1b d3 ff ff       	call   80102c90 <end_op>
  return 0;
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	31 c0                	xor    %eax,%eax
}
8010597a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010597d:	5b                   	pop    %ebx
8010597e:	5e                   	pop    %esi
8010597f:	5f                   	pop    %edi
80105980:	5d                   	pop    %ebp
80105981:	c3                   	ret    
80105982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	56                   	push   %esi
8010598c:	e8 7f bf ff ff       	call   80101910 <iunlockput>
    goto bad;
80105991:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105994:	83 ec 0c             	sub    $0xc,%esp
80105997:	53                   	push   %ebx
80105998:	e8 e3 bc ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010599d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059a2:	89 1c 24             	mov    %ebx,(%esp)
801059a5:	e8 26 bc ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801059aa:	89 1c 24             	mov    %ebx,(%esp)
801059ad:	e8 5e bf ff ff       	call   80101910 <iunlockput>
  end_op();
801059b2:	e8 d9 d2 ff ff       	call   80102c90 <end_op>
  return -1;
801059b7:	83 c4 10             	add    $0x10,%esp
}
801059ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801059bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c2:	5b                   	pop    %ebx
801059c3:	5e                   	pop    %esi
801059c4:	5f                   	pop    %edi
801059c5:	5d                   	pop    %ebp
801059c6:	c3                   	ret    
    iunlockput(ip);
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	53                   	push   %ebx
801059cb:	e8 40 bf ff ff       	call   80101910 <iunlockput>
    end_op();
801059d0:	e8 bb d2 ff ff       	call   80102c90 <end_op>
    return -1;
801059d5:	83 c4 10             	add    $0x10,%esp
801059d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dd:	eb 9b                	jmp    8010597a <sys_link+0xda>
    end_op();
801059df:	e8 ac d2 ff ff       	call   80102c90 <end_op>
    return -1;
801059e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e9:	eb 8f                	jmp    8010597a <sys_link+0xda>
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_unlink>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801059f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801059f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801059fc:	50                   	push   %eax
801059fd:	6a 00                	push   $0x0
801059ff:	e8 1c fa ff ff       	call   80105420 <argstr>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	0f 88 77 01 00 00    	js     80105b86 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105a0f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105a12:	e8 09 d2 ff ff       	call   80102c20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a17:	83 ec 08             	sub    $0x8,%esp
80105a1a:	53                   	push   %ebx
80105a1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105a1e:	e8 dd c4 ff ff       	call   80101f00 <nameiparent>
80105a23:	83 c4 10             	add    $0x10,%esp
80105a26:	85 c0                	test   %eax,%eax
80105a28:	89 c6                	mov    %eax,%esi
80105a2a:	0f 84 60 01 00 00    	je     80105b90 <sys_unlink+0x1a0>
  ilock(dp);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	50                   	push   %eax
80105a34:	e8 47 bc ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a39:	58                   	pop    %eax
80105a3a:	5a                   	pop    %edx
80105a3b:	68 c9 84 10 80       	push   $0x801084c9
80105a40:	53                   	push   %ebx
80105a41:	e8 4a c1 ff ff       	call   80101b90 <namecmp>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	0f 84 03 01 00 00    	je     80105b54 <sys_unlink+0x164>
80105a51:	83 ec 08             	sub    $0x8,%esp
80105a54:	68 c8 84 10 80       	push   $0x801084c8
80105a59:	53                   	push   %ebx
80105a5a:	e8 31 c1 ff ff       	call   80101b90 <namecmp>
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	85 c0                	test   %eax,%eax
80105a64:	0f 84 ea 00 00 00    	je     80105b54 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105a6a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a6d:	83 ec 04             	sub    $0x4,%esp
80105a70:	50                   	push   %eax
80105a71:	53                   	push   %ebx
80105a72:	56                   	push   %esi
80105a73:	e8 38 c1 ff ff       	call   80101bb0 <dirlookup>
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	89 c3                	mov    %eax,%ebx
80105a7f:	0f 84 cf 00 00 00    	je     80105b54 <sys_unlink+0x164>
  ilock(ip);
80105a85:	83 ec 0c             	sub    $0xc,%esp
80105a88:	50                   	push   %eax
80105a89:	e8 f2 bb ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105a96:	0f 8e 10 01 00 00    	jle    80105bac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105aa1:	74 6d                	je     80105b10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105aa3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105aa6:	83 ec 04             	sub    $0x4,%esp
80105aa9:	6a 10                	push   $0x10
80105aab:	6a 00                	push   $0x0
80105aad:	50                   	push   %eax
80105aae:	e8 bd f5 ff ff       	call   80105070 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ab3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ab6:	6a 10                	push   $0x10
80105ab8:	ff 75 c4             	pushl  -0x3c(%ebp)
80105abb:	50                   	push   %eax
80105abc:	56                   	push   %esi
80105abd:	e8 9e bf ff ff       	call   80101a60 <writei>
80105ac2:	83 c4 20             	add    $0x20,%esp
80105ac5:	83 f8 10             	cmp    $0x10,%eax
80105ac8:	0f 85 eb 00 00 00    	jne    80105bb9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105ace:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ad3:	0f 84 97 00 00 00    	je     80105b70 <sys_unlink+0x180>
  iunlockput(dp);
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	56                   	push   %esi
80105add:	e8 2e be ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105ae2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ae7:	89 1c 24             	mov    %ebx,(%esp)
80105aea:	e8 e1 ba ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105aef:	89 1c 24             	mov    %ebx,(%esp)
80105af2:	e8 19 be ff ff       	call   80101910 <iunlockput>
  end_op();
80105af7:	e8 94 d1 ff ff       	call   80102c90 <end_op>
  return 0;
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	31 c0                	xor    %eax,%eax
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret    
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105b14:	76 8d                	jbe    80105aa3 <sys_unlink+0xb3>
80105b16:	bf 20 00 00 00       	mov    $0x20,%edi
80105b1b:	eb 0f                	jmp    80105b2c <sys_unlink+0x13c>
80105b1d:	8d 76 00             	lea    0x0(%esi),%esi
80105b20:	83 c7 10             	add    $0x10,%edi
80105b23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105b26:	0f 83 77 ff ff ff    	jae    80105aa3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b2c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b2f:	6a 10                	push   $0x10
80105b31:	57                   	push   %edi
80105b32:	50                   	push   %eax
80105b33:	53                   	push   %ebx
80105b34:	e8 27 be ff ff       	call   80101960 <readi>
80105b39:	83 c4 10             	add    $0x10,%esp
80105b3c:	83 f8 10             	cmp    $0x10,%eax
80105b3f:	75 5e                	jne    80105b9f <sys_unlink+0x1af>
    if(de.inum != 0)
80105b41:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b46:	74 d8                	je     80105b20 <sys_unlink+0x130>
    iunlockput(ip);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	53                   	push   %ebx
80105b4c:	e8 bf bd ff ff       	call   80101910 <iunlockput>
    goto bad;
80105b51:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105b54:	83 ec 0c             	sub    $0xc,%esp
80105b57:	56                   	push   %esi
80105b58:	e8 b3 bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105b5d:	e8 2e d1 ff ff       	call   80102c90 <end_op>
  return -1;
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6a:	eb 95                	jmp    80105b01 <sys_unlink+0x111>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105b70:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105b75:	83 ec 0c             	sub    $0xc,%esp
80105b78:	56                   	push   %esi
80105b79:	e8 52 ba ff ff       	call   801015d0 <iupdate>
80105b7e:	83 c4 10             	add    $0x10,%esp
80105b81:	e9 53 ff ff ff       	jmp    80105ad9 <sys_unlink+0xe9>
    return -1;
80105b86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8b:	e9 71 ff ff ff       	jmp    80105b01 <sys_unlink+0x111>
    end_op();
80105b90:	e8 fb d0 ff ff       	call   80102c90 <end_op>
    return -1;
80105b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9a:	e9 62 ff ff ff       	jmp    80105b01 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	68 dd 84 10 80       	push   $0x801084dd
80105ba7:	e8 e4 a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	68 cb 84 10 80       	push   $0x801084cb
80105bb4:	e8 d7 a7 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	68 ef 84 10 80       	push   $0x801084ef
80105bc1:	e8 ca a7 ff ff       	call   80100390 <panic>
80105bc6:	8d 76 00             	lea    0x0(%esi),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <sys_open>:

int
sys_open(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105bd9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bdc:	50                   	push   %eax
80105bdd:	6a 00                	push   $0x0
80105bdf:	e8 3c f8 ff ff       	call   80105420 <argstr>
80105be4:	83 c4 10             	add    $0x10,%esp
80105be7:	85 c0                	test   %eax,%eax
80105be9:	0f 88 1d 01 00 00    	js     80105d0c <sys_open+0x13c>
80105bef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf2:	83 ec 08             	sub    $0x8,%esp
80105bf5:	50                   	push   %eax
80105bf6:	6a 01                	push   $0x1
80105bf8:	e8 73 f7 ff ff       	call   80105370 <argint>
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	85 c0                	test   %eax,%eax
80105c02:	0f 88 04 01 00 00    	js     80105d0c <sys_open+0x13c>
    return -1;

  begin_op();
80105c08:	e8 13 d0 ff ff       	call   80102c20 <begin_op>

  if(omode & O_CREATE){
80105c0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c11:	0f 85 a9 00 00 00    	jne    80105cc0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c17:	83 ec 0c             	sub    $0xc,%esp
80105c1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105c1d:	e8 be c2 ff ff       	call   80101ee0 <namei>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	89 c6                	mov    %eax,%esi
80105c29:	0f 84 b2 00 00 00    	je     80105ce1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105c2f:	83 ec 0c             	sub    $0xc,%esp
80105c32:	50                   	push   %eax
80105c33:	e8 48 ba ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c38:	83 c4 10             	add    $0x10,%esp
80105c3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c40:	0f 84 aa 00 00 00    	je     80105cf0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c46:	e8 35 b1 ff ff       	call   80100d80 <filealloc>
80105c4b:	85 c0                	test   %eax,%eax
80105c4d:	89 c7                	mov    %eax,%edi
80105c4f:	0f 84 a6 00 00 00    	je     80105cfb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105c55:	e8 f6 e1 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c5a:	31 db                	xor    %ebx,%ebx
80105c5c:	eb 0e                	jmp    80105c6c <sys_open+0x9c>
80105c5e:	66 90                	xchg   %ax,%ax
80105c60:	83 c3 01             	add    $0x1,%ebx
80105c63:	83 fb 10             	cmp    $0x10,%ebx
80105c66:	0f 84 ac 00 00 00    	je     80105d18 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105c6c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c70:	85 d2                	test   %edx,%edx
80105c72:	75 ec                	jne    80105c60 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c74:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c77:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c7b:	56                   	push   %esi
80105c7c:	e8 df ba ff ff       	call   80101760 <iunlock>
  end_op();
80105c81:	e8 0a d0 ff ff       	call   80102c90 <end_op>

  f->type = FD_INODE;
80105c86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c8f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c92:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105c95:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c9c:	89 d0                	mov    %edx,%eax
80105c9e:	f7 d0                	not    %eax
80105ca0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ca3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ca6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ca9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb0:	89 d8                	mov    %ebx,%eax
80105cb2:	5b                   	pop    %ebx
80105cb3:	5e                   	pop    %esi
80105cb4:	5f                   	pop    %edi
80105cb5:	5d                   	pop    %ebp
80105cb6:	c3                   	ret    
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cc6:	31 c9                	xor    %ecx,%ecx
80105cc8:	6a 00                	push   $0x0
80105cca:	ba 02 00 00 00       	mov    $0x2,%edx
80105ccf:	e8 ec f7 ff ff       	call   801054c0 <create>
    if(ip == 0){
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105cd9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105cdb:	0f 85 65 ff ff ff    	jne    80105c46 <sys_open+0x76>
      end_op();
80105ce1:	e8 aa cf ff ff       	call   80102c90 <end_op>
      return -1;
80105ce6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ceb:	eb c0                	jmp    80105cad <sys_open+0xdd>
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cf0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105cf3:	85 c9                	test   %ecx,%ecx
80105cf5:	0f 84 4b ff ff ff    	je     80105c46 <sys_open+0x76>
    iunlockput(ip);
80105cfb:	83 ec 0c             	sub    $0xc,%esp
80105cfe:	56                   	push   %esi
80105cff:	e8 0c bc ff ff       	call   80101910 <iunlockput>
    end_op();
80105d04:	e8 87 cf ff ff       	call   80102c90 <end_op>
    return -1;
80105d09:	83 c4 10             	add    $0x10,%esp
80105d0c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d11:	eb 9a                	jmp    80105cad <sys_open+0xdd>
80105d13:	90                   	nop
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105d18:	83 ec 0c             	sub    $0xc,%esp
80105d1b:	57                   	push   %edi
80105d1c:	e8 1f b1 ff ff       	call   80100e40 <fileclose>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	eb d5                	jmp    80105cfb <sys_open+0x12b>
80105d26:	8d 76 00             	lea    0x0(%esi),%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d36:	e8 e5 ce ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3e:	83 ec 08             	sub    $0x8,%esp
80105d41:	50                   	push   %eax
80105d42:	6a 00                	push   $0x0
80105d44:	e8 d7 f6 ff ff       	call   80105420 <argstr>
80105d49:	83 c4 10             	add    $0x10,%esp
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	78 30                	js     80105d80 <sys_mkdir+0x50>
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d56:	31 c9                	xor    %ecx,%ecx
80105d58:	6a 00                	push   $0x0
80105d5a:	ba 01 00 00 00       	mov    $0x1,%edx
80105d5f:	e8 5c f7 ff ff       	call   801054c0 <create>
80105d64:	83 c4 10             	add    $0x10,%esp
80105d67:	85 c0                	test   %eax,%eax
80105d69:	74 15                	je     80105d80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d6b:	83 ec 0c             	sub    $0xc,%esp
80105d6e:	50                   	push   %eax
80105d6f:	e8 9c bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105d74:	e8 17 cf ff ff       	call   80102c90 <end_op>
  return 0;
80105d79:	83 c4 10             	add    $0x10,%esp
80105d7c:	31 c0                	xor    %eax,%eax
}
80105d7e:	c9                   	leave  
80105d7f:	c3                   	ret    
    end_op();
80105d80:	e8 0b cf ff ff       	call   80102c90 <end_op>
    return -1;
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d8a:	c9                   	leave  
80105d8b:	c3                   	ret    
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_mknod>:

int
sys_mknod(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d96:	e8 85 ce ff ff       	call   80102c20 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d9e:	83 ec 08             	sub    $0x8,%esp
80105da1:	50                   	push   %eax
80105da2:	6a 00                	push   $0x0
80105da4:	e8 77 f6 ff ff       	call   80105420 <argstr>
80105da9:	83 c4 10             	add    $0x10,%esp
80105dac:	85 c0                	test   %eax,%eax
80105dae:	78 60                	js     80105e10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105db0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db3:	83 ec 08             	sub    $0x8,%esp
80105db6:	50                   	push   %eax
80105db7:	6a 01                	push   $0x1
80105db9:	e8 b2 f5 ff ff       	call   80105370 <argint>
  if((argstr(0, &path)) < 0 ||
80105dbe:	83 c4 10             	add    $0x10,%esp
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	78 4b                	js     80105e10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc8:	83 ec 08             	sub    $0x8,%esp
80105dcb:	50                   	push   %eax
80105dcc:	6a 02                	push   $0x2
80105dce:	e8 9d f5 ff ff       	call   80105370 <argint>
     argint(1, &major) < 0 ||
80105dd3:	83 c4 10             	add    $0x10,%esp
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	78 36                	js     80105e10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105dda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105dde:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105de1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105de5:	ba 03 00 00 00       	mov    $0x3,%edx
80105dea:	50                   	push   %eax
80105deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dee:	e8 cd f6 ff ff       	call   801054c0 <create>
80105df3:	83 c4 10             	add    $0x10,%esp
80105df6:	85 c0                	test   %eax,%eax
80105df8:	74 16                	je     80105e10 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dfa:	83 ec 0c             	sub    $0xc,%esp
80105dfd:	50                   	push   %eax
80105dfe:	e8 0d bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105e03:	e8 88 ce ff ff       	call   80102c90 <end_op>
  return 0;
80105e08:	83 c4 10             	add    $0x10,%esp
80105e0b:	31 c0                	xor    %eax,%eax
}
80105e0d:	c9                   	leave  
80105e0e:	c3                   	ret    
80105e0f:	90                   	nop
    end_op();
80105e10:	e8 7b ce ff ff       	call   80102c90 <end_op>
    return -1;
80105e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1a:	c9                   	leave  
80105e1b:	c3                   	ret    
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_chdir>:

int
sys_chdir(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	56                   	push   %esi
80105e24:	53                   	push   %ebx
80105e25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e28:	e8 23 e0 ff ff       	call   80103e50 <myproc>
80105e2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e2f:	e8 ec cd ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e37:	83 ec 08             	sub    $0x8,%esp
80105e3a:	50                   	push   %eax
80105e3b:	6a 00                	push   $0x0
80105e3d:	e8 de f5 ff ff       	call   80105420 <argstr>
80105e42:	83 c4 10             	add    $0x10,%esp
80105e45:	85 c0                	test   %eax,%eax
80105e47:	78 77                	js     80105ec0 <sys_chdir+0xa0>
80105e49:	83 ec 0c             	sub    $0xc,%esp
80105e4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e4f:	e8 8c c0 ff ff       	call   80101ee0 <namei>
80105e54:	83 c4 10             	add    $0x10,%esp
80105e57:	85 c0                	test   %eax,%eax
80105e59:	89 c3                	mov    %eax,%ebx
80105e5b:	74 63                	je     80105ec0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	50                   	push   %eax
80105e61:	e8 1a b8 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105e66:	83 c4 10             	add    $0x10,%esp
80105e69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e6e:	75 30                	jne    80105ea0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	53                   	push   %ebx
80105e74:	e8 e7 b8 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105e79:	58                   	pop    %eax
80105e7a:	ff 76 68             	pushl  0x68(%esi)
80105e7d:	e8 2e b9 ff ff       	call   801017b0 <iput>
  end_op();
80105e82:	e8 09 ce ff ff       	call   80102c90 <end_op>
  curproc->cwd = ip;
80105e87:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	31 c0                	xor    %eax,%eax
}
80105e8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e92:	5b                   	pop    %ebx
80105e93:	5e                   	pop    %esi
80105e94:	5d                   	pop    %ebp
80105e95:	c3                   	ret    
80105e96:	8d 76 00             	lea    0x0(%esi),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	53                   	push   %ebx
80105ea4:	e8 67 ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105ea9:	e8 e2 cd ff ff       	call   80102c90 <end_op>
    return -1;
80105eae:	83 c4 10             	add    $0x10,%esp
80105eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb6:	eb d7                	jmp    80105e8f <sys_chdir+0x6f>
80105eb8:	90                   	nop
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ec0:	e8 cb cd ff ff       	call   80102c90 <end_op>
    return -1;
80105ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eca:	eb c3                	jmp    80105e8f <sys_chdir+0x6f>
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_exec>:

int
sys_exec(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ed6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105edc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ee2:	50                   	push   %eax
80105ee3:	6a 00                	push   $0x0
80105ee5:	e8 36 f5 ff ff       	call   80105420 <argstr>
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	85 c0                	test   %eax,%eax
80105eef:	0f 88 87 00 00 00    	js     80105f7c <sys_exec+0xac>
80105ef5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105efb:	83 ec 08             	sub    $0x8,%esp
80105efe:	50                   	push   %eax
80105eff:	6a 01                	push   $0x1
80105f01:	e8 6a f4 ff ff       	call   80105370 <argint>
80105f06:	83 c4 10             	add    $0x10,%esp
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	78 6f                	js     80105f7c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f0d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f13:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105f16:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f18:	68 80 00 00 00       	push   $0x80
80105f1d:	6a 00                	push   $0x0
80105f1f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f25:	50                   	push   %eax
80105f26:	e8 45 f1 ff ff       	call   80105070 <memset>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	eb 2c                	jmp    80105f5c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105f30:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f36:	85 c0                	test   %eax,%eax
80105f38:	74 56                	je     80105f90 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f3a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f40:	83 ec 08             	sub    $0x8,%esp
80105f43:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f46:	52                   	push   %edx
80105f47:	50                   	push   %eax
80105f48:	e8 b3 f3 ff ff       	call   80105300 <fetchstr>
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	85 c0                	test   %eax,%eax
80105f52:	78 28                	js     80105f7c <sys_exec+0xac>
  for(i=0;; i++){
80105f54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f57:	83 fb 20             	cmp    $0x20,%ebx
80105f5a:	74 20                	je     80105f7c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f5c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f62:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f69:	83 ec 08             	sub    $0x8,%esp
80105f6c:	57                   	push   %edi
80105f6d:	01 f0                	add    %esi,%eax
80105f6f:	50                   	push   %eax
80105f70:	e8 4b f3 ff ff       	call   801052c0 <fetchint>
80105f75:	83 c4 10             	add    $0x10,%esp
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	79 b4                	jns    80105f30 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f96:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105f99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105fa0:	00 00 00 00 
  return exec(path, argv);
80105fa4:	50                   	push   %eax
80105fa5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105fab:	e8 60 aa ff ff       	call   80100a10 <exec>
80105fb0:	83 c4 10             	add    $0x10,%esp
}
80105fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb6:	5b                   	pop    %ebx
80105fb7:	5e                   	pop    %esi
80105fb8:	5f                   	pop    %edi
80105fb9:	5d                   	pop    %ebp
80105fba:	c3                   	ret    
80105fbb:	90                   	nop
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <sys_pipe>:

int
sys_pipe(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fc6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fc9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fcc:	6a 08                	push   $0x8
80105fce:	50                   	push   %eax
80105fcf:	6a 00                	push   $0x0
80105fd1:	e8 ea f3 ff ff       	call   801053c0 <argptr>
80105fd6:	83 c4 10             	add    $0x10,%esp
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	0f 88 ae 00 00 00    	js     8010608f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105fe1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fe4:	83 ec 08             	sub    $0x8,%esp
80105fe7:	50                   	push   %eax
80105fe8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105feb:	50                   	push   %eax
80105fec:	e8 cf d2 ff ff       	call   801032c0 <pipealloc>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	0f 88 93 00 00 00    	js     8010608f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ffc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105fff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106001:	e8 4a de ff ff       	call   80103e50 <myproc>
80106006:	eb 10                	jmp    80106018 <sys_pipe+0x58>
80106008:	90                   	nop
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106010:	83 c3 01             	add    $0x1,%ebx
80106013:	83 fb 10             	cmp    $0x10,%ebx
80106016:	74 60                	je     80106078 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106018:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010601c:	85 f6                	test   %esi,%esi
8010601e:	75 f0                	jne    80106010 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106020:	8d 73 08             	lea    0x8(%ebx),%esi
80106023:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106027:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010602a:	e8 21 de ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010602f:	31 d2                	xor    %edx,%edx
80106031:	eb 0d                	jmp    80106040 <sys_pipe+0x80>
80106033:	90                   	nop
80106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106038:	83 c2 01             	add    $0x1,%edx
8010603b:	83 fa 10             	cmp    $0x10,%edx
8010603e:	74 28                	je     80106068 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106040:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106044:	85 c9                	test   %ecx,%ecx
80106046:	75 f0                	jne    80106038 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106048:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010604c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010604f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106051:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106054:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106057:	31 c0                	xor    %eax,%eax
}
80106059:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010605c:	5b                   	pop    %ebx
8010605d:	5e                   	pop    %esi
8010605e:	5f                   	pop    %edi
8010605f:	5d                   	pop    %ebp
80106060:	c3                   	ret    
80106061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106068:	e8 e3 dd ff ff       	call   80103e50 <myproc>
8010606d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106074:	00 
80106075:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106078:	83 ec 0c             	sub    $0xc,%esp
8010607b:	ff 75 e0             	pushl  -0x20(%ebp)
8010607e:	e8 bd ad ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106083:	58                   	pop    %eax
80106084:	ff 75 e4             	pushl  -0x1c(%ebp)
80106087:	e8 b4 ad ff ff       	call   80100e40 <fileclose>
    return -1;
8010608c:	83 c4 10             	add    $0x10,%esp
8010608f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106094:	eb c3                	jmp    80106059 <sys_pipe+0x99>
80106096:	66 90                	xchg   %ax,%ax
80106098:	66 90                	xchg   %ax,%ax
8010609a:	66 90                	xchg   %ax,%ax
8010609c:	66 90                	xchg   %ax,%ax
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801060a3:	5d                   	pop    %ebp
  return fork();
801060a4:	e9 a7 df ff ff       	jmp    80104050 <fork>
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_exit>:

int
sys_exit(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801060b6:	e8 15 e5 ff ff       	call   801045d0 <exit>
  return 0;  // not reached
}
801060bb:	31 c0                	xor    %eax,%eax
801060bd:	c9                   	leave  
801060be:	c3                   	ret    
801060bf:	90                   	nop

801060c0 <sys_wait>:

int
sys_wait(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801060c3:	5d                   	pop    %ebp
  return wait();
801060c4:	e9 47 e7 ff ff       	jmp    80104810 <wait>
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_kill>:

int
sys_kill(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d9:	50                   	push   %eax
801060da:	6a 00                	push   $0x0
801060dc:	e8 8f f2 ff ff       	call   80105370 <argint>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	85 c0                	test   %eax,%eax
801060e6:	78 18                	js     80106100 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060e8:	83 ec 0c             	sub    $0xc,%esp
801060eb:	ff 75 f4             	pushl  -0xc(%ebp)
801060ee:	e8 3d ea ff ff       	call   80104b30 <kill>
801060f3:	83 c4 10             	add    $0x10,%esp
}
801060f6:	c9                   	leave  
801060f7:	c3                   	ret    
801060f8:	90                   	nop
801060f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106105:	c9                   	leave  
80106106:	c3                   	ret    
80106107:	89 f6                	mov    %esi,%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106110 <sys_getpid>:

int
sys_getpid(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106116:	e8 35 dd ff ff       	call   80103e50 <myproc>
8010611b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010611e:	c9                   	leave  
8010611f:	c3                   	ret    

80106120 <sys_sbrk>:

int
sys_sbrk(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106124:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106127:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010612a:	50                   	push   %eax
8010612b:	6a 00                	push   $0x0
8010612d:	e8 3e f2 ff ff       	call   80105370 <argint>
80106132:	83 c4 10             	add    $0x10,%esp
80106135:	85 c0                	test   %eax,%eax
80106137:	78 27                	js     80106160 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106139:	e8 12 dd ff ff       	call   80103e50 <myproc>
  if(growproc(n) < 0)
8010613e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106141:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106143:	ff 75 f4             	pushl  -0xc(%ebp)
80106146:	e8 85 de ff ff       	call   80103fd0 <growproc>
8010614b:	83 c4 10             	add    $0x10,%esp
8010614e:	85 c0                	test   %eax,%eax
80106150:	78 0e                	js     80106160 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106152:	89 d8                	mov    %ebx,%eax
80106154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106157:	c9                   	leave  
80106158:	c3                   	ret    
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106160:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106165:	eb eb                	jmp    80106152 <sys_sbrk+0x32>
80106167:	89 f6                	mov    %esi,%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106170 <sys_sleep>:

int
sys_sleep(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106174:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106177:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010617a:	50                   	push   %eax
8010617b:	6a 00                	push   $0x0
8010617d:	e8 ee f1 ff ff       	call   80105370 <argint>
80106182:	83 c4 10             	add    $0x10,%esp
80106185:	85 c0                	test   %eax,%eax
80106187:	0f 88 8a 00 00 00    	js     80106217 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	68 40 60 11 80       	push   $0x80116040
80106195:	e8 c6 ed ff ff       	call   80104f60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010619a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010619d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801061a0:	8b 1d 80 68 11 80    	mov    0x80116880,%ebx
  while(ticks - ticks0 < n){
801061a6:	85 d2                	test   %edx,%edx
801061a8:	75 27                	jne    801061d1 <sys_sleep+0x61>
801061aa:	eb 54                	jmp    80106200 <sys_sleep+0x90>
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061b0:	83 ec 08             	sub    $0x8,%esp
801061b3:	68 40 60 11 80       	push   $0x80116040
801061b8:	68 80 68 11 80       	push   $0x80116880
801061bd:	e8 8e e5 ff ff       	call   80104750 <sleep>
  while(ticks - ticks0 < n){
801061c2:	a1 80 68 11 80       	mov    0x80116880,%eax
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	29 d8                	sub    %ebx,%eax
801061cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061cf:	73 2f                	jae    80106200 <sys_sleep+0x90>
    if(myproc()->killed){
801061d1:	e8 7a dc ff ff       	call   80103e50 <myproc>
801061d6:	8b 40 24             	mov    0x24(%eax),%eax
801061d9:	85 c0                	test   %eax,%eax
801061db:	74 d3                	je     801061b0 <sys_sleep+0x40>
      release(&tickslock);
801061dd:	83 ec 0c             	sub    $0xc,%esp
801061e0:	68 40 60 11 80       	push   $0x80116040
801061e5:	e8 36 ee ff ff       	call   80105020 <release>
      return -1;
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801061f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106200:	83 ec 0c             	sub    $0xc,%esp
80106203:	68 40 60 11 80       	push   $0x80116040
80106208:	e8 13 ee ff ff       	call   80105020 <release>
  return 0;
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	31 c0                	xor    %eax,%eax
}
80106212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106215:	c9                   	leave  
80106216:	c3                   	ret    
    return -1;
80106217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621c:	eb f4                	jmp    80106212 <sys_sleep+0xa2>
8010621e:	66 90                	xchg   %ax,%ax

80106220 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	53                   	push   %ebx
80106224:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106227:	68 40 60 11 80       	push   $0x80116040
8010622c:	e8 2f ed ff ff       	call   80104f60 <acquire>
  xticks = ticks;
80106231:	8b 1d 80 68 11 80    	mov    0x80116880,%ebx
  release(&tickslock);
80106237:	c7 04 24 40 60 11 80 	movl   $0x80116040,(%esp)
8010623e:	e8 dd ed ff ff       	call   80105020 <release>
  return xticks;
}
80106243:	89 d8                	mov    %ebx,%eax
80106245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106248:	c9                   	leave  
80106249:	c3                   	ret    
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106250 <sys_draw>:

int
sys_draw(void)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
  void* buf;
  uint size;

  argptr(0, (void*)&buf, sizeof(buf));
80106255:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  argptr(1, (void*)&size, sizeof(size));
  char text[] = "\n\
8010625b:	be 00 85 10 80       	mov    $0x80108500,%esi
{
80106260:	81 ec c4 00 00 00    	sub    $0xc4,%esp
  argptr(0, (void*)&buf, sizeof(buf));
80106266:	6a 04                	push   $0x4
80106268:	50                   	push   %eax
80106269:	6a 00                	push   $0x0
8010626b:	e8 50 f1 ff ff       	call   801053c0 <argptr>
  argptr(1, (void*)&size, sizeof(size));
80106270:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
80106276:	83 c4 0c             	add    $0xc,%esp
80106279:	6a 04                	push   $0x4
8010627b:	50                   	push   %eax
8010627c:	6a 01                	push   $0x1
8010627e:	e8 3d f1 ff ff       	call   801053c0 <argptr>
		     # ###### #    # # #\n\
		#    # #    # #    # # #\n\
		 ####  #    # #    # # ######\n\n";
		 
		 
  if(sizeof(text)>size)
80106283:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  char text[] = "\n\
80106289:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  if(sizeof(text)>size)
8010628f:	83 c4 10             	add    $0x10,%esp
  char text[] = "\n\
80106292:	b9 2b 00 00 00       	mov    $0x2b,%ecx
80106297:	89 c7                	mov    %eax,%edi
  if(sizeof(text)>size)
80106299:	81 fa ab 00 00 00    	cmp    $0xab,%edx
  char text[] = "\n\
8010629f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(sizeof(text)>size)
801062a1:	76 25                	jbe    801062c8 <sys_draw+0x78>
    return -1;

  strncpy((char *)buf, text, size);
801062a3:	83 ec 04             	sub    $0x4,%esp
801062a6:	52                   	push   %edx
801062a7:	50                   	push   %eax
801062a8:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
801062ae:	e8 3d ef ff ff       	call   801051f0 <strncpy>
  return sizeof(text);
801062b3:	83 c4 10             	add    $0x10,%esp
801062b6:	b8 ac 00 00 00       	mov    $0xac,%eax
}
801062bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062be:	5e                   	pop    %esi
801062bf:	5f                   	pop    %edi
801062c0:	5d                   	pop    %ebp
801062c1:	c3                   	ret    
801062c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cd:	eb ec                	jmp    801062bb <sys_draw+0x6b>

801062cf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801062cf:	1e                   	push   %ds
  pushl %es
801062d0:	06                   	push   %es
  pushl %fs
801062d1:	0f a0                	push   %fs
  pushl %gs
801062d3:	0f a8                	push   %gs
  pushal
801062d5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801062d6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801062da:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801062dc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801062de:	54                   	push   %esp
  call trap
801062df:	e8 7c 01 00 00       	call   80106460 <trap>
  addl $4, %esp
801062e4:	83 c4 04             	add    $0x4,%esp

801062e7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062e7:	61                   	popa   
  popl %gs
801062e8:	0f a9                	pop    %gs
  popl %fs
801062ea:	0f a1                	pop    %fs
  popl %es
801062ec:	07                   	pop    %es
  popl %ds
801062ed:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062ee:	83 c4 08             	add    $0x8,%esp
  iret
801062f1:	cf                   	iret   
801062f2:	66 90                	xchg   %ax,%ax
801062f4:	66 90                	xchg   %ax,%ax
801062f6:	66 90                	xchg   %ax,%ax
801062f8:	66 90                	xchg   %ax,%ax
801062fa:	66 90                	xchg   %ax,%ax
801062fc:	66 90                	xchg   %ax,%ax
801062fe:	66 90                	xchg   %ax,%ax

80106300 <handlePageFault>:
uint ticks;

struct spinlock swap_in_lock;


void handlePageFault(){
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	56                   	push   %esi
80106304:	53                   	push   %ebx
  struct proc *p=myproc();
80106305:	e8 46 db ff ff       	call   80103e50 <myproc>
8010630a:	89 c3                	mov    %eax,%ebx

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010630c:	0f 20 d6             	mov    %cr2,%esi
  int addr=rcr2();
  acquire(&swap_in_lock);
8010630f:	83 ec 0c             	sub    $0xc,%esp
80106312:	68 00 60 11 80       	push   $0x80116000
80106317:	e8 44 ec ff ff       	call   80104f60 <acquire>
  sleep(p,&swap_in_lock);
8010631c:	5a                   	pop    %edx
8010631d:	59                   	pop    %ecx
8010631e:	68 00 60 11 80       	push   $0x80116000
80106323:	53                   	push   %ebx
80106324:	e8 27 e4 ff ff       	call   80104750 <sleep>
  pde_t *pde = &(p->pgdir)[PDX(addr)];
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106329:	8b 43 04             	mov    0x4(%ebx),%eax
  pde_t *pde = &(p->pgdir)[PDX(addr)];
8010632c:	89 f2                	mov    %esi,%edx

  if((pgtab[PTX(addr)])&0x080){
8010632e:	83 c4 10             	add    $0x10,%esp
  pde_t *pde = &(p->pgdir)[PDX(addr)];
80106331:	c1 ea 16             	shr    $0x16,%edx
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106334:	8b 04 90             	mov    (%eax,%edx,4),%eax
  if((pgtab[PTX(addr)])&0x080){
80106337:	89 f2                	mov    %esi,%edx
80106339:	c1 ea 0c             	shr    $0xc,%edx
8010633c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106342:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((pgtab[PTX(addr)])&0x080){
80106347:	f6 84 90 00 00 00 80 	testb  $0x80,-0x80000000(%eax,%edx,4)
8010634e:	80 
8010634f:	74 1f                	je     80106370 <handlePageFault+0x70>
    p->addr = addr;
    rpush2(p);
80106351:	83 ec 0c             	sub    $0xc,%esp
    p->addr = addr;
80106354:	89 73 7c             	mov    %esi,0x7c(%ebx)
    rpush2(p);
80106357:	53                   	push   %ebx
80106358:	e8 63 d6 ff ff       	call   801039c0 <rpush2>
    if(!swap_in_process_exists){
8010635d:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	74 17                	je     80106380 <handlePageFault+0x80>
    }
  }
  else {
    exit();
  }
}
80106369:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010636c:	5b                   	pop    %ebx
8010636d:	5e                   	pop    %esi
8010636e:	5d                   	pop    %ebp
8010636f:	c3                   	ret    
80106370:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106373:	5b                   	pop    %ebx
80106374:	5e                   	pop    %esi
80106375:	5d                   	pop    %ebp
    exit();
80106376:	e9 55 e2 ff ff       	jmp    801045d0 <exit>
8010637b:	90                   	nop
8010637c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      create_kernel_process("swap_in_process", &swap_in_process_function);
80106380:	83 ec 08             	sub    $0x8,%esp
      swap_in_process_exists=1;
80106383:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
8010638a:	00 00 00 
      create_kernel_process("swap_in_process", &swap_in_process_function);
8010638d:	68 60 49 10 80       	push   $0x80104960
80106392:	68 e1 82 10 80       	push   $0x801082e1
80106397:	e8 d4 e8 ff ff       	call   80104c70 <create_kernel_process>
8010639c:	83 c4 10             	add    $0x10,%esp
}
8010639f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063a2:	5b                   	pop    %ebx
801063a3:	5e                   	pop    %esi
801063a4:	5d                   	pop    %ebp
801063a5:	c3                   	ret    
801063a6:	8d 76 00             	lea    0x0(%esi),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <tvinit>:


void
tvinit(void)
{
801063b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801063b1:	31 c0                	xor    %eax,%eax
{
801063b3:	89 e5                	mov    %esp,%ebp
801063b5:	83 ec 08             	sub    $0x8,%esp
801063b8:	90                   	nop
801063b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063c0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801063c7:	c7 04 c5 82 60 11 80 	movl   $0x8e000008,-0x7fee9f7e(,%eax,8)
801063ce:	08 00 00 8e 
801063d2:	66 89 14 c5 80 60 11 	mov    %dx,-0x7fee9f80(,%eax,8)
801063d9:	80 
801063da:	c1 ea 10             	shr    $0x10,%edx
801063dd:	66 89 14 c5 86 60 11 	mov    %dx,-0x7fee9f7a(,%eax,8)
801063e4:	80 
  for(i = 0; i < 256; i++)
801063e5:	83 c0 01             	add    $0x1,%eax
801063e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801063ed:	75 d1                	jne    801063c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063ef:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801063f4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063f7:	c7 05 82 62 11 80 08 	movl   $0xef000008,0x80116282
801063fe:	00 00 ef 
  initlock(&tickslock, "time");
80106401:	68 ac 85 10 80       	push   $0x801085ac
80106406:	68 40 60 11 80       	push   $0x80116040
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010640b:	66 a3 80 62 11 80    	mov    %ax,0x80116280
80106411:	c1 e8 10             	shr    $0x10,%eax
80106414:	66 a3 86 62 11 80    	mov    %ax,0x80116286
  initlock(&tickslock, "time");
8010641a:	e8 01 ea ff ff       	call   80104e20 <initlock>
}
8010641f:	83 c4 10             	add    $0x10,%esp
80106422:	c9                   	leave  
80106423:	c3                   	ret    
80106424:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010642a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106430 <idtinit>:

void
idtinit(void)
{
80106430:	55                   	push   %ebp
  pd[0] = size-1;
80106431:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106436:	89 e5                	mov    %esp,%ebp
80106438:	83 ec 10             	sub    $0x10,%esp
8010643b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010643f:	b8 80 60 11 80       	mov    $0x80116080,%eax
80106444:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106448:	c1 e8 10             	shr    $0x10,%eax
8010644b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010644f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106452:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106455:	c9                   	leave  
80106456:	c3                   	ret    
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106460 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	57                   	push   %edi
80106464:	56                   	push   %esi
80106465:	53                   	push   %ebx
80106466:	83 ec 1c             	sub    $0x1c,%esp
80106469:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010646c:	8b 47 30             	mov    0x30(%edi),%eax
8010646f:	83 f8 40             	cmp    $0x40,%eax
80106472:	0f 84 d8 00 00 00    	je     80106550 <trap+0xf0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106478:	83 e8 0e             	sub    $0xe,%eax
8010647b:	83 f8 31             	cmp    $0x31,%eax
8010647e:	77 10                	ja     80106490 <trap+0x30>
80106480:	ff 24 85 54 86 10 80 	jmp    *-0x7fef79ac(,%eax,4)
80106487:	89 f6                	mov    %esi,%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_PGFLT:
    handlePageFault();
  break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106490:	e8 bb d9 ff ff       	call   80103e50 <myproc>
80106495:	85 c0                	test   %eax,%eax
80106497:	8b 5f 38             	mov    0x38(%edi),%ebx
8010649a:	0f 84 ca 01 00 00    	je     8010666a <trap+0x20a>
801064a0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801064a4:	0f 84 c0 01 00 00    	je     8010666a <trap+0x20a>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801064aa:	0f 20 d1             	mov    %cr2,%ecx
801064ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064b0:	e8 4b d6 ff ff       	call   80103b00 <cpuid>
801064b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801064b8:	8b 47 34             	mov    0x34(%edi),%eax
801064bb:	8b 77 30             	mov    0x30(%edi),%esi
801064be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801064c1:	e8 8a d9 ff ff       	call   80103e50 <myproc>
801064c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801064c9:	e8 82 d9 ff ff       	call   80103e50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064d4:	51                   	push   %ecx
801064d5:	53                   	push   %ebx
801064d6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801064d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064da:	ff 75 e4             	pushl  -0x1c(%ebp)
801064dd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801064de:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064e1:	52                   	push   %edx
801064e2:	ff 70 10             	pushl  0x10(%eax)
801064e5:	68 10 86 10 80       	push   $0x80108610
801064ea:	e8 71 a1 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801064ef:	83 c4 20             	add    $0x20,%esp
801064f2:	e8 59 d9 ff ff       	call   80103e50 <myproc>
801064f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064fe:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106500:	e8 4b d9 ff ff       	call   80103e50 <myproc>
80106505:	85 c0                	test   %eax,%eax
80106507:	74 1d                	je     80106526 <trap+0xc6>
80106509:	e8 42 d9 ff ff       	call   80103e50 <myproc>
8010650e:	8b 50 24             	mov    0x24(%eax),%edx
80106511:	85 d2                	test   %edx,%edx
80106513:	74 11                	je     80106526 <trap+0xc6>
80106515:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106519:	83 e0 03             	and    $0x3,%eax
8010651c:	66 83 f8 03          	cmp    $0x3,%ax
80106520:	0f 84 3a 01 00 00    	je     80106660 <trap+0x200>
  // if(myproc() && myproc()->state == RUNNING &&
  //    tf->trapno == T_IRQ0+IRQ_TIMER)
  //   yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106526:	e8 25 d9 ff ff       	call   80103e50 <myproc>
8010652b:	85 c0                	test   %eax,%eax
8010652d:	74 19                	je     80106548 <trap+0xe8>
8010652f:	e8 1c d9 ff ff       	call   80103e50 <myproc>
80106534:	8b 40 24             	mov    0x24(%eax),%eax
80106537:	85 c0                	test   %eax,%eax
80106539:	74 0d                	je     80106548 <trap+0xe8>
8010653b:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010653f:	83 e0 03             	and    $0x3,%eax
80106542:	66 83 f8 03          	cmp    $0x3,%ax
80106546:	74 31                	je     80106579 <trap+0x119>
    exit();
}
80106548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010654b:	5b                   	pop    %ebx
8010654c:	5e                   	pop    %esi
8010654d:	5f                   	pop    %edi
8010654e:	5d                   	pop    %ebp
8010654f:	c3                   	ret    
    if(myproc()->killed)
80106550:	e8 fb d8 ff ff       	call   80103e50 <myproc>
80106555:	8b 58 24             	mov    0x24(%eax),%ebx
80106558:	85 db                	test   %ebx,%ebx
8010655a:	0f 85 f0 00 00 00    	jne    80106650 <trap+0x1f0>
    myproc()->tf = tf;
80106560:	e8 eb d8 ff ff       	call   80103e50 <myproc>
80106565:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106568:	e8 f3 ee ff ff       	call   80105460 <syscall>
    if(myproc()->killed)
8010656d:	e8 de d8 ff ff       	call   80103e50 <myproc>
80106572:	8b 48 24             	mov    0x24(%eax),%ecx
80106575:	85 c9                	test   %ecx,%ecx
80106577:	74 cf                	je     80106548 <trap+0xe8>
}
80106579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010657c:	5b                   	pop    %ebx
8010657d:	5e                   	pop    %esi
8010657e:	5f                   	pop    %edi
8010657f:	5d                   	pop    %ebp
      exit();
80106580:	e9 4b e0 ff ff       	jmp    801045d0 <exit>
80106585:	8d 76 00             	lea    0x0(%esi),%esi
    ideintr();
80106588:	e8 f3 ba ff ff       	call   80102080 <ideintr>
    lapiceoi();
8010658d:	e8 3e c2 ff ff       	call   801027d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106592:	e8 b9 d8 ff ff       	call   80103e50 <myproc>
80106597:	85 c0                	test   %eax,%eax
80106599:	0f 85 6a ff ff ff    	jne    80106509 <trap+0xa9>
8010659f:	eb 85                	jmp    80106526 <trap+0xc6>
801065a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    handlePageFault();
801065a8:	e8 53 fd ff ff       	call   80106300 <handlePageFault>
  break;
801065ad:	e9 4e ff ff ff       	jmp    80106500 <trap+0xa0>
801065b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801065b8:	e8 43 d5 ff ff       	call   80103b00 <cpuid>
801065bd:	85 c0                	test   %eax,%eax
801065bf:	75 cc                	jne    8010658d <trap+0x12d>
      acquire(&tickslock);
801065c1:	83 ec 0c             	sub    $0xc,%esp
801065c4:	68 40 60 11 80       	push   $0x80116040
801065c9:	e8 92 e9 ff ff       	call   80104f60 <acquire>
      wakeup(&ticks);
801065ce:	c7 04 24 80 68 11 80 	movl   $0x80116880,(%esp)
      ticks++;
801065d5:	83 05 80 68 11 80 01 	addl   $0x1,0x80116880
      wakeup(&ticks);
801065dc:	e8 1f e3 ff ff       	call   80104900 <wakeup>
      release(&tickslock);
801065e1:	c7 04 24 40 60 11 80 	movl   $0x80116040,(%esp)
801065e8:	e8 33 ea ff ff       	call   80105020 <release>
801065ed:	83 c4 10             	add    $0x10,%esp
801065f0:	eb 9b                	jmp    8010658d <trap+0x12d>
801065f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801065f8:	e8 93 c0 ff ff       	call   80102690 <kbdintr>
    lapiceoi();
801065fd:	e8 ce c1 ff ff       	call   801027d0 <lapiceoi>
    break;
80106602:	e9 f9 fe ff ff       	jmp    80106500 <trap+0xa0>
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106610:	e8 fb 01 00 00       	call   80106810 <uartintr>
    lapiceoi();
80106615:	e8 b6 c1 ff ff       	call   801027d0 <lapiceoi>
    break;
8010661a:	e9 e1 fe ff ff       	jmp    80106500 <trap+0xa0>
8010661f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106620:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106624:	8b 77 38             	mov    0x38(%edi),%esi
80106627:	e8 d4 d4 ff ff       	call   80103b00 <cpuid>
8010662c:	56                   	push   %esi
8010662d:	53                   	push   %ebx
8010662e:	50                   	push   %eax
8010662f:	68 b8 85 10 80       	push   $0x801085b8
80106634:	e8 27 a0 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106639:	e8 92 c1 ff ff       	call   801027d0 <lapiceoi>
    break;
8010663e:	83 c4 10             	add    $0x10,%esp
80106641:	e9 ba fe ff ff       	jmp    80106500 <trap+0xa0>
80106646:	8d 76 00             	lea    0x0(%esi),%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106650:	e8 7b df ff ff       	call   801045d0 <exit>
80106655:	e9 06 ff ff ff       	jmp    80106560 <trap+0x100>
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106660:	e8 6b df ff ff       	call   801045d0 <exit>
80106665:	e9 bc fe ff ff       	jmp    80106526 <trap+0xc6>
8010666a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010666d:	e8 8e d4 ff ff       	call   80103b00 <cpuid>
80106672:	83 ec 0c             	sub    $0xc,%esp
80106675:	56                   	push   %esi
80106676:	53                   	push   %ebx
80106677:	50                   	push   %eax
80106678:	ff 77 30             	pushl  0x30(%edi)
8010667b:	68 dc 85 10 80       	push   $0x801085dc
80106680:	e8 db 9f ff ff       	call   80100660 <cprintf>
      panic("trap");
80106685:	83 c4 14             	add    $0x14,%esp
80106688:	68 b1 85 10 80       	push   $0x801085b1
8010668d:	e8 fe 9c ff ff       	call   80100390 <panic>
80106692:	66 90                	xchg   %ax,%ax
80106694:	66 90                	xchg   %ax,%ax
80106696:	66 90                	xchg   %ax,%ax
80106698:	66 90                	xchg   %ax,%ax
8010669a:	66 90                	xchg   %ax,%ax
8010669c:	66 90                	xchg   %ax,%ax
8010669e:	66 90                	xchg   %ax,%ax

801066a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801066a0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
{
801066a5:	55                   	push   %ebp
801066a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801066a8:	85 c0                	test   %eax,%eax
801066aa:	74 1c                	je     801066c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801066b2:	a8 01                	test   $0x1,%al
801066b4:	74 12                	je     801066c8 <uartgetc+0x28>
801066b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801066bc:	0f b6 c0             	movzbl %al,%eax
}
801066bf:	5d                   	pop    %ebp
801066c0:	c3                   	ret    
801066c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066cd:	5d                   	pop    %ebp
801066ce:	c3                   	ret    
801066cf:	90                   	nop

801066d0 <uartputc.part.0>:
uartputc(int c)
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	89 c7                	mov    %eax,%edi
801066d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801066dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801066e2:	83 ec 0c             	sub    $0xc,%esp
801066e5:	eb 1b                	jmp    80106702 <uartputc.part.0+0x32>
801066e7:	89 f6                	mov    %esi,%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801066f0:	83 ec 0c             	sub    $0xc,%esp
801066f3:	6a 0a                	push   $0xa
801066f5:	e8 f6 c0 ff ff       	call   801027f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066fa:	83 c4 10             	add    $0x10,%esp
801066fd:	83 eb 01             	sub    $0x1,%ebx
80106700:	74 07                	je     80106709 <uartputc.part.0+0x39>
80106702:	89 f2                	mov    %esi,%edx
80106704:	ec                   	in     (%dx),%al
80106705:	a8 20                	test   $0x20,%al
80106707:	74 e7                	je     801066f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106709:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010670e:	89 f8                	mov    %edi,%eax
80106710:	ee                   	out    %al,(%dx)
}
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	5b                   	pop    %ebx
80106715:	5e                   	pop    %esi
80106716:	5f                   	pop    %edi
80106717:	5d                   	pop    %ebp
80106718:	c3                   	ret    
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106720 <uartinit>:
{
80106720:	55                   	push   %ebp
80106721:	31 c9                	xor    %ecx,%ecx
80106723:	89 c8                	mov    %ecx,%eax
80106725:	89 e5                	mov    %esp,%ebp
80106727:	57                   	push   %edi
80106728:	56                   	push   %esi
80106729:	53                   	push   %ebx
8010672a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010672f:	89 da                	mov    %ebx,%edx
80106731:	83 ec 0c             	sub    $0xc,%esp
80106734:	ee                   	out    %al,(%dx)
80106735:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010673a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010673f:	89 fa                	mov    %edi,%edx
80106741:	ee                   	out    %al,(%dx)
80106742:	b8 0c 00 00 00       	mov    $0xc,%eax
80106747:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010674c:	ee                   	out    %al,(%dx)
8010674d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106752:	89 c8                	mov    %ecx,%eax
80106754:	89 f2                	mov    %esi,%edx
80106756:	ee                   	out    %al,(%dx)
80106757:	b8 03 00 00 00       	mov    $0x3,%eax
8010675c:	89 fa                	mov    %edi,%edx
8010675e:	ee                   	out    %al,(%dx)
8010675f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106764:	89 c8                	mov    %ecx,%eax
80106766:	ee                   	out    %al,(%dx)
80106767:	b8 01 00 00 00       	mov    $0x1,%eax
8010676c:	89 f2                	mov    %esi,%edx
8010676e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010676f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106774:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106775:	3c ff                	cmp    $0xff,%al
80106777:	74 5a                	je     801067d3 <uartinit+0xb3>
  uart = 1;
80106779:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
80106780:	00 00 00 
80106783:	89 da                	mov    %ebx,%edx
80106785:	ec                   	in     (%dx),%al
80106786:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010678b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010678c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010678f:	bb 1c 87 10 80       	mov    $0x8010871c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106794:	6a 00                	push   $0x0
80106796:	6a 04                	push   $0x4
80106798:	e8 33 bb ff ff       	call   801022d0 <ioapicenable>
8010679d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801067a0:	b8 78 00 00 00       	mov    $0x78,%eax
801067a5:	eb 13                	jmp    801067ba <uartinit+0x9a>
801067a7:	89 f6                	mov    %esi,%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801067b0:	83 c3 01             	add    $0x1,%ebx
801067b3:	0f be 03             	movsbl (%ebx),%eax
801067b6:	84 c0                	test   %al,%al
801067b8:	74 19                	je     801067d3 <uartinit+0xb3>
  if(!uart)
801067ba:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
801067c0:	85 d2                	test   %edx,%edx
801067c2:	74 ec                	je     801067b0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801067c4:	83 c3 01             	add    $0x1,%ebx
801067c7:	e8 04 ff ff ff       	call   801066d0 <uartputc.part.0>
801067cc:	0f be 03             	movsbl (%ebx),%eax
801067cf:	84 c0                	test   %al,%al
801067d1:	75 e7                	jne    801067ba <uartinit+0x9a>
}
801067d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067d6:	5b                   	pop    %ebx
801067d7:	5e                   	pop    %esi
801067d8:	5f                   	pop    %edi
801067d9:	5d                   	pop    %ebp
801067da:	c3                   	ret    
801067db:	90                   	nop
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067e0 <uartputc>:
  if(!uart)
801067e0:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
{
801067e6:	55                   	push   %ebp
801067e7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801067e9:	85 d2                	test   %edx,%edx
{
801067eb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801067ee:	74 10                	je     80106800 <uartputc+0x20>
}
801067f0:	5d                   	pop    %ebp
801067f1:	e9 da fe ff ff       	jmp    801066d0 <uartputc.part.0>
801067f6:	8d 76 00             	lea    0x0(%esi),%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106800:	5d                   	pop    %ebp
80106801:	c3                   	ret    
80106802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <uartintr>:

void
uartintr(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106816:	68 a0 66 10 80       	push   $0x801066a0
8010681b:	e8 f0 9f ff ff       	call   80100810 <consoleintr>
}
80106820:	83 c4 10             	add    $0x10,%esp
80106823:	c9                   	leave  
80106824:	c3                   	ret    

80106825 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $0
80106827:	6a 00                	push   $0x0
  jmp alltraps
80106829:	e9 a1 fa ff ff       	jmp    801062cf <alltraps>

8010682e <vector1>:
.globl vector1
vector1:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $1
80106830:	6a 01                	push   $0x1
  jmp alltraps
80106832:	e9 98 fa ff ff       	jmp    801062cf <alltraps>

80106837 <vector2>:
.globl vector2
vector2:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $2
80106839:	6a 02                	push   $0x2
  jmp alltraps
8010683b:	e9 8f fa ff ff       	jmp    801062cf <alltraps>

80106840 <vector3>:
.globl vector3
vector3:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $3
80106842:	6a 03                	push   $0x3
  jmp alltraps
80106844:	e9 86 fa ff ff       	jmp    801062cf <alltraps>

80106849 <vector4>:
.globl vector4
vector4:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $4
8010684b:	6a 04                	push   $0x4
  jmp alltraps
8010684d:	e9 7d fa ff ff       	jmp    801062cf <alltraps>

80106852 <vector5>:
.globl vector5
vector5:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $5
80106854:	6a 05                	push   $0x5
  jmp alltraps
80106856:	e9 74 fa ff ff       	jmp    801062cf <alltraps>

8010685b <vector6>:
.globl vector6
vector6:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $6
8010685d:	6a 06                	push   $0x6
  jmp alltraps
8010685f:	e9 6b fa ff ff       	jmp    801062cf <alltraps>

80106864 <vector7>:
.globl vector7
vector7:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $7
80106866:	6a 07                	push   $0x7
  jmp alltraps
80106868:	e9 62 fa ff ff       	jmp    801062cf <alltraps>

8010686d <vector8>:
.globl vector8
vector8:
  pushl $8
8010686d:	6a 08                	push   $0x8
  jmp alltraps
8010686f:	e9 5b fa ff ff       	jmp    801062cf <alltraps>

80106874 <vector9>:
.globl vector9
vector9:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $9
80106876:	6a 09                	push   $0x9
  jmp alltraps
80106878:	e9 52 fa ff ff       	jmp    801062cf <alltraps>

8010687d <vector10>:
.globl vector10
vector10:
  pushl $10
8010687d:	6a 0a                	push   $0xa
  jmp alltraps
8010687f:	e9 4b fa ff ff       	jmp    801062cf <alltraps>

80106884 <vector11>:
.globl vector11
vector11:
  pushl $11
80106884:	6a 0b                	push   $0xb
  jmp alltraps
80106886:	e9 44 fa ff ff       	jmp    801062cf <alltraps>

8010688b <vector12>:
.globl vector12
vector12:
  pushl $12
8010688b:	6a 0c                	push   $0xc
  jmp alltraps
8010688d:	e9 3d fa ff ff       	jmp    801062cf <alltraps>

80106892 <vector13>:
.globl vector13
vector13:
  pushl $13
80106892:	6a 0d                	push   $0xd
  jmp alltraps
80106894:	e9 36 fa ff ff       	jmp    801062cf <alltraps>

80106899 <vector14>:
.globl vector14
vector14:
  pushl $14
80106899:	6a 0e                	push   $0xe
  jmp alltraps
8010689b:	e9 2f fa ff ff       	jmp    801062cf <alltraps>

801068a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $15
801068a2:	6a 0f                	push   $0xf
  jmp alltraps
801068a4:	e9 26 fa ff ff       	jmp    801062cf <alltraps>

801068a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $16
801068ab:	6a 10                	push   $0x10
  jmp alltraps
801068ad:	e9 1d fa ff ff       	jmp    801062cf <alltraps>

801068b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801068b2:	6a 11                	push   $0x11
  jmp alltraps
801068b4:	e9 16 fa ff ff       	jmp    801062cf <alltraps>

801068b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $18
801068bb:	6a 12                	push   $0x12
  jmp alltraps
801068bd:	e9 0d fa ff ff       	jmp    801062cf <alltraps>

801068c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $19
801068c4:	6a 13                	push   $0x13
  jmp alltraps
801068c6:	e9 04 fa ff ff       	jmp    801062cf <alltraps>

801068cb <vector20>:
.globl vector20
vector20:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $20
801068cd:	6a 14                	push   $0x14
  jmp alltraps
801068cf:	e9 fb f9 ff ff       	jmp    801062cf <alltraps>

801068d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $21
801068d6:	6a 15                	push   $0x15
  jmp alltraps
801068d8:	e9 f2 f9 ff ff       	jmp    801062cf <alltraps>

801068dd <vector22>:
.globl vector22
vector22:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $22
801068df:	6a 16                	push   $0x16
  jmp alltraps
801068e1:	e9 e9 f9 ff ff       	jmp    801062cf <alltraps>

801068e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $23
801068e8:	6a 17                	push   $0x17
  jmp alltraps
801068ea:	e9 e0 f9 ff ff       	jmp    801062cf <alltraps>

801068ef <vector24>:
.globl vector24
vector24:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $24
801068f1:	6a 18                	push   $0x18
  jmp alltraps
801068f3:	e9 d7 f9 ff ff       	jmp    801062cf <alltraps>

801068f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $25
801068fa:	6a 19                	push   $0x19
  jmp alltraps
801068fc:	e9 ce f9 ff ff       	jmp    801062cf <alltraps>

80106901 <vector26>:
.globl vector26
vector26:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $26
80106903:	6a 1a                	push   $0x1a
  jmp alltraps
80106905:	e9 c5 f9 ff ff       	jmp    801062cf <alltraps>

8010690a <vector27>:
.globl vector27
vector27:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $27
8010690c:	6a 1b                	push   $0x1b
  jmp alltraps
8010690e:	e9 bc f9 ff ff       	jmp    801062cf <alltraps>

80106913 <vector28>:
.globl vector28
vector28:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $28
80106915:	6a 1c                	push   $0x1c
  jmp alltraps
80106917:	e9 b3 f9 ff ff       	jmp    801062cf <alltraps>

8010691c <vector29>:
.globl vector29
vector29:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $29
8010691e:	6a 1d                	push   $0x1d
  jmp alltraps
80106920:	e9 aa f9 ff ff       	jmp    801062cf <alltraps>

80106925 <vector30>:
.globl vector30
vector30:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $30
80106927:	6a 1e                	push   $0x1e
  jmp alltraps
80106929:	e9 a1 f9 ff ff       	jmp    801062cf <alltraps>

8010692e <vector31>:
.globl vector31
vector31:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $31
80106930:	6a 1f                	push   $0x1f
  jmp alltraps
80106932:	e9 98 f9 ff ff       	jmp    801062cf <alltraps>

80106937 <vector32>:
.globl vector32
vector32:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $32
80106939:	6a 20                	push   $0x20
  jmp alltraps
8010693b:	e9 8f f9 ff ff       	jmp    801062cf <alltraps>

80106940 <vector33>:
.globl vector33
vector33:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $33
80106942:	6a 21                	push   $0x21
  jmp alltraps
80106944:	e9 86 f9 ff ff       	jmp    801062cf <alltraps>

80106949 <vector34>:
.globl vector34
vector34:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $34
8010694b:	6a 22                	push   $0x22
  jmp alltraps
8010694d:	e9 7d f9 ff ff       	jmp    801062cf <alltraps>

80106952 <vector35>:
.globl vector35
vector35:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $35
80106954:	6a 23                	push   $0x23
  jmp alltraps
80106956:	e9 74 f9 ff ff       	jmp    801062cf <alltraps>

8010695b <vector36>:
.globl vector36
vector36:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $36
8010695d:	6a 24                	push   $0x24
  jmp alltraps
8010695f:	e9 6b f9 ff ff       	jmp    801062cf <alltraps>

80106964 <vector37>:
.globl vector37
vector37:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $37
80106966:	6a 25                	push   $0x25
  jmp alltraps
80106968:	e9 62 f9 ff ff       	jmp    801062cf <alltraps>

8010696d <vector38>:
.globl vector38
vector38:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $38
8010696f:	6a 26                	push   $0x26
  jmp alltraps
80106971:	e9 59 f9 ff ff       	jmp    801062cf <alltraps>

80106976 <vector39>:
.globl vector39
vector39:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $39
80106978:	6a 27                	push   $0x27
  jmp alltraps
8010697a:	e9 50 f9 ff ff       	jmp    801062cf <alltraps>

8010697f <vector40>:
.globl vector40
vector40:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $40
80106981:	6a 28                	push   $0x28
  jmp alltraps
80106983:	e9 47 f9 ff ff       	jmp    801062cf <alltraps>

80106988 <vector41>:
.globl vector41
vector41:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $41
8010698a:	6a 29                	push   $0x29
  jmp alltraps
8010698c:	e9 3e f9 ff ff       	jmp    801062cf <alltraps>

80106991 <vector42>:
.globl vector42
vector42:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $42
80106993:	6a 2a                	push   $0x2a
  jmp alltraps
80106995:	e9 35 f9 ff ff       	jmp    801062cf <alltraps>

8010699a <vector43>:
.globl vector43
vector43:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $43
8010699c:	6a 2b                	push   $0x2b
  jmp alltraps
8010699e:	e9 2c f9 ff ff       	jmp    801062cf <alltraps>

801069a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $44
801069a5:	6a 2c                	push   $0x2c
  jmp alltraps
801069a7:	e9 23 f9 ff ff       	jmp    801062cf <alltraps>

801069ac <vector45>:
.globl vector45
vector45:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $45
801069ae:	6a 2d                	push   $0x2d
  jmp alltraps
801069b0:	e9 1a f9 ff ff       	jmp    801062cf <alltraps>

801069b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $46
801069b7:	6a 2e                	push   $0x2e
  jmp alltraps
801069b9:	e9 11 f9 ff ff       	jmp    801062cf <alltraps>

801069be <vector47>:
.globl vector47
vector47:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $47
801069c0:	6a 2f                	push   $0x2f
  jmp alltraps
801069c2:	e9 08 f9 ff ff       	jmp    801062cf <alltraps>

801069c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $48
801069c9:	6a 30                	push   $0x30
  jmp alltraps
801069cb:	e9 ff f8 ff ff       	jmp    801062cf <alltraps>

801069d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $49
801069d2:	6a 31                	push   $0x31
  jmp alltraps
801069d4:	e9 f6 f8 ff ff       	jmp    801062cf <alltraps>

801069d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $50
801069db:	6a 32                	push   $0x32
  jmp alltraps
801069dd:	e9 ed f8 ff ff       	jmp    801062cf <alltraps>

801069e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $51
801069e4:	6a 33                	push   $0x33
  jmp alltraps
801069e6:	e9 e4 f8 ff ff       	jmp    801062cf <alltraps>

801069eb <vector52>:
.globl vector52
vector52:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $52
801069ed:	6a 34                	push   $0x34
  jmp alltraps
801069ef:	e9 db f8 ff ff       	jmp    801062cf <alltraps>

801069f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $53
801069f6:	6a 35                	push   $0x35
  jmp alltraps
801069f8:	e9 d2 f8 ff ff       	jmp    801062cf <alltraps>

801069fd <vector54>:
.globl vector54
vector54:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $54
801069ff:	6a 36                	push   $0x36
  jmp alltraps
80106a01:	e9 c9 f8 ff ff       	jmp    801062cf <alltraps>

80106a06 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $55
80106a08:	6a 37                	push   $0x37
  jmp alltraps
80106a0a:	e9 c0 f8 ff ff       	jmp    801062cf <alltraps>

80106a0f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $56
80106a11:	6a 38                	push   $0x38
  jmp alltraps
80106a13:	e9 b7 f8 ff ff       	jmp    801062cf <alltraps>

80106a18 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $57
80106a1a:	6a 39                	push   $0x39
  jmp alltraps
80106a1c:	e9 ae f8 ff ff       	jmp    801062cf <alltraps>

80106a21 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $58
80106a23:	6a 3a                	push   $0x3a
  jmp alltraps
80106a25:	e9 a5 f8 ff ff       	jmp    801062cf <alltraps>

80106a2a <vector59>:
.globl vector59
vector59:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $59
80106a2c:	6a 3b                	push   $0x3b
  jmp alltraps
80106a2e:	e9 9c f8 ff ff       	jmp    801062cf <alltraps>

80106a33 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $60
80106a35:	6a 3c                	push   $0x3c
  jmp alltraps
80106a37:	e9 93 f8 ff ff       	jmp    801062cf <alltraps>

80106a3c <vector61>:
.globl vector61
vector61:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $61
80106a3e:	6a 3d                	push   $0x3d
  jmp alltraps
80106a40:	e9 8a f8 ff ff       	jmp    801062cf <alltraps>

80106a45 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $62
80106a47:	6a 3e                	push   $0x3e
  jmp alltraps
80106a49:	e9 81 f8 ff ff       	jmp    801062cf <alltraps>

80106a4e <vector63>:
.globl vector63
vector63:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $63
80106a50:	6a 3f                	push   $0x3f
  jmp alltraps
80106a52:	e9 78 f8 ff ff       	jmp    801062cf <alltraps>

80106a57 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $64
80106a59:	6a 40                	push   $0x40
  jmp alltraps
80106a5b:	e9 6f f8 ff ff       	jmp    801062cf <alltraps>

80106a60 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $65
80106a62:	6a 41                	push   $0x41
  jmp alltraps
80106a64:	e9 66 f8 ff ff       	jmp    801062cf <alltraps>

80106a69 <vector66>:
.globl vector66
vector66:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $66
80106a6b:	6a 42                	push   $0x42
  jmp alltraps
80106a6d:	e9 5d f8 ff ff       	jmp    801062cf <alltraps>

80106a72 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $67
80106a74:	6a 43                	push   $0x43
  jmp alltraps
80106a76:	e9 54 f8 ff ff       	jmp    801062cf <alltraps>

80106a7b <vector68>:
.globl vector68
vector68:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $68
80106a7d:	6a 44                	push   $0x44
  jmp alltraps
80106a7f:	e9 4b f8 ff ff       	jmp    801062cf <alltraps>

80106a84 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $69
80106a86:	6a 45                	push   $0x45
  jmp alltraps
80106a88:	e9 42 f8 ff ff       	jmp    801062cf <alltraps>

80106a8d <vector70>:
.globl vector70
vector70:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $70
80106a8f:	6a 46                	push   $0x46
  jmp alltraps
80106a91:	e9 39 f8 ff ff       	jmp    801062cf <alltraps>

80106a96 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $71
80106a98:	6a 47                	push   $0x47
  jmp alltraps
80106a9a:	e9 30 f8 ff ff       	jmp    801062cf <alltraps>

80106a9f <vector72>:
.globl vector72
vector72:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $72
80106aa1:	6a 48                	push   $0x48
  jmp alltraps
80106aa3:	e9 27 f8 ff ff       	jmp    801062cf <alltraps>

80106aa8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $73
80106aaa:	6a 49                	push   $0x49
  jmp alltraps
80106aac:	e9 1e f8 ff ff       	jmp    801062cf <alltraps>

80106ab1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $74
80106ab3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ab5:	e9 15 f8 ff ff       	jmp    801062cf <alltraps>

80106aba <vector75>:
.globl vector75
vector75:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $75
80106abc:	6a 4b                	push   $0x4b
  jmp alltraps
80106abe:	e9 0c f8 ff ff       	jmp    801062cf <alltraps>

80106ac3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $76
80106ac5:	6a 4c                	push   $0x4c
  jmp alltraps
80106ac7:	e9 03 f8 ff ff       	jmp    801062cf <alltraps>

80106acc <vector77>:
.globl vector77
vector77:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $77
80106ace:	6a 4d                	push   $0x4d
  jmp alltraps
80106ad0:	e9 fa f7 ff ff       	jmp    801062cf <alltraps>

80106ad5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $78
80106ad7:	6a 4e                	push   $0x4e
  jmp alltraps
80106ad9:	e9 f1 f7 ff ff       	jmp    801062cf <alltraps>

80106ade <vector79>:
.globl vector79
vector79:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $79
80106ae0:	6a 4f                	push   $0x4f
  jmp alltraps
80106ae2:	e9 e8 f7 ff ff       	jmp    801062cf <alltraps>

80106ae7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $80
80106ae9:	6a 50                	push   $0x50
  jmp alltraps
80106aeb:	e9 df f7 ff ff       	jmp    801062cf <alltraps>

80106af0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $81
80106af2:	6a 51                	push   $0x51
  jmp alltraps
80106af4:	e9 d6 f7 ff ff       	jmp    801062cf <alltraps>

80106af9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $82
80106afb:	6a 52                	push   $0x52
  jmp alltraps
80106afd:	e9 cd f7 ff ff       	jmp    801062cf <alltraps>

80106b02 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $83
80106b04:	6a 53                	push   $0x53
  jmp alltraps
80106b06:	e9 c4 f7 ff ff       	jmp    801062cf <alltraps>

80106b0b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $84
80106b0d:	6a 54                	push   $0x54
  jmp alltraps
80106b0f:	e9 bb f7 ff ff       	jmp    801062cf <alltraps>

80106b14 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $85
80106b16:	6a 55                	push   $0x55
  jmp alltraps
80106b18:	e9 b2 f7 ff ff       	jmp    801062cf <alltraps>

80106b1d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $86
80106b1f:	6a 56                	push   $0x56
  jmp alltraps
80106b21:	e9 a9 f7 ff ff       	jmp    801062cf <alltraps>

80106b26 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $87
80106b28:	6a 57                	push   $0x57
  jmp alltraps
80106b2a:	e9 a0 f7 ff ff       	jmp    801062cf <alltraps>

80106b2f <vector88>:
.globl vector88
vector88:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $88
80106b31:	6a 58                	push   $0x58
  jmp alltraps
80106b33:	e9 97 f7 ff ff       	jmp    801062cf <alltraps>

80106b38 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $89
80106b3a:	6a 59                	push   $0x59
  jmp alltraps
80106b3c:	e9 8e f7 ff ff       	jmp    801062cf <alltraps>

80106b41 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $90
80106b43:	6a 5a                	push   $0x5a
  jmp alltraps
80106b45:	e9 85 f7 ff ff       	jmp    801062cf <alltraps>

80106b4a <vector91>:
.globl vector91
vector91:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $91
80106b4c:	6a 5b                	push   $0x5b
  jmp alltraps
80106b4e:	e9 7c f7 ff ff       	jmp    801062cf <alltraps>

80106b53 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $92
80106b55:	6a 5c                	push   $0x5c
  jmp alltraps
80106b57:	e9 73 f7 ff ff       	jmp    801062cf <alltraps>

80106b5c <vector93>:
.globl vector93
vector93:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $93
80106b5e:	6a 5d                	push   $0x5d
  jmp alltraps
80106b60:	e9 6a f7 ff ff       	jmp    801062cf <alltraps>

80106b65 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $94
80106b67:	6a 5e                	push   $0x5e
  jmp alltraps
80106b69:	e9 61 f7 ff ff       	jmp    801062cf <alltraps>

80106b6e <vector95>:
.globl vector95
vector95:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $95
80106b70:	6a 5f                	push   $0x5f
  jmp alltraps
80106b72:	e9 58 f7 ff ff       	jmp    801062cf <alltraps>

80106b77 <vector96>:
.globl vector96
vector96:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $96
80106b79:	6a 60                	push   $0x60
  jmp alltraps
80106b7b:	e9 4f f7 ff ff       	jmp    801062cf <alltraps>

80106b80 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $97
80106b82:	6a 61                	push   $0x61
  jmp alltraps
80106b84:	e9 46 f7 ff ff       	jmp    801062cf <alltraps>

80106b89 <vector98>:
.globl vector98
vector98:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $98
80106b8b:	6a 62                	push   $0x62
  jmp alltraps
80106b8d:	e9 3d f7 ff ff       	jmp    801062cf <alltraps>

80106b92 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $99
80106b94:	6a 63                	push   $0x63
  jmp alltraps
80106b96:	e9 34 f7 ff ff       	jmp    801062cf <alltraps>

80106b9b <vector100>:
.globl vector100
vector100:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $100
80106b9d:	6a 64                	push   $0x64
  jmp alltraps
80106b9f:	e9 2b f7 ff ff       	jmp    801062cf <alltraps>

80106ba4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $101
80106ba6:	6a 65                	push   $0x65
  jmp alltraps
80106ba8:	e9 22 f7 ff ff       	jmp    801062cf <alltraps>

80106bad <vector102>:
.globl vector102
vector102:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $102
80106baf:	6a 66                	push   $0x66
  jmp alltraps
80106bb1:	e9 19 f7 ff ff       	jmp    801062cf <alltraps>

80106bb6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $103
80106bb8:	6a 67                	push   $0x67
  jmp alltraps
80106bba:	e9 10 f7 ff ff       	jmp    801062cf <alltraps>

80106bbf <vector104>:
.globl vector104
vector104:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $104
80106bc1:	6a 68                	push   $0x68
  jmp alltraps
80106bc3:	e9 07 f7 ff ff       	jmp    801062cf <alltraps>

80106bc8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $105
80106bca:	6a 69                	push   $0x69
  jmp alltraps
80106bcc:	e9 fe f6 ff ff       	jmp    801062cf <alltraps>

80106bd1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $106
80106bd3:	6a 6a                	push   $0x6a
  jmp alltraps
80106bd5:	e9 f5 f6 ff ff       	jmp    801062cf <alltraps>

80106bda <vector107>:
.globl vector107
vector107:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $107
80106bdc:	6a 6b                	push   $0x6b
  jmp alltraps
80106bde:	e9 ec f6 ff ff       	jmp    801062cf <alltraps>

80106be3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $108
80106be5:	6a 6c                	push   $0x6c
  jmp alltraps
80106be7:	e9 e3 f6 ff ff       	jmp    801062cf <alltraps>

80106bec <vector109>:
.globl vector109
vector109:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $109
80106bee:	6a 6d                	push   $0x6d
  jmp alltraps
80106bf0:	e9 da f6 ff ff       	jmp    801062cf <alltraps>

80106bf5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $110
80106bf7:	6a 6e                	push   $0x6e
  jmp alltraps
80106bf9:	e9 d1 f6 ff ff       	jmp    801062cf <alltraps>

80106bfe <vector111>:
.globl vector111
vector111:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $111
80106c00:	6a 6f                	push   $0x6f
  jmp alltraps
80106c02:	e9 c8 f6 ff ff       	jmp    801062cf <alltraps>

80106c07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $112
80106c09:	6a 70                	push   $0x70
  jmp alltraps
80106c0b:	e9 bf f6 ff ff       	jmp    801062cf <alltraps>

80106c10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $113
80106c12:	6a 71                	push   $0x71
  jmp alltraps
80106c14:	e9 b6 f6 ff ff       	jmp    801062cf <alltraps>

80106c19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $114
80106c1b:	6a 72                	push   $0x72
  jmp alltraps
80106c1d:	e9 ad f6 ff ff       	jmp    801062cf <alltraps>

80106c22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $115
80106c24:	6a 73                	push   $0x73
  jmp alltraps
80106c26:	e9 a4 f6 ff ff       	jmp    801062cf <alltraps>

80106c2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $116
80106c2d:	6a 74                	push   $0x74
  jmp alltraps
80106c2f:	e9 9b f6 ff ff       	jmp    801062cf <alltraps>

80106c34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $117
80106c36:	6a 75                	push   $0x75
  jmp alltraps
80106c38:	e9 92 f6 ff ff       	jmp    801062cf <alltraps>

80106c3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $118
80106c3f:	6a 76                	push   $0x76
  jmp alltraps
80106c41:	e9 89 f6 ff ff       	jmp    801062cf <alltraps>

80106c46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $119
80106c48:	6a 77                	push   $0x77
  jmp alltraps
80106c4a:	e9 80 f6 ff ff       	jmp    801062cf <alltraps>

80106c4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $120
80106c51:	6a 78                	push   $0x78
  jmp alltraps
80106c53:	e9 77 f6 ff ff       	jmp    801062cf <alltraps>

80106c58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $121
80106c5a:	6a 79                	push   $0x79
  jmp alltraps
80106c5c:	e9 6e f6 ff ff       	jmp    801062cf <alltraps>

80106c61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $122
80106c63:	6a 7a                	push   $0x7a
  jmp alltraps
80106c65:	e9 65 f6 ff ff       	jmp    801062cf <alltraps>

80106c6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $123
80106c6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106c6e:	e9 5c f6 ff ff       	jmp    801062cf <alltraps>

80106c73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $124
80106c75:	6a 7c                	push   $0x7c
  jmp alltraps
80106c77:	e9 53 f6 ff ff       	jmp    801062cf <alltraps>

80106c7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $125
80106c7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106c80:	e9 4a f6 ff ff       	jmp    801062cf <alltraps>

80106c85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $126
80106c87:	6a 7e                	push   $0x7e
  jmp alltraps
80106c89:	e9 41 f6 ff ff       	jmp    801062cf <alltraps>

80106c8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $127
80106c90:	6a 7f                	push   $0x7f
  jmp alltraps
80106c92:	e9 38 f6 ff ff       	jmp    801062cf <alltraps>

80106c97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $128
80106c99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c9e:	e9 2c f6 ff ff       	jmp    801062cf <alltraps>

80106ca3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $129
80106ca5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106caa:	e9 20 f6 ff ff       	jmp    801062cf <alltraps>

80106caf <vector130>:
.globl vector130
vector130:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $130
80106cb1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cb6:	e9 14 f6 ff ff       	jmp    801062cf <alltraps>

80106cbb <vector131>:
.globl vector131
vector131:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $131
80106cbd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106cc2:	e9 08 f6 ff ff       	jmp    801062cf <alltraps>

80106cc7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $132
80106cc9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106cce:	e9 fc f5 ff ff       	jmp    801062cf <alltraps>

80106cd3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $133
80106cd5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cda:	e9 f0 f5 ff ff       	jmp    801062cf <alltraps>

80106cdf <vector134>:
.globl vector134
vector134:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $134
80106ce1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ce6:	e9 e4 f5 ff ff       	jmp    801062cf <alltraps>

80106ceb <vector135>:
.globl vector135
vector135:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $135
80106ced:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cf2:	e9 d8 f5 ff ff       	jmp    801062cf <alltraps>

80106cf7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $136
80106cf9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cfe:	e9 cc f5 ff ff       	jmp    801062cf <alltraps>

80106d03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $137
80106d05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d0a:	e9 c0 f5 ff ff       	jmp    801062cf <alltraps>

80106d0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $138
80106d11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d16:	e9 b4 f5 ff ff       	jmp    801062cf <alltraps>

80106d1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $139
80106d1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d22:	e9 a8 f5 ff ff       	jmp    801062cf <alltraps>

80106d27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $140
80106d29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d2e:	e9 9c f5 ff ff       	jmp    801062cf <alltraps>

80106d33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $141
80106d35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d3a:	e9 90 f5 ff ff       	jmp    801062cf <alltraps>

80106d3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $142
80106d41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d46:	e9 84 f5 ff ff       	jmp    801062cf <alltraps>

80106d4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $143
80106d4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d52:	e9 78 f5 ff ff       	jmp    801062cf <alltraps>

80106d57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $144
80106d59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d5e:	e9 6c f5 ff ff       	jmp    801062cf <alltraps>

80106d63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $145
80106d65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d6a:	e9 60 f5 ff ff       	jmp    801062cf <alltraps>

80106d6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $146
80106d71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d76:	e9 54 f5 ff ff       	jmp    801062cf <alltraps>

80106d7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $147
80106d7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d82:	e9 48 f5 ff ff       	jmp    801062cf <alltraps>

80106d87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $148
80106d89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d8e:	e9 3c f5 ff ff       	jmp    801062cf <alltraps>

80106d93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $149
80106d95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d9a:	e9 30 f5 ff ff       	jmp    801062cf <alltraps>

80106d9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $150
80106da1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106da6:	e9 24 f5 ff ff       	jmp    801062cf <alltraps>

80106dab <vector151>:
.globl vector151
vector151:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $151
80106dad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106db2:	e9 18 f5 ff ff       	jmp    801062cf <alltraps>

80106db7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $152
80106db9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106dbe:	e9 0c f5 ff ff       	jmp    801062cf <alltraps>

80106dc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $153
80106dc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106dca:	e9 00 f5 ff ff       	jmp    801062cf <alltraps>

80106dcf <vector154>:
.globl vector154
vector154:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $154
80106dd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106dd6:	e9 f4 f4 ff ff       	jmp    801062cf <alltraps>

80106ddb <vector155>:
.globl vector155
vector155:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $155
80106ddd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106de2:	e9 e8 f4 ff ff       	jmp    801062cf <alltraps>

80106de7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $156
80106de9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106dee:	e9 dc f4 ff ff       	jmp    801062cf <alltraps>

80106df3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $157
80106df5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dfa:	e9 d0 f4 ff ff       	jmp    801062cf <alltraps>

80106dff <vector158>:
.globl vector158
vector158:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $158
80106e01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e06:	e9 c4 f4 ff ff       	jmp    801062cf <alltraps>

80106e0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $159
80106e0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e12:	e9 b8 f4 ff ff       	jmp    801062cf <alltraps>

80106e17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $160
80106e19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e1e:	e9 ac f4 ff ff       	jmp    801062cf <alltraps>

80106e23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $161
80106e25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e2a:	e9 a0 f4 ff ff       	jmp    801062cf <alltraps>

80106e2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $162
80106e31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e36:	e9 94 f4 ff ff       	jmp    801062cf <alltraps>

80106e3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $163
80106e3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e42:	e9 88 f4 ff ff       	jmp    801062cf <alltraps>

80106e47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $164
80106e49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e4e:	e9 7c f4 ff ff       	jmp    801062cf <alltraps>

80106e53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $165
80106e55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e5a:	e9 70 f4 ff ff       	jmp    801062cf <alltraps>

80106e5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $166
80106e61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e66:	e9 64 f4 ff ff       	jmp    801062cf <alltraps>

80106e6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $167
80106e6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e72:	e9 58 f4 ff ff       	jmp    801062cf <alltraps>

80106e77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $168
80106e79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e7e:	e9 4c f4 ff ff       	jmp    801062cf <alltraps>

80106e83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $169
80106e85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e8a:	e9 40 f4 ff ff       	jmp    801062cf <alltraps>

80106e8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $170
80106e91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e96:	e9 34 f4 ff ff       	jmp    801062cf <alltraps>

80106e9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $171
80106e9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ea2:	e9 28 f4 ff ff       	jmp    801062cf <alltraps>

80106ea7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $172
80106ea9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106eae:	e9 1c f4 ff ff       	jmp    801062cf <alltraps>

80106eb3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $173
80106eb5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106eba:	e9 10 f4 ff ff       	jmp    801062cf <alltraps>

80106ebf <vector174>:
.globl vector174
vector174:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $174
80106ec1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ec6:	e9 04 f4 ff ff       	jmp    801062cf <alltraps>

80106ecb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $175
80106ecd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ed2:	e9 f8 f3 ff ff       	jmp    801062cf <alltraps>

80106ed7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $176
80106ed9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ede:	e9 ec f3 ff ff       	jmp    801062cf <alltraps>

80106ee3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $177
80106ee5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106eea:	e9 e0 f3 ff ff       	jmp    801062cf <alltraps>

80106eef <vector178>:
.globl vector178
vector178:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $178
80106ef1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ef6:	e9 d4 f3 ff ff       	jmp    801062cf <alltraps>

80106efb <vector179>:
.globl vector179
vector179:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $179
80106efd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f02:	e9 c8 f3 ff ff       	jmp    801062cf <alltraps>

80106f07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $180
80106f09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f0e:	e9 bc f3 ff ff       	jmp    801062cf <alltraps>

80106f13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $181
80106f15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f1a:	e9 b0 f3 ff ff       	jmp    801062cf <alltraps>

80106f1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $182
80106f21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f26:	e9 a4 f3 ff ff       	jmp    801062cf <alltraps>

80106f2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $183
80106f2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f32:	e9 98 f3 ff ff       	jmp    801062cf <alltraps>

80106f37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $184
80106f39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f3e:	e9 8c f3 ff ff       	jmp    801062cf <alltraps>

80106f43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $185
80106f45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f4a:	e9 80 f3 ff ff       	jmp    801062cf <alltraps>

80106f4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $186
80106f51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f56:	e9 74 f3 ff ff       	jmp    801062cf <alltraps>

80106f5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $187
80106f5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f62:	e9 68 f3 ff ff       	jmp    801062cf <alltraps>

80106f67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $188
80106f69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f6e:	e9 5c f3 ff ff       	jmp    801062cf <alltraps>

80106f73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $189
80106f75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f7a:	e9 50 f3 ff ff       	jmp    801062cf <alltraps>

80106f7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $190
80106f81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f86:	e9 44 f3 ff ff       	jmp    801062cf <alltraps>

80106f8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $191
80106f8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f92:	e9 38 f3 ff ff       	jmp    801062cf <alltraps>

80106f97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $192
80106f99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f9e:	e9 2c f3 ff ff       	jmp    801062cf <alltraps>

80106fa3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $193
80106fa5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106faa:	e9 20 f3 ff ff       	jmp    801062cf <alltraps>

80106faf <vector194>:
.globl vector194
vector194:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $194
80106fb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106fb6:	e9 14 f3 ff ff       	jmp    801062cf <alltraps>

80106fbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $195
80106fbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fc2:	e9 08 f3 ff ff       	jmp    801062cf <alltraps>

80106fc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $196
80106fc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fce:	e9 fc f2 ff ff       	jmp    801062cf <alltraps>

80106fd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $197
80106fd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fda:	e9 f0 f2 ff ff       	jmp    801062cf <alltraps>

80106fdf <vector198>:
.globl vector198
vector198:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $198
80106fe1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106fe6:	e9 e4 f2 ff ff       	jmp    801062cf <alltraps>

80106feb <vector199>:
.globl vector199
vector199:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $199
80106fed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ff2:	e9 d8 f2 ff ff       	jmp    801062cf <alltraps>

80106ff7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $200
80106ff9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106ffe:	e9 cc f2 ff ff       	jmp    801062cf <alltraps>

80107003 <vector201>:
.globl vector201
vector201:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $201
80107005:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010700a:	e9 c0 f2 ff ff       	jmp    801062cf <alltraps>

8010700f <vector202>:
.globl vector202
vector202:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $202
80107011:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107016:	e9 b4 f2 ff ff       	jmp    801062cf <alltraps>

8010701b <vector203>:
.globl vector203
vector203:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $203
8010701d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107022:	e9 a8 f2 ff ff       	jmp    801062cf <alltraps>

80107027 <vector204>:
.globl vector204
vector204:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $204
80107029:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010702e:	e9 9c f2 ff ff       	jmp    801062cf <alltraps>

80107033 <vector205>:
.globl vector205
vector205:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $205
80107035:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010703a:	e9 90 f2 ff ff       	jmp    801062cf <alltraps>

8010703f <vector206>:
.globl vector206
vector206:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $206
80107041:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107046:	e9 84 f2 ff ff       	jmp    801062cf <alltraps>

8010704b <vector207>:
.globl vector207
vector207:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $207
8010704d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107052:	e9 78 f2 ff ff       	jmp    801062cf <alltraps>

80107057 <vector208>:
.globl vector208
vector208:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $208
80107059:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010705e:	e9 6c f2 ff ff       	jmp    801062cf <alltraps>

80107063 <vector209>:
.globl vector209
vector209:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $209
80107065:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010706a:	e9 60 f2 ff ff       	jmp    801062cf <alltraps>

8010706f <vector210>:
.globl vector210
vector210:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $210
80107071:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107076:	e9 54 f2 ff ff       	jmp    801062cf <alltraps>

8010707b <vector211>:
.globl vector211
vector211:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $211
8010707d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107082:	e9 48 f2 ff ff       	jmp    801062cf <alltraps>

80107087 <vector212>:
.globl vector212
vector212:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $212
80107089:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010708e:	e9 3c f2 ff ff       	jmp    801062cf <alltraps>

80107093 <vector213>:
.globl vector213
vector213:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $213
80107095:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010709a:	e9 30 f2 ff ff       	jmp    801062cf <alltraps>

8010709f <vector214>:
.globl vector214
vector214:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $214
801070a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070a6:	e9 24 f2 ff ff       	jmp    801062cf <alltraps>

801070ab <vector215>:
.globl vector215
vector215:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $215
801070ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070b2:	e9 18 f2 ff ff       	jmp    801062cf <alltraps>

801070b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $216
801070b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070be:	e9 0c f2 ff ff       	jmp    801062cf <alltraps>

801070c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $217
801070c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070ca:	e9 00 f2 ff ff       	jmp    801062cf <alltraps>

801070cf <vector218>:
.globl vector218
vector218:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $218
801070d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070d6:	e9 f4 f1 ff ff       	jmp    801062cf <alltraps>

801070db <vector219>:
.globl vector219
vector219:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $219
801070dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070e2:	e9 e8 f1 ff ff       	jmp    801062cf <alltraps>

801070e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $220
801070e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070ee:	e9 dc f1 ff ff       	jmp    801062cf <alltraps>

801070f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $221
801070f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070fa:	e9 d0 f1 ff ff       	jmp    801062cf <alltraps>

801070ff <vector222>:
.globl vector222
vector222:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $222
80107101:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107106:	e9 c4 f1 ff ff       	jmp    801062cf <alltraps>

8010710b <vector223>:
.globl vector223
vector223:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $223
8010710d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107112:	e9 b8 f1 ff ff       	jmp    801062cf <alltraps>

80107117 <vector224>:
.globl vector224
vector224:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $224
80107119:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010711e:	e9 ac f1 ff ff       	jmp    801062cf <alltraps>

80107123 <vector225>:
.globl vector225
vector225:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $225
80107125:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010712a:	e9 a0 f1 ff ff       	jmp    801062cf <alltraps>

8010712f <vector226>:
.globl vector226
vector226:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $226
80107131:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107136:	e9 94 f1 ff ff       	jmp    801062cf <alltraps>

8010713b <vector227>:
.globl vector227
vector227:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $227
8010713d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107142:	e9 88 f1 ff ff       	jmp    801062cf <alltraps>

80107147 <vector228>:
.globl vector228
vector228:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $228
80107149:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010714e:	e9 7c f1 ff ff       	jmp    801062cf <alltraps>

80107153 <vector229>:
.globl vector229
vector229:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $229
80107155:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010715a:	e9 70 f1 ff ff       	jmp    801062cf <alltraps>

8010715f <vector230>:
.globl vector230
vector230:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $230
80107161:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107166:	e9 64 f1 ff ff       	jmp    801062cf <alltraps>

8010716b <vector231>:
.globl vector231
vector231:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $231
8010716d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107172:	e9 58 f1 ff ff       	jmp    801062cf <alltraps>

80107177 <vector232>:
.globl vector232
vector232:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $232
80107179:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010717e:	e9 4c f1 ff ff       	jmp    801062cf <alltraps>

80107183 <vector233>:
.globl vector233
vector233:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $233
80107185:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010718a:	e9 40 f1 ff ff       	jmp    801062cf <alltraps>

8010718f <vector234>:
.globl vector234
vector234:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $234
80107191:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107196:	e9 34 f1 ff ff       	jmp    801062cf <alltraps>

8010719b <vector235>:
.globl vector235
vector235:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $235
8010719d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071a2:	e9 28 f1 ff ff       	jmp    801062cf <alltraps>

801071a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $236
801071a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071ae:	e9 1c f1 ff ff       	jmp    801062cf <alltraps>

801071b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $237
801071b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071ba:	e9 10 f1 ff ff       	jmp    801062cf <alltraps>

801071bf <vector238>:
.globl vector238
vector238:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $238
801071c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071c6:	e9 04 f1 ff ff       	jmp    801062cf <alltraps>

801071cb <vector239>:
.globl vector239
vector239:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $239
801071cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071d2:	e9 f8 f0 ff ff       	jmp    801062cf <alltraps>

801071d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $240
801071d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071de:	e9 ec f0 ff ff       	jmp    801062cf <alltraps>

801071e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $241
801071e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071ea:	e9 e0 f0 ff ff       	jmp    801062cf <alltraps>

801071ef <vector242>:
.globl vector242
vector242:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $242
801071f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071f6:	e9 d4 f0 ff ff       	jmp    801062cf <alltraps>

801071fb <vector243>:
.globl vector243
vector243:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $243
801071fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107202:	e9 c8 f0 ff ff       	jmp    801062cf <alltraps>

80107207 <vector244>:
.globl vector244
vector244:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $244
80107209:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010720e:	e9 bc f0 ff ff       	jmp    801062cf <alltraps>

80107213 <vector245>:
.globl vector245
vector245:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $245
80107215:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010721a:	e9 b0 f0 ff ff       	jmp    801062cf <alltraps>

8010721f <vector246>:
.globl vector246
vector246:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $246
80107221:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107226:	e9 a4 f0 ff ff       	jmp    801062cf <alltraps>

8010722b <vector247>:
.globl vector247
vector247:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $247
8010722d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107232:	e9 98 f0 ff ff       	jmp    801062cf <alltraps>

80107237 <vector248>:
.globl vector248
vector248:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $248
80107239:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010723e:	e9 8c f0 ff ff       	jmp    801062cf <alltraps>

80107243 <vector249>:
.globl vector249
vector249:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $249
80107245:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010724a:	e9 80 f0 ff ff       	jmp    801062cf <alltraps>

8010724f <vector250>:
.globl vector250
vector250:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $250
80107251:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107256:	e9 74 f0 ff ff       	jmp    801062cf <alltraps>

8010725b <vector251>:
.globl vector251
vector251:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $251
8010725d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107262:	e9 68 f0 ff ff       	jmp    801062cf <alltraps>

80107267 <vector252>:
.globl vector252
vector252:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $252
80107269:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010726e:	e9 5c f0 ff ff       	jmp    801062cf <alltraps>

80107273 <vector253>:
.globl vector253
vector253:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $253
80107275:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010727a:	e9 50 f0 ff ff       	jmp    801062cf <alltraps>

8010727f <vector254>:
.globl vector254
vector254:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $254
80107281:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107286:	e9 44 f0 ff ff       	jmp    801062cf <alltraps>

8010728b <vector255>:
.globl vector255
vector255:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $255
8010728d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107292:	e9 38 f0 ff ff       	jmp    801062cf <alltraps>
80107297:	66 90                	xchg   %ax,%ax
80107299:	66 90                	xchg   %ax,%ax
8010729b:	66 90                	xchg   %ax,%ax
8010729d:	66 90                	xchg   %ax,%ax
8010729f:	90                   	nop

801072a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801072a6:	89 d3                	mov    %edx,%ebx
{
801072a8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801072aa:	c1 eb 16             	shr    $0x16,%ebx
801072ad:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801072b0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801072b3:	8b 06                	mov    (%esi),%eax
801072b5:	a8 01                	test   $0x1,%al
801072b7:	74 27                	je     801072e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072be:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801072c4:	c1 ef 0a             	shr    $0xa,%edi
}
801072c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801072ca:	89 fa                	mov    %edi,%edx
801072cc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072d2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801072d5:	5b                   	pop    %ebx
801072d6:	5e                   	pop    %esi
801072d7:	5f                   	pop    %edi
801072d8:	5d                   	pop    %ebp
801072d9:	c3                   	ret    
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072e0:	85 c9                	test   %ecx,%ecx
801072e2:	74 2c                	je     80107310 <walkpgdir+0x70>
801072e4:	e8 57 b2 ff ff       	call   80102540 <kalloc>
801072e9:	85 c0                	test   %eax,%eax
801072eb:	89 c3                	mov    %eax,%ebx
801072ed:	74 21                	je     80107310 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801072ef:	83 ec 04             	sub    $0x4,%esp
801072f2:	68 00 10 00 00       	push   $0x1000
801072f7:	6a 00                	push   $0x0
801072f9:	50                   	push   %eax
801072fa:	e8 71 dd ff ff       	call   80105070 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107305:	83 c4 10             	add    $0x10,%esp
80107308:	83 c8 07             	or     $0x7,%eax
8010730b:	89 06                	mov    %eax,(%esi)
8010730d:	eb b5                	jmp    801072c4 <walkpgdir+0x24>
8010730f:	90                   	nop
}
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107313:	31 c0                	xor    %eax,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107326:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010732c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010732e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107334:	83 ec 1c             	sub    $0x1c,%esp
80107337:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010733a:	39 d3                	cmp    %edx,%ebx
8010733c:	73 66                	jae    801073a4 <deallocuvm.part.0+0x84>
8010733e:	89 d6                	mov    %edx,%esi
80107340:	eb 3d                	jmp    8010737f <deallocuvm.part.0+0x5f>
80107342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107348:	8b 10                	mov    (%eax),%edx
8010734a:	f6 c2 01             	test   $0x1,%dl
8010734d:	74 26                	je     80107375 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010734f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107355:	74 58                	je     801073af <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107357:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010735a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107363:	52                   	push   %edx
80107364:	e8 a7 af ff ff       	call   80102310 <kfree>
      *pte = 0;
80107369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010736c:	83 c4 10             	add    $0x10,%esp
8010736f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107375:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010737b:	39 f3                	cmp    %esi,%ebx
8010737d:	73 25                	jae    801073a4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010737f:	31 c9                	xor    %ecx,%ecx
80107381:	89 da                	mov    %ebx,%edx
80107383:	89 f8                	mov    %edi,%eax
80107385:	e8 16 ff ff ff       	call   801072a0 <walkpgdir>
    if(!pte)
8010738a:	85 c0                	test   %eax,%eax
8010738c:	75 ba                	jne    80107348 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010738e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107394:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010739a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073a0:	39 f3                	cmp    %esi,%ebx
801073a2:	72 db                	jb     8010737f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801073a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073aa:	5b                   	pop    %ebx
801073ab:	5e                   	pop    %esi
801073ac:	5f                   	pop    %edi
801073ad:	5d                   	pop    %ebp
801073ae:	c3                   	ret    
        panic("kfree");
801073af:	83 ec 0c             	sub    $0xc,%esp
801073b2:	68 c6 7e 10 80       	push   $0x80107ec6
801073b7:	e8 d4 8f ff ff       	call   80100390 <panic>
801073bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073c0 <seginit>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073c6:	e8 35 c7 ff ff       	call   80103b00 <cpuid>
801073cb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801073d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801073d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073da:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801073e1:	ff 00 00 
801073e4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801073eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073ee:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801073f5:	ff 00 00 
801073f8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
801073ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107402:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107409:	ff 00 00 
8010740c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107413:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107416:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010741d:	ff 00 00 
80107420:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107427:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010742a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010742f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107433:	c1 e8 10             	shr    $0x10,%eax
80107436:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010743a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010743d:	0f 01 10             	lgdtl  (%eax)
}
80107440:	c9                   	leave  
80107441:	c3                   	ret    
80107442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107450 <mappages>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 1c             	sub    $0x1c,%esp
80107459:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010745c:	8b 55 10             	mov    0x10(%ebp),%edx
8010745f:	8b 7d 14             	mov    0x14(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
80107462:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107464:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107468:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010746e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107473:	29 df                	sub    %ebx,%edi
80107475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    *pte = pa | perm | PTE_P;
80107478:	8b 45 18             	mov    0x18(%ebp),%eax
8010747b:	83 c8 01             	or     $0x1,%eax
8010747e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107481:	eb 1a                	jmp    8010749d <mappages+0x4d>
80107483:	90                   	nop
80107484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*pte & PTE_P)
80107488:	f6 00 01             	testb  $0x1,(%eax)
8010748b:	75 3d                	jne    801074ca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
8010748d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
80107490:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107493:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107495:	74 29                	je     801074c0 <mappages+0x70>
    a += PGSIZE;
80107497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010749d:	8b 45 08             	mov    0x8(%ebp),%eax
801074a0:	b9 01 00 00 00       	mov    $0x1,%ecx
801074a5:	89 da                	mov    %ebx,%edx
801074a7:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801074aa:	e8 f1 fd ff ff       	call   801072a0 <walkpgdir>
801074af:	85 c0                	test   %eax,%eax
801074b1:	75 d5                	jne    80107488 <mappages+0x38>
}
801074b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074bb:	5b                   	pop    %ebx
801074bc:	5e                   	pop    %esi
801074bd:	5f                   	pop    %edi
801074be:	5d                   	pop    %ebp
801074bf:	c3                   	ret    
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
      panic("remap");
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	68 24 87 10 80       	push   $0x80108724
801074d2:	e8 b9 8e ff ff       	call   80100390 <panic>
801074d7:	89 f6                	mov    %esi,%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074e0:	a1 d4 68 11 80       	mov    0x801168d4,%eax
{
801074e5:	55                   	push   %ebp
801074e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074ed:	0f 22 d8             	mov    %eax,%cr3
}
801074f0:	5d                   	pop    %ebp
801074f1:	c3                   	ret    
801074f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107500 <switchuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
80107509:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010750c:	85 db                	test   %ebx,%ebx
8010750e:	0f 84 cb 00 00 00    	je     801075df <switchuvm+0xdf>
  if(p->kstack == 0)
80107514:	8b 43 08             	mov    0x8(%ebx),%eax
80107517:	85 c0                	test   %eax,%eax
80107519:	0f 84 da 00 00 00    	je     801075f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010751f:	8b 43 04             	mov    0x4(%ebx),%eax
80107522:	85 c0                	test   %eax,%eax
80107524:	0f 84 c2 00 00 00    	je     801075ec <switchuvm+0xec>
  pushcli();
8010752a:	e8 61 d9 ff ff       	call   80104e90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010752f:	e8 4c c5 ff ff       	call   80103a80 <mycpu>
80107534:	89 c6                	mov    %eax,%esi
80107536:	e8 45 c5 ff ff       	call   80103a80 <mycpu>
8010753b:	89 c7                	mov    %eax,%edi
8010753d:	e8 3e c5 ff ff       	call   80103a80 <mycpu>
80107542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107545:	83 c7 08             	add    $0x8,%edi
80107548:	e8 33 c5 ff ff       	call   80103a80 <mycpu>
8010754d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107550:	83 c0 08             	add    $0x8,%eax
80107553:	ba 67 00 00 00       	mov    $0x67,%edx
80107558:	c1 e8 18             	shr    $0x18,%eax
8010755b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107562:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107569:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010756f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107574:	83 c1 08             	add    $0x8,%ecx
80107577:	c1 e9 10             	shr    $0x10,%ecx
8010757a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107580:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107585:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010758c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107591:	e8 ea c4 ff ff       	call   80103a80 <mycpu>
80107596:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010759d:	e8 de c4 ff ff       	call   80103a80 <mycpu>
801075a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801075a6:	8b 73 08             	mov    0x8(%ebx),%esi
801075a9:	e8 d2 c4 ff ff       	call   80103a80 <mycpu>
801075ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801075b7:	e8 c4 c4 ff ff       	call   80103a80 <mycpu>
801075bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801075c0:	b8 28 00 00 00       	mov    $0x28,%eax
801075c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801075c8:	8b 43 04             	mov    0x4(%ebx),%eax
801075cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075d0:	0f 22 d8             	mov    %eax,%cr3
}
801075d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d6:	5b                   	pop    %ebx
801075d7:	5e                   	pop    %esi
801075d8:	5f                   	pop    %edi
801075d9:	5d                   	pop    %ebp
  popcli();
801075da:	e9 f1 d8 ff ff       	jmp    80104ed0 <popcli>
    panic("switchuvm: no process");
801075df:	83 ec 0c             	sub    $0xc,%esp
801075e2:	68 2a 87 10 80       	push   $0x8010872a
801075e7:	e8 a4 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	68 55 87 10 80       	push   $0x80108755
801075f4:	e8 97 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801075f9:	83 ec 0c             	sub    $0xc,%esp
801075fc:	68 40 87 10 80       	push   $0x80108740
80107601:	e8 8a 8d ff ff       	call   80100390 <panic>
80107606:	8d 76 00             	lea    0x0(%esi),%esi
80107609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107610 <inituvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
80107619:	8b 75 10             	mov    0x10(%ebp),%esi
8010761c:	8b 55 08             	mov    0x8(%ebp),%edx
8010761f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107622:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107628:	77 50                	ja     8010767a <inituvm+0x6a>
8010762a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010762d:	e8 0e af ff ff       	call   80102540 <kalloc>
  memset(mem, 0, PGSIZE);
80107632:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107635:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107637:	68 00 10 00 00       	push   $0x1000
8010763c:	6a 00                	push   $0x0
8010763e:	50                   	push   %eax
8010763f:	e8 2c da ff ff       	call   80105070 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107647:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010764d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80107654:	50                   	push   %eax
80107655:	68 00 10 00 00       	push   $0x1000
8010765a:	6a 00                	push   $0x0
8010765c:	52                   	push   %edx
8010765d:	e8 ee fd ff ff       	call   80107450 <mappages>
  memmove(mem, init, sz);
80107662:	89 75 10             	mov    %esi,0x10(%ebp)
80107665:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107668:	83 c4 20             	add    $0x20,%esp
8010766b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010766e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107671:	5b                   	pop    %ebx
80107672:	5e                   	pop    %esi
80107673:	5f                   	pop    %edi
80107674:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107675:	e9 a6 da ff ff       	jmp    80105120 <memmove>
    panic("inituvm: more than a page");
8010767a:	83 ec 0c             	sub    $0xc,%esp
8010767d:	68 69 87 10 80       	push   $0x80108769
80107682:	e8 09 8d ff ff       	call   80100390 <panic>
80107687:	89 f6                	mov    %esi,%esi
80107689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107690 <loaduvm>:
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
80107696:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107699:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801076a0:	0f 85 91 00 00 00    	jne    80107737 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801076a6:	8b 75 18             	mov    0x18(%ebp),%esi
801076a9:	31 db                	xor    %ebx,%ebx
801076ab:	85 f6                	test   %esi,%esi
801076ad:	75 1a                	jne    801076c9 <loaduvm+0x39>
801076af:	eb 6f                	jmp    80107720 <loaduvm+0x90>
801076b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801076c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801076c7:	76 57                	jbe    80107720 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801076c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801076cc:	8b 45 08             	mov    0x8(%ebp),%eax
801076cf:	31 c9                	xor    %ecx,%ecx
801076d1:	01 da                	add    %ebx,%edx
801076d3:	e8 c8 fb ff ff       	call   801072a0 <walkpgdir>
801076d8:	85 c0                	test   %eax,%eax
801076da:	74 4e                	je     8010772a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801076dc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801076e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801076eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801076f1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076f4:	01 d9                	add    %ebx,%ecx
801076f6:	05 00 00 00 80       	add    $0x80000000,%eax
801076fb:	57                   	push   %edi
801076fc:	51                   	push   %ecx
801076fd:	50                   	push   %eax
801076fe:	ff 75 10             	pushl  0x10(%ebp)
80107701:	e8 5a a2 ff ff       	call   80101960 <readi>
80107706:	83 c4 10             	add    $0x10,%esp
80107709:	39 f8                	cmp    %edi,%eax
8010770b:	74 ab                	je     801076b8 <loaduvm+0x28>
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107715:	5b                   	pop    %ebx
80107716:	5e                   	pop    %esi
80107717:	5f                   	pop    %edi
80107718:	5d                   	pop    %ebp
80107719:	c3                   	ret    
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107723:	31 c0                	xor    %eax,%eax
}
80107725:	5b                   	pop    %ebx
80107726:	5e                   	pop    %esi
80107727:	5f                   	pop    %edi
80107728:	5d                   	pop    %ebp
80107729:	c3                   	ret    
      panic("loaduvm: address should exist");
8010772a:	83 ec 0c             	sub    $0xc,%esp
8010772d:	68 83 87 10 80       	push   $0x80108783
80107732:	e8 59 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107737:	83 ec 0c             	sub    $0xc,%esp
8010773a:	68 0c 88 10 80       	push   $0x8010880c
8010773f:	e8 4c 8c ff ff       	call   80100390 <panic>
80107744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010774a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107750 <allocuvm>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107759:	8b 7d 10             	mov    0x10(%ebp),%edi
8010775c:	85 ff                	test   %edi,%edi
8010775e:	0f 88 db 00 00 00    	js     8010783f <allocuvm+0xef>
  if(newsz < oldsz)
80107764:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107767:	0f 82 e3 00 00 00    	jb     80107850 <allocuvm+0x100>
  a = PGROUNDUP(oldsz);
8010776d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107770:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107776:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010777c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010777f:	0f 86 ce 00 00 00    	jbe    80107853 <allocuvm+0x103>
80107785:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107788:	8b 75 08             	mov    0x8(%ebp),%esi
8010778b:	eb 47                	jmp    801077d4 <allocuvm+0x84>
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107790:	83 ec 04             	sub    $0x4,%esp
80107793:	68 00 10 00 00       	push   $0x1000
80107798:	6a 00                	push   $0x0
8010779a:	50                   	push   %eax
8010779b:	e8 d0 d8 ff ff       	call   80105070 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801077a0:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801077a6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801077ad:	50                   	push   %eax
801077ae:	68 00 10 00 00       	push   $0x1000
801077b3:	53                   	push   %ebx
801077b4:	56                   	push   %esi
801077b5:	e8 96 fc ff ff       	call   80107450 <mappages>
801077ba:	83 c4 20             	add    $0x20,%esp
801077bd:	85 c0                	test   %eax,%eax
801077bf:	0f 88 9b 00 00 00    	js     80107860 <allocuvm+0x110>
  for(; a < newsz; a += PGSIZE){
801077c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077cb:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801077ce:	0f 86 cc 00 00 00    	jbe    801078a0 <allocuvm+0x150>
    mem = kalloc();
801077d4:	e8 67 ad ff ff       	call   80102540 <kalloc>
    if(mem == 0){
801077d9:	85 c0                	test   %eax,%eax
    mem = kalloc();
801077db:	89 c7                	mov    %eax,%edi
    if(mem == 0){
801077dd:	75 b1                	jne    80107790 <allocuvm+0x40>
  if(newsz >= oldsz)
801077df:	8b 45 0c             	mov    0xc(%ebp),%eax
801077e2:	39 45 10             	cmp    %eax,0x10(%ebp)
801077e5:	0f 87 ed 00 00 00    	ja     801078d8 <allocuvm+0x188>
      myproc()->state=SLEEPING;
801077eb:	e8 60 c6 ff ff       	call   80103e50 <myproc>
      acquire(&sleeping_channel_lock);
801077f0:	83 ec 0c             	sub    $0xc,%esp
      myproc()->state=SLEEPING;
801077f3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
      acquire(&sleeping_channel_lock);
801077fa:	68 a0 68 11 80       	push   $0x801168a0
801077ff:	e8 5c d7 ff ff       	call   80104f60 <acquire>
      myproc()->chan=sleeping_channel;
80107804:	e8 47 c6 ff ff       	call   80103e50 <myproc>
80107809:	8b 15 d8 68 11 80    	mov    0x801168d8,%edx
      sleeping_channel_count++;
8010780f:	83 05 c8 b5 10 80 01 	addl   $0x1,0x8010b5c8
      myproc()->chan=sleeping_channel;
80107816:	89 50 20             	mov    %edx,0x20(%eax)
      release(&sleeping_channel_lock);
80107819:	c7 04 24 a0 68 11 80 	movl   $0x801168a0,(%esp)
80107820:	e8 fb d7 ff ff       	call   80105020 <release>
      rpush(myproc());
80107825:	e8 26 c6 ff ff       	call   80103e50 <myproc>
8010782a:	89 04 24             	mov    %eax,(%esp)
8010782d:	e8 1e c1 ff ff       	call   80103950 <rpush>
      if(!swap_out_process_exists){
80107832:	8b 3d b8 b5 10 80    	mov    0x8010b5b8,%edi
80107838:	83 c4 10             	add    $0x10,%esp
8010783b:	85 ff                	test   %edi,%edi
8010783d:	74 71                	je     801078b0 <allocuvm+0x160>
}
8010783f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107842:	31 ff                	xor    %edi,%edi
}
80107844:	89 f8                	mov    %edi,%eax
80107846:	5b                   	pop    %ebx
80107847:	5e                   	pop    %esi
80107848:	5f                   	pop    %edi
80107849:	5d                   	pop    %ebp
8010784a:	c3                   	ret    
8010784b:	90                   	nop
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107850:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	89 f8                	mov    %edi,%eax
80107858:	5b                   	pop    %ebx
80107859:	5e                   	pop    %esi
8010785a:	5f                   	pop    %edi
8010785b:	5d                   	pop    %ebp
8010785c:	c3                   	ret    
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	89 fe                	mov    %edi,%esi
80107865:	68 a1 87 10 80       	push   $0x801087a1
8010786a:	e8 f1 8d ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010786f:	83 c4 10             	add    $0x10,%esp
80107872:	8b 45 0c             	mov    0xc(%ebp),%eax
80107875:	39 45 10             	cmp    %eax,0x10(%ebp)
80107878:	76 0d                	jbe    80107887 <allocuvm+0x137>
8010787a:	89 c1                	mov    %eax,%ecx
8010787c:	8b 55 10             	mov    0x10(%ebp),%edx
8010787f:	8b 45 08             	mov    0x8(%ebp),%eax
80107882:	e8 99 fa ff ff       	call   80107320 <deallocuvm.part.0>
      kfree(mem);
80107887:	83 ec 0c             	sub    $0xc,%esp
      return 0;
8010788a:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010788c:	56                   	push   %esi
8010788d:	e8 7e aa ff ff       	call   80102310 <kfree>
      return 0;
80107892:	83 c4 10             	add    $0x10,%esp
}
80107895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107898:	89 f8                	mov    %edi,%eax
8010789a:	5b                   	pop    %ebx
8010789b:	5e                   	pop    %esi
8010789c:	5f                   	pop    %edi
8010789d:	5d                   	pop    %ebp
8010789e:	c3                   	ret    
8010789f:	90                   	nop
801078a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801078a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a6:	5b                   	pop    %ebx
801078a7:	89 f8                	mov    %edi,%eax
801078a9:	5e                   	pop    %esi
801078aa:	5f                   	pop    %edi
801078ab:	5d                   	pop    %ebp
801078ac:	c3                   	ret    
801078ad:	8d 76 00             	lea    0x0(%esi),%esi
        create_kernel_process("swap_out_process",&swap_out_process_function);
801078b0:	83 ec 08             	sub    $0x8,%esp
        swap_out_process_exists=1;
801078b3:	c7 05 b8 b5 10 80 01 	movl   $0x1,0x8010b5b8
801078ba:	00 00 00 
        create_kernel_process("swap_out_process",&swap_out_process_function);
801078bd:	68 80 43 10 80       	push   $0x80104380
801078c2:	68 74 82 10 80       	push   $0x80108274
801078c7:	e8 a4 d3 ff ff       	call   80104c70 <create_kernel_process>
801078cc:	83 c4 10             	add    $0x10,%esp
801078cf:	eb 82                	jmp    80107853 <allocuvm+0x103>
801078d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078d8:	89 c1                	mov    %eax,%ecx
801078da:	8b 55 10             	mov    0x10(%ebp),%edx
801078dd:	8b 45 08             	mov    0x8(%ebp),%eax
801078e0:	e8 3b fa ff ff       	call   80107320 <deallocuvm.part.0>
801078e5:	e9 01 ff ff ff       	jmp    801077eb <allocuvm+0x9b>
801078ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078f0 <deallocuvm>:
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801078f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801078f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801078fc:	39 d1                	cmp    %edx,%ecx
801078fe:	73 10                	jae    80107910 <deallocuvm+0x20>
}
80107900:	5d                   	pop    %ebp
80107901:	e9 1a fa ff ff       	jmp    80107320 <deallocuvm.part.0>
80107906:	8d 76 00             	lea    0x0(%esi),%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107910:	89 d0                	mov    %edx,%eax
80107912:	5d                   	pop    %ebp
80107913:	c3                   	ret    
80107914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010791a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107920 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	57                   	push   %edi
80107924:	56                   	push   %esi
80107925:	53                   	push   %ebx
80107926:	83 ec 0c             	sub    $0xc,%esp
80107929:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010792c:	85 f6                	test   %esi,%esi
8010792e:	74 59                	je     80107989 <freevm+0x69>
80107930:	31 c9                	xor    %ecx,%ecx
80107932:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107937:	89 f0                	mov    %esi,%eax
80107939:	e8 e2 f9 ff ff       	call   80107320 <deallocuvm.part.0>
8010793e:	89 f3                	mov    %esi,%ebx
80107940:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107946:	eb 0f                	jmp    80107957 <freevm+0x37>
80107948:	90                   	nop
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107950:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107953:	39 fb                	cmp    %edi,%ebx
80107955:	74 23                	je     8010797a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107957:	8b 03                	mov    (%ebx),%eax
80107959:	a8 01                	test   $0x1,%al
8010795b:	74 f3                	je     80107950 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010795d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107962:	83 ec 0c             	sub    $0xc,%esp
80107965:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107968:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010796d:	50                   	push   %eax
8010796e:	e8 9d a9 ff ff       	call   80102310 <kfree>
80107973:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107976:	39 fb                	cmp    %edi,%ebx
80107978:	75 dd                	jne    80107957 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010797a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010797d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107980:	5b                   	pop    %ebx
80107981:	5e                   	pop    %esi
80107982:	5f                   	pop    %edi
80107983:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107984:	e9 87 a9 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107989:	83 ec 0c             	sub    $0xc,%esp
8010798c:	68 bd 87 10 80       	push   $0x801087bd
80107991:	e8 fa 89 ff ff       	call   80100390 <panic>
80107996:	8d 76 00             	lea    0x0(%esi),%esi
80107999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079a0 <setupkvm>:
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	56                   	push   %esi
801079a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801079a5:	e8 96 ab ff ff       	call   80102540 <kalloc>
801079aa:	85 c0                	test   %eax,%eax
801079ac:	89 c6                	mov    %eax,%esi
801079ae:	74 42                	je     801079f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801079b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801079b8:	68 00 10 00 00       	push   $0x1000
801079bd:	6a 00                	push   $0x0
801079bf:	50                   	push   %eax
801079c0:	e8 ab d6 ff ff       	call   80105070 <memset>
801079c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801079c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801079cb:	8b 53 08             	mov    0x8(%ebx),%edx
801079ce:	83 ec 0c             	sub    $0xc,%esp
801079d1:	ff 73 0c             	pushl  0xc(%ebx)
801079d4:	29 c2                	sub    %eax,%edx
801079d6:	50                   	push   %eax
801079d7:	52                   	push   %edx
801079d8:	ff 33                	pushl  (%ebx)
801079da:	56                   	push   %esi
801079db:	e8 70 fa ff ff       	call   80107450 <mappages>
801079e0:	83 c4 20             	add    $0x20,%esp
801079e3:	85 c0                	test   %eax,%eax
801079e5:	78 19                	js     80107a00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079e7:	83 c3 10             	add    $0x10,%ebx
801079ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801079f0:	75 d6                	jne    801079c8 <setupkvm+0x28>
}
801079f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079f5:	89 f0                	mov    %esi,%eax
801079f7:	5b                   	pop    %ebx
801079f8:	5e                   	pop    %esi
801079f9:	5d                   	pop    %ebp
801079fa:	c3                   	ret    
801079fb:	90                   	nop
801079fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107a00:	83 ec 0c             	sub    $0xc,%esp
80107a03:	56                   	push   %esi
      return 0;
80107a04:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107a06:	e8 15 ff ff ff       	call   80107920 <freevm>
      return 0;
80107a0b:	83 c4 10             	add    $0x10,%esp
}
80107a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a11:	89 f0                	mov    %esi,%eax
80107a13:	5b                   	pop    %ebx
80107a14:	5e                   	pop    %esi
80107a15:	5d                   	pop    %ebp
80107a16:	c3                   	ret    
80107a17:	89 f6                	mov    %esi,%esi
80107a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a20 <kvmalloc>:
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a26:	e8 75 ff ff ff       	call   801079a0 <setupkvm>
80107a2b:	a3 d4 68 11 80       	mov    %eax,0x801168d4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a30:	05 00 00 00 80       	add    $0x80000000,%eax
80107a35:	0f 22 d8             	mov    %eax,%cr3
}
80107a38:	c9                   	leave  
80107a39:	c3                   	ret    
80107a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a41:	31 c9                	xor    %ecx,%ecx
{
80107a43:	89 e5                	mov    %esp,%ebp
80107a45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4e:	e8 4d f8 ff ff       	call   801072a0 <walkpgdir>
  if(pte == 0)
80107a53:	85 c0                	test   %eax,%eax
80107a55:	74 05                	je     80107a5c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107a57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a5a:	c9                   	leave  
80107a5b:	c3                   	ret    
    panic("clearpteu");
80107a5c:	83 ec 0c             	sub    $0xc,%esp
80107a5f:	68 ce 87 10 80       	push   $0x801087ce
80107a64:	e8 27 89 ff ff       	call   80100390 <panic>
80107a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a70 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	57                   	push   %edi
80107a74:	56                   	push   %esi
80107a75:	53                   	push   %ebx
80107a76:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a79:	e8 22 ff ff ff       	call   801079a0 <setupkvm>
80107a7e:	85 c0                	test   %eax,%eax
80107a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a83:	0f 84 a2 00 00 00    	je     80107b2b <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a89:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8c:	85 d2                	test   %edx,%edx
80107a8e:	0f 84 97 00 00 00    	je     80107b2b <copyuvm+0xbb>
80107a94:	31 f6                	xor    %esi,%esi
80107a96:	eb 48                	jmp    80107ae0 <copyuvm+0x70>
80107a98:	90                   	nop
80107a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107aa0:	83 ec 04             	sub    $0x4,%esp
80107aa3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107aa9:	68 00 10 00 00       	push   $0x1000
80107aae:	53                   	push   %ebx
80107aaf:	50                   	push   %eax
80107ab0:	e8 6b d6 ff ff       	call   80105120 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107ab5:	58                   	pop    %eax
80107ab6:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107abc:	ff 75 e4             	pushl  -0x1c(%ebp)
80107abf:	50                   	push   %eax
80107ac0:	68 00 10 00 00       	push   $0x1000
80107ac5:	56                   	push   %esi
80107ac6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ac9:	e8 82 f9 ff ff       	call   80107450 <mappages>
80107ace:	83 c4 20             	add    $0x20,%esp
80107ad1:	85 c0                	test   %eax,%eax
80107ad3:	78 6b                	js     80107b40 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107ad5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107adb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ade:	76 4b                	jbe    80107b2b <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae3:	31 c9                	xor    %ecx,%ecx
80107ae5:	89 f2                	mov    %esi,%edx
80107ae7:	e8 b4 f7 ff ff       	call   801072a0 <walkpgdir>
80107aec:	85 c0                	test   %eax,%eax
80107aee:	74 6b                	je     80107b5b <copyuvm+0xeb>
    if(!(*pte & PTE_P))
80107af0:	8b 38                	mov    (%eax),%edi
80107af2:	f7 c7 01 00 00 00    	test   $0x1,%edi
80107af8:	74 54                	je     80107b4e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107afa:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
80107afc:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107b02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107b05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
80107b0b:	e8 30 aa ff ff       	call   80102540 <kalloc>
80107b10:	85 c0                	test   %eax,%eax
80107b12:	89 c7                	mov    %eax,%edi
80107b14:	75 8a                	jne    80107aa0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107b16:	83 ec 0c             	sub    $0xc,%esp
80107b19:	ff 75 e0             	pushl  -0x20(%ebp)
80107b1c:	e8 ff fd ff ff       	call   80107920 <freevm>
  return 0;
80107b21:	83 c4 10             	add    $0x10,%esp
80107b24:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b31:	5b                   	pop    %ebx
80107b32:	5e                   	pop    %esi
80107b33:	5f                   	pop    %edi
80107b34:	5d                   	pop    %ebp
80107b35:	c3                   	ret    
80107b36:	8d 76 00             	lea    0x0(%esi),%esi
80107b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      kfree(mem);
80107b40:	83 ec 0c             	sub    $0xc,%esp
80107b43:	57                   	push   %edi
80107b44:	e8 c7 a7 ff ff       	call   80102310 <kfree>
      goto bad;
80107b49:	83 c4 10             	add    $0x10,%esp
80107b4c:	eb c8                	jmp    80107b16 <copyuvm+0xa6>
      panic("copyuvm: page not present");
80107b4e:	83 ec 0c             	sub    $0xc,%esp
80107b51:	68 f2 87 10 80       	push   $0x801087f2
80107b56:	e8 35 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107b5b:	83 ec 0c             	sub    $0xc,%esp
80107b5e:	68 d8 87 10 80       	push   $0x801087d8
80107b63:	e8 28 88 ff ff       	call   80100390 <panic>
80107b68:	90                   	nop
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b71:	31 c9                	xor    %ecx,%ecx
{
80107b73:	89 e5                	mov    %esp,%ebp
80107b75:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b7e:	e8 1d f7 ff ff       	call   801072a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b85:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b86:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b8d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b90:	05 00 00 00 80       	add    $0x80000000,%eax
80107b95:	83 fa 05             	cmp    $0x5,%edx
80107b98:	ba 00 00 00 00       	mov    $0x0,%edx
80107b9d:	0f 45 c2             	cmovne %edx,%eax
}
80107ba0:	c3                   	ret    
80107ba1:	eb 0d                	jmp    80107bb0 <copyout>
80107ba3:	90                   	nop
80107ba4:	90                   	nop
80107ba5:	90                   	nop
80107ba6:	90                   	nop
80107ba7:	90                   	nop
80107ba8:	90                   	nop
80107ba9:	90                   	nop
80107baa:	90                   	nop
80107bab:	90                   	nop
80107bac:	90                   	nop
80107bad:	90                   	nop
80107bae:	90                   	nop
80107baf:	90                   	nop

80107bb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107bb0:	55                   	push   %ebp
80107bb1:	89 e5                	mov    %esp,%ebp
80107bb3:	57                   	push   %edi
80107bb4:	56                   	push   %esi
80107bb5:	53                   	push   %ebx
80107bb6:	83 ec 1c             	sub    $0x1c,%esp
80107bb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107bc2:	85 db                	test   %ebx,%ebx
80107bc4:	75 40                	jne    80107c06 <copyout+0x56>
80107bc6:	eb 70                	jmp    80107c38 <copyout+0x88>
80107bc8:	90                   	nop
80107bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107bd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107bd3:	89 f1                	mov    %esi,%ecx
80107bd5:	29 d1                	sub    %edx,%ecx
80107bd7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107bdd:	39 d9                	cmp    %ebx,%ecx
80107bdf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107be2:	29 f2                	sub    %esi,%edx
80107be4:	83 ec 04             	sub    $0x4,%esp
80107be7:	01 d0                	add    %edx,%eax
80107be9:	51                   	push   %ecx
80107bea:	57                   	push   %edi
80107beb:	50                   	push   %eax
80107bec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107bef:	e8 2c d5 ff ff       	call   80105120 <memmove>
    len -= n;
    buf += n;
80107bf4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107bf7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107bfa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107c00:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107c02:	29 cb                	sub    %ecx,%ebx
80107c04:	74 32                	je     80107c38 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107c06:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c08:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107c0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107c0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c14:	56                   	push   %esi
80107c15:	ff 75 08             	pushl  0x8(%ebp)
80107c18:	e8 53 ff ff ff       	call   80107b70 <uva2ka>
    if(pa0 == 0)
80107c1d:	83 c4 10             	add    $0x10,%esp
80107c20:	85 c0                	test   %eax,%eax
80107c22:	75 ac                	jne    80107bd0 <copyout+0x20>
  }
  return 0;
}
80107c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c2c:	5b                   	pop    %ebx
80107c2d:	5e                   	pop    %esi
80107c2e:	5f                   	pop    %edi
80107c2f:	5d                   	pop    %ebp
80107c30:	c3                   	ret    
80107c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c3b:	31 c0                	xor    %eax,%eax
}
80107c3d:	5b                   	pop    %ebx
80107c3e:	5e                   	pop    %esi
80107c3f:	5f                   	pop    %edi
80107c40:	5d                   	pop    %ebp
80107c41:	c3                   	ret    
