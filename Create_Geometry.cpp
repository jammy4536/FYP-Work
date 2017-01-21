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



double *x = (double *) calloc(imax+1, sizeof(double));
double *y = (double *) calloc(imax+1, sizeof(double));

double *xbar = (double *) calloc(m, sizeof(double));
double *ybar = (double *) calloc(n, sizeof(double));


int main(void) {

generatepoints();

parameterise();

output();

  return 0;
}

void generatepoints(void) {

  int steptop=3, stepend=5, i;
  double stepheight=2, dx=10/imax;
  x[0]=0;
  y[0]=0;


  for (i=1; i<=steptop; i++) {
    y[i]=stepheight*(1.0*i/steptop);
    x[i]=0;
  }

  for (i=steptop+1; i<=stepend; i++) {
    y[i]=stepheight;
    x[i]=(i-steptop)*dx;
  }

  for(i=stepend+1; i<=imax; i++) {
    y[i]=stepheight*(1-(1.0*i-stepend)/steptop);;
    x[i]=x[i-1];
  }



}


void parameterise(void){
  /* PARAMETERISE USING BEZIER CURVES */
  int i, j, k, g;
  double ymax=*std::max_element(y, y+imax), xmax=*std::max_element(x, x+imax);
  double mfac=1, ifac=1, nfac=1, jfac=1, xfac, yfac, factorial;


  double *s = (double *) calloc(m, sizeof(double));
  double *t = (double *) calloc(n, sizeof(double));
  double *px = (double *) calloc(m, sizeof(double));
  double *py = (double *) calloc(n, sizeof(double));
  double *Bx = (double *) calloc(m, sizeof(double));
  double *By = (double *) calloc(n, sizeof(double));

  std::ofstream myfile;
  myfile.open ("parameterisation.txt");
  //myfile << "Ymax: " << ymax << " Xmax: " << xmax << endl;
  myfile << "Parameter Space Coordinates" << endl;

  myfile << std::fixed;
  myfile << std::setprecision(3);


  for (i=0; i<=m; i++) {
    for (j=0; j<=n; j++){

      // Find the rectangular parameterisation box
      px[i]=x[0]+1.0*i/m*(xmax-x[0]);
      py[j]=y[0]+1.0*j/n*(ymax-y[0]);

      //Find the intermediate normalised coordinates.
      s[i]=(x[i]-y[0])/(ymax-y[0]);
      t[j]=(y[i]-x[0])/(xmax-x[0]);
      myfile << px[i] << " " << py[j] << " " << s[i] << " " << t[j] << endl;
    }
  }

  //myfile << endl << "M and N factorials" << endl;
  //Find the factorials of m and n
  for (k=1; k<=m; k++){
    mfac*=k;
  }
  for (k=1; k<=n; k++){
    nfac*=k;
  }

  //myfile << mfac << " " << nfac << endl;
  myfile << endl << "Berstein Polynamials at each i & j value" << endl;

  //Find the Bernstein Polynomials of s and t.
  for (j=0; j<=n; j++) {
    for (i=0; i<=m; i++) {


        //Find the factorial of i at point g.
        ifac=1;
        for (k=1; k<=i; k++){
          ifac*=k;
        }

        factorial=1;
        for (k=1; k<= m-i; k++)
          factorial*=k;

        //Find x combination m (m!/(i!(m-i)!))
        if (ifac==mfac)
          xfac=1;
        else
        xfac=mfac/(ifac*factorial);

        //Find the Bernstein Polynomial for each i value.
        Bx[i]= xfac*pow(s[i],i)*pow(1-s[i],m-i);


        //Find the factorial of j at point g
        jfac=1;
        for (k=1; k<=j; k++){
          jfac*=k;
        }

        factorial=1;
        for (k=1; k<= n-j; k++)
          factorial*=k;

        //Find y combination m (m!/(i!(m-i)!))
        if (jfac==nfac)
          yfac=1;
        else
        yfac=nfac/(jfac*factorial);

        By[j]= yfac*pow(t[j],j)*pow(1-t[j],n-j);

        myfile << i << " " << j << " " << xfac << " " << Bx[i] << " " << yfac << " " << By[j] << endl;
    }
  }
  myfile << endl << "X & Y coordinates in the parameter space" << endl;
  for (i=0; i<=imax; i++){
    for (j=0;j<=jmax;j++) {
      for (g=0; g<=m; g++){
        for(k=0; k<=n; k++) {

          xbar[i]+=Bx[g]*By[k]*px[g];
          ybar[j]+=Bx[g]*By[k]*py[k];

        }
      }

      myfile << xbar[i] << " " << ybar[j] << endl;


    }
  }

  myfile.close();
}



//WRITE TO FILE
void output(void)	{
		int i;

		std::ofstream myfile;
		myfile.open ("geometry.step");
		myfile << "dummy 2d line test" << endl << endl;
		myfile << imax+1 << " points" << endl;
    myfile << imax+1 << " lines" << endl << endl;

    myfile << "Points" << endl << endl;
    // Write point values to text file.

    for  (i=0; i<=imax; i++)
			{
        myfile << i+1 << " " << x[i] << " " << y[i] << " " << endl;
      }

    // Write line ID values to text file
    myfile << endl << "Lines" << endl << endl;
    for (i=0; i<imax; i++) {
      myfile << i+1 << " " << i+1 << " " << i+2 << endl;
    }

    myfile << imax+1 << " " << imax+1 << " " << "1" << endl;
    myfile.close();
}

int ind(int ivalue, int jvalue)
{
   return ivalue + jvalue*(imax);
}
