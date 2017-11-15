#ifndef _CMDLINE_H_
#define _CMDLINE_H_


// key , doc, mandatory must be provided

struct cmd_options 
{
	char *key1, *doc;
	int mandatory;
	char *value;
};


class commandline
{
public:
	const char *last_error;
	int parse(int argc,char **argv,cmd_options *opts);
};


extern void print_commandline(cmd_options *opts);

	
#endif