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
void parameterise(void);    //PARAMETERISE GEOMETRY FOR DEFORMATIVE METHOD
void output(void);          //OUTPUT POINTS TO A FILE
int ind(int, int);          //index function

int imax=8, jmax=2, m= 10, n=2;
int narraylength=(imax+1)*(jmax+1);


double *x = (double *) calloc(imax+1, sizeof(double));
double *y = (double *) calloc(imax+1, sizeof(double));

double *xbar = (double *) calloc(narraylength, sizeof(double));
double *ybar = (double *) calloc(narraylength, sizeof(double));


int main(void) {

generatepoints();

parameterise();

output();

  return 0;
}

void generatepoints(void) {

  int stepstart=3, stepend=5, i;
  double plateheight=0.5, stepheight=2, dx=10/imax;
  x[0]=0;
  y[0]=0;
  x[1]=0;
  y[1]=plateheight;

  for (i=2; i<stepstart; i++) {
    y[i]=plateheight;
    x[i]=(i-1)*dx;
  }

  y[stepstart]=plateheight+stepheight;
  x[stepstart]=x[stepstart-1];

  for (i=stepstart+1; i<=stepend; i++) {
    y[i]=plateheight+stepheight;
    x[i]=(i-2)*dx;
  }

  x[stepend+1]=x[stepend];
  y[stepend+1]=plateheight;

  for(i=stepend+2; i<=imax; i++) {
    y[i]=plateheight;
    x[i]=i*dx;
  }

  x[imax+1]=x[imax];

}


void parameterise(void){
  /* PARAMETERISE USING BEZIER CURVES */
  int i, j, k, g;
  double ymax=*std::max_element(y, y+imax);
  double mfac=1, ifac=1, nfac=1, jfac=1, xfac, yfac;
  double *s = (double *) calloc(narraylength, sizeof(double));
  double *t = (double *) calloc(narraylength, sizeof(double));
  double *px = (double *) calloc(narraylength, sizeof(double));
  double *py = (double *) calloc(narraylength, sizeof(double));
  double *Bx = (double *) calloc(narraylength, sizeof(double));
  double *By = (double *) calloc(narraylength, sizeof(double));



  for (i=0; i<=m; i++) {
    for (j=0; j<=n; j++){

      // Find the rectangular parameterisation box
      px[ind(i,j)]=x[0]+i/m*(x[imax]-x[0]);
      py[ind(i,j)]=y[0]+j/n*(ymax-y[0]);

      //Find the intermediate normalised coordinates.
      s[ind(i,j)]=(x[i]-y[0])/(ymax-y[0]);
      t[ind(i,j)]=(y[i]-x[0])/(x[imax]-x[0]);

    }
  }

  //Find the factorials of m and n
  for (k=1; k<=m; k++){
    mfac*=k;
  }
  for (k=1; k<=n; k++){
    nfac*=k;
  }
  //Find the Bernstein Polynomials of s and t.
  for (j=0; j<=n; j++) {
    for (i=0; i<=m; i++) {

      for (g=0; g<=m; g++){
        //Find the factorial of i at point g.
        ifac=1;
        for (k=1; k<=g; k++){
          ifac*=k;
        }

        if (i==0)
          xfac=1;
        else
          xfac=mfac/(ifac*(mfac-ifac));

        //Find the Bernstein Polynomial for each i value.
        Bx[ind(i,j)]= xfac*pow(s[ind(i,j)],g)*pow(1-s[ind(i,j)],m-g);
      }

      for (g=0; g<=n; g++){
        jfac=1;
        for (k=1; k<=g; k++){
          jfac*=k;
        }

        if (g==0)
          xfac=1;
        else
          yfac=nfac/(jfac*(nfac-jfac));

        By[ind(i,j)]= yfac*pow(t[ind(i,j)],g)*pow(1-t[ind(i,j)],n-g);
      }

    }
  }
  for (i=0; i<=imax; i++){
    for (j=0;j<=jmax;j++) {
      for (g=0; g<=m; g++){
        for(k=0; k<=n; k++) {

          xbar[ind(i,j)]+=Bx[ind(g,k)]*By[ind(g,k)]*px[ind(g,k)];
          ybar[ind(i,j)]+=Bx[ind(g,k)]*By[ind(g,k)]*py[ind(g,k)];

        }
      }
      cout << xbar << " " << ybar << endl;
    }
  }
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

int ind(int ivalue, int jvalue)
{
   return ivalue + jvalue*(imax);
}
