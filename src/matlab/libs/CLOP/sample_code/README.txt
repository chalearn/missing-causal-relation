-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o
			Challenge Sample Code in Matlab         		
			Isabelle Guyon -- September 2005  
-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o

DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA  ARE PROVIDED "AS-IS" ISABELLE GUYON AND/OR OTHER ORGANIZERS  DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS  FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT  OF ANY THIRD PARTY'S INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT  SHALL ISABELLE GUYON AND/OR OTHER ORGANIZERS BE LIABLE FOR ANY  SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF  SOFTWARE, DOCUMENTS, MATERIALS, PUBLICATIONS, OR INFORMATION MADE  AVAILABLE FOR THE CHALLENGE.   

This directory contains sample code for the model selection challenge in the Matlab(R) language. The sample code includes functions to read the data, and format and zip the results. It contains functions to compute the balanced error rate (BER) and the area under the ROC curve (AUC). Those functions are  also provided in C++, and as windows executables (courtesy of Steve Gunn): 
berrate data.labels data.resu 
auc data.labels data.resu data.conf  
To run the Matlab examples, edit main.m to set the data and result path properly, then type at the Matlab prompt: 
> main;    