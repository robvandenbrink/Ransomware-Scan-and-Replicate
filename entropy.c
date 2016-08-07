#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

 
int makehist(FILE *fh,int *hist,int len)
	{
	int wherechar[256];
	int i,j,histlen,buflen;
        unsigned char c[102400];          /* define a reasonable buffer to read the file - 1 byte at a time is too slow  */
	histlen=0;
	for(i=0;i<256;i++)wherechar[i]=-1;
	for(i=0;i<len; 1 )
		{
                buflen = fread(&c,sizeof(unsigned char),102400,fh);
                for(j=0;j<buflen;j++)
			{
			if(wherechar[(unsigned int)c[j]]==-1)
				{
				wherechar[(unsigned int)c[j]]=histlen;
				histlen++;
                        	}
			++i;
			hist[wherechar[(unsigned int)c[j]]]++;
			}
		}
	return histlen;
	}
 
double entropy(int *hist,int histlen,int len){
	int i;
	double H;
	H=0;
	for(i=0;i<histlen;i++){
		H-=(double)hist[i]/len*log2((double)hist[i]/len);
	}
	return H;
}
 
main(int argc , char *argv[])
{
	FILE *fh;
	struct stat fileinfo;
	long fsz;
	int len,*hist,histlen;
	double H;
	if ((fh = fopen(argv[1],"rb")) == NULL )
		printf("Error opening file %s\n", argv[1]);
	else
	{
        fstat(fileno(fh),&fileinfo);
        fsz = fileinfo.st_size;
	}
	hist=(int*)calloc(fsz,sizeof(int));
	histlen=makehist(fh,hist,fsz);
	//hist now has no order (known to the program) but that doesn't matter
	H=entropy(hist,histlen,fsz);
	fclose(fh); 
	printf("%lf\n",H);
	return 0;
}