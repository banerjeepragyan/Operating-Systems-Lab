#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char* argv[]){
	for(int i=0;i<20;i++){
		if(!fork()){
			printf(1, "Child %d\n", i+1);
			printf(1, "Iteration Matched Different\n");
			int j = 0;
			while(j<10){
				int *arr = malloc(4096);
				for(int k=0;k<1024;k++)arr[k] = k*k- 4*k +1;
				int matched=0;
				for(int k=0;k<1024;k++){
					if(arr[k] == k*k- 4*k +1)matched+=4;
				}
				if(j<9)printf(1, "    %d      %dB      %dB\n", j+1, matched, 4096-matched);
				else printf(1, "   %d      %dB      %dB\n", j+1, matched, 4096-matched);
                
                j++;
				
			}
			
			
			printf(1, "\n");
			
			exit();
		}
	}
	
	
	
	
	while(wait()!=-1);
	exit();

}
