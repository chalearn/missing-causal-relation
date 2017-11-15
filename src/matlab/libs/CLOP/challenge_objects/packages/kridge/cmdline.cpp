#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#include "cmdline.h"






/** \mainpage A small helper class for commandline parsing!
<pre> Example of usage:

cmd_options opts[]=
{
	// key , doc, mandatory
	{"-i","input file",1},
	{"-o","output file",1},
	{NULL,NULL,0}
};

int main(int argc,char **argv)
{
	
	commandline cmdl;
	if(cmdl.parse(argc,argv,opts)<0)
	{
		
		print_commandline(opts);
		return -1;
	}
	


	for(int i=0;opts[i].key1;i++)
	{
		switch(opts[i].key1[1])
		{
		case 'i':
			printf("Input : %s",opts[i].value);break;
		case 'o':
			printf("Output : %s",opts[i].value);break;
		
		}
	}
	
	return 0;
}

</pre>
**/



int commandline::parse(int argc,char **argv,cmd_options *opts)
{
	int index;
	int max_keys=0;
	int mandatories=0;
	for(index=0;opts[index].key1;index++,max_keys++)
	{
		
		mandatories+=opts[index].mandatory;
	}
	
	for(index=1;index<argc;index++)
	{
	
		rep:

		for(int key=0;key<max_keys&& index<argc;key++)
		{
			if(stricmp(argv[index],opts[key].key1)==0)
			{
				mandatories-=opts[key].mandatory;
				opts[key].value=argv[index+1];
				index+=2;
				goto rep;
			}else
			{
				if(  stricmp(argv[index],"--help")==0
					||
					 stricmp(argv[index],"-h")==0
				)
				{
					last_error="Help wanted.";
					return -3;
				}
			}
			
		}
		
//		if(key==max_keys)
//		{
//			last_error="Unknown option.";
//			return -1;
//		}
	

	}
	
	if(mandatories>0)
	{
		last_error="Forgot an option.";
		return -2;
	}
	return 0;	
}

#ifdef _NEVER_

int main(int argc,char **argv)
{
	
	commandline cmdl;
	if(cmdl.parse(argc,argv,opts)<0)
	{
		
		print_commandline(opts);
		return -1;
	}
	


	for(int i=0;opts[i].key1;i++)
	{
		switch(opts[i].key1[1])
		{
		case 'i':
			printf("Input : %s\n",opts[i].value);break;
		case 'o':
			printf("Output : %s\n",opts[i].value);break;
		
		}
	}
	
	return 0;
}
#endif

void print_commandline(cmd_options *docs)
{
	int index;
	int max_keys=0;
	printf("Build date: %s %s \n",__DATE__,__TIME__);
	printf("Options: \n");
	for(index=0;docs[index].key1;index++,max_keys++)
	{
		printf("%s : %s ",docs[index].key1,docs[index].doc);
		if(docs[index].mandatory)
			printf(" *mandatory* \n");
		else
			printf("\n");
	}
	
	
	
	
	
}