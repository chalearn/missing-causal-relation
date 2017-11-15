 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-		
			CHALLENGE LEARNING OBJECT PACKAGE (CLOP)   
	A model Matlab(R) package for machine learning challenges
   Isabelle Guyon, Amir Saffari, Gideon Dror, Gavin Cawley, Hugo Jair Escalante
					April 2009  
 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
 
DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS"  ISABELLE GUYON AND/OR OTHER ORGANIZERS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS  FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S  INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER ORGANIZERS  BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS,  MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE.   

This directory contains models for the model selection challenge in the Matlab(R) language.

spider: The spider package from the Max Plank Institute. 
challenge_objects: Additional code prepared for the challenge.  

Unix users: If you want to use the svc object, you must compile the code of the LibSVM package. Go to challenge_objects/packages/libsvm-mat-2.8-1 for instructions.  

To use the rf object, you must first install the R package: http://www.r-project.org/

To use, the package, first add this directory to your matlab path, then run the script use_spider_clop: 
> addpath(this_directory_name); 
> use_spider_clop; 

