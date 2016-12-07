/********************************************************/
/* CODE TO GENERATE INPUT FILE FOR SPARTA DSMC PROGRAM  */
/* CREATED BY J.O.MACLEOD, UNIVERSITY OF BRISTOL        */
/********************************************************/


#include <iostream>
#include <ios>
#include <iomanip>
#include <algorithm>
#include <numeric>
#include <cmath>
#include <fstream>
#include <float.h>

using std::cout;
using std::cin;
using std::endl;

void generatepoints(void);  //GENERATE GEOMETRY POINTS
void output(void);          //OUTPUT POINTS TO A FILE

int imax=8, stepstart=3, stepend=5;
//double x[9] ={0, 0, 0,    1,   1,   2,   2,  10, 10};
//double y[9] ={0, 0, 0.1, 0.1, 2.1, 2.1, 0.1, 0.1, 0};
double *x = (double *) calloc(imax+1, sizeof(double));
double *y = (double *) calloc(imax+1, sizeof(double));


int main(void) {

generatepoints();


output();

  return 0;
}

void generatepoints(void) {

  int stepstart=3, stepend=5, i;
  double stepheight=2, dx=10/imax;
  x[0]=0;
  y[0]=0;
  x[1]=0;
  y[1]=0.1;

  for (i=2; i<stepstart; i++) {
    y[i]=0.1;
    x[i]=(i-1)*dx;
  }

  y[stepstart]=y[stepstart-1]+stepheight;
  x[stepstart]=x[stepstart-1];

  for (i=stepstart+1; i<=stepend; i++) {
    y[i]=y[1]+stepheight;
    x[i]=(i-2)*dx;
  }

  x[stepend+1]=x[stepend];
  y[stepend+1]=y[1];

  for(i=stepend+2; i<=imax; i++) {
    y[i]=0.1;
    x[i]=i*dx;
  }

  x[imax+1]=x[imax];

}



//WRITE TO FILE
void output(void)	{
		int i;

		std::ofstream myfile;
		myfile.open ("geometry.step");
		myfile << "dummy 2d line test" << endl << endl;
		myfile << imax+2 << " points" << endl;
    myfile << imax+2 << " lines" << endl << endl;

    myfile << "Points" << endl << endl;
    // Write point values to text file.

    for  (i=0; i<=imax+1; i++)
			{
        myfile << i+1 << " " << x[i] << " " << y[i] << " " << endl;
      }

    // Write line ID values to text file
    myfile << endl << "Lines" << endl << endl;
    for (i=0; i<=imax; i++) {
      myfile << i+1 << " " << i+1 << " " << i+2 << endl;
    }

    myfile << imax+2 << " " << imax+2 << " " << "1" << endl;

}
