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

int imax=8, m=2, n=2;



double *x = (double *) calloc(imax, sizeof(double));
double *y = (double *) calloc(imax, sizeof(double));

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



  /*
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
  */

  double theta=0, dtheta=2*M_PI/(imax);

  for (i=0; i<=imax; i++) {
    x[i]=0.5*(1+sin(theta));
    y[i]=0.5*(1+cos(theta));

    theta+=dtheta;
    //cout<< x[i] << " " << y[i] << endl;
  }

}


void parameterise(void){
  /* PARAMETERISE USING BEZIER CURVES */
  int i, j, k, g;
  double ymax=*std::max_element(y, y+imax), xmax=*std::max_element(x, x+imax);
  double ymin=*std::min_element(y,y+imax), xmin=*std::min_element(x,x+imax);
  double mfac=1, ifac=1, nfac=1, jfac=1, xfac, yfac, factorial, s, t;
  double xadd, yadd, xadded, yadded;

  double *px = (double *) calloc(m, sizeof(double));
  double *py = (double *) calloc(n, sizeof(double));
  int narraylength=imax*(1+m);
  double *Bx = (double *) calloc(narraylength, sizeof(double));
  narraylength=imax*(n+1);
  double *By = (double *) calloc(narraylength, sizeof(double));

  std::ofstream myfile;
  myfile.open ("parameterisation.txt");
  myfile << "Ymax: " << ymax << " Xmax: " << xmax << " Ymin: " << ymin << " Xmin: " << xmin << endl;
  //myfile << "Parameter Space Coordinates" << endl;

  myfile << std::fixed;
  myfile << std::setprecision(3);


  for (k=1; k<=m; k++){
    mfac*=k;
  }
  for (k=1; k<=n; k++){
    nfac*=k;
  }

  myfile << "M factorial: " << mfac << " N Factorial " << nfac << endl;

  for (i=0; i<=m; i++) {
      // Find the rectangular parameterisation box
      px[i]=xmin+1.0*i/m*(xmax-xmin);


      //Find the factorial of i at point g.
      ifac=1;
      for (k=1; k<=i; k++){
        ifac*=k;
      }

      factorial=1;
      for (k=1; k<= m-i; k++)
        factorial*=k;

      //Find i combination m (m!/(i!(m-i)!))
      if (ifac==mfac)
        xfac=1;
      else
      xfac=mfac/(ifac*factorial);


      for (g=0; g<=imax; g++) {
        //Find the intermediate normalised coordinates.
        s=(x[g]-xmin)/(xmax-xmin);
        //Find the Bernstein Polynomial for each i value.
        Bx[ind(g,i)]=0;
        Bx[ind(g,i)]= xfac*pow(s,i)*pow(1-s,m-i);


      }

  }

  //myfile << endl << "Y-Berstein Polynamials" << endl;
  for (j=0; j<=n; j++){
    py[j]=ymin+1.0*j/n*(ymax-ymin);

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

    for (g=0; g<=imax; g++) {

      t=(y[g]-ymin)/(ymax-ymin);
      By[ind(g,j)]=0;
      By[ind(g,j)]= yfac*pow(t,j)*pow(1-t,n-j);

      //myfile << jfac << " " << yfac << " " << By[ind(g,j)] << endl;
    }
  }

  myfile << endl << "parameterisation Box coordinates" << endl;
  for (i=0; i<=m; i++) {
    for (j=0; j<=n; j++) {
      myfile << px[i] << " " << py[j] << endl;
    }
  }


  myfile << endl << "Berstein Polynamials at each i & j value" << endl;
  myfile << endl << "g   i  X-Berstein Polynamials j  Y-Berstein Polynamials" << endl;
  for (g=0; g<=imax; g++) {
      for (j=0; j<=n; j++) {
        i=j;
        myfile << g << "   " << i << "         " << Bx[ind(g,i)] <<  "           " << j << "         " << By[ind(g,j)] << endl;
      }
  }

  myfile<< endl << "Xbar and Ybar, prior to filling:" << endl;
  for (g=0; g<=imax; g++) {
    myfile << xbar[g] << " " << ybar[g] << endl;
  }

  myfile << endl << "g   i   j   Bx[g,i]*By[g,j]*Px[i]   Bx[g,i]*By[g,j]*Py[j]" << endl;

  //myfile << endl << "X & Y coordinates in the parameter space" << endl;
  //myfile << "g xbar  ybar  x     y      x-xb  y-yb" << endl;

  for (g=0; g<=imax; g++){
    xbar[g]=0.0;
    ybar[g]=0.0;
    xadded=0;
    yadded=0;
    
      for (j=0; j<=n; j++){
        for(i=0; i<=m; i++){
          xadd=Bx[ind(g,i)]*By[ind(g,j)]*px[i];
          yadd=Bx[ind(g,i)]*By[ind(g,j)]*py[j];
          myfile << g << "   " << i << "   " << j << "         " << xadd << "                  " << yadd << endl;
          //cout << g << " " << Bx[ind(g,i)]*By[ind(g,j)]*px[i] << " " << Bx[ind(g,i)]*By[ind(g,j)]*py[j] << endl;
          if (xadd!=0)
          xadded+=xadd;

          if (yadd!=0)
          yadded+=yadd;

          //myfile << g << " "  << xbar[g] << " " << ybar[g] << " " << Bx[ind(g,i)]*By[ind(g,j)]*px[i] << " " << Bx[ind(g,i)]*By[ind(g,j)]*py[j] << " " << x[g]-xbar[g] << " " << y[g]-ybar[g] << endl;

        }
      }
      xbar[g]=xadded;
      ybar[g]=yadded;
      //myfile << g << " " << xbar[g] << " " << ybar[g] << " " << x[g] << " " << y[g] << " " << x[g]-xbar[g] << " " << y[g]-ybar[g] << endl;



  }

  myfile << endl << "X & Y coordinates in the parameter space" << endl;
  for (g=0; g<=imax; g++)
  myfile << g << "      " << xbar[g] << "      " << ybar[g] << "      " << x[g] << "      " << y[g] << "     " << x[g]-xbar[g] << "      " << y[g]-ybar[g] << endl;

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
