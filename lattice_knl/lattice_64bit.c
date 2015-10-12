/******************************************************************************
 * INTEL CONFIDENTIAL
 *
 *  This file, software, or program is supplied under the terms of a
 *  license agreement or nondisclosure agreement with Intel Corporation
 *  and may not be copied or disclosed except in accordance with the
 *  terms of that agreement.  This file, software, or program contains
 *  copyrighted material and/or trade secret information of Intel
 *  Corporation, and must be treated as such.  Intel reserves all rights
 *  in this material, except as the license agreement or nondisclosure
 *  agreement specifically indicate.
 *
 *****************************************************************************/
 
#include <math.h>
#define OUTER_LOOPS 1000000
#define INNER_LOOPS 4000

#include <stdlib.h>

#define NODE 10 //5^3
#define STEPS 1000

void start_delay() {
  __asm__ (
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $18, %ebx;"   
       "xor %ecx, %ecx;"
       "add %ebx, %ecx;"
       "shl $20, %rcx;"
       "loop_delay_2:"
       "   loop loop_delay_2;"
       );
}

double mabs(double a){	
	int ix1,ix2;
	double* pdbl;
	int* pint;
	pdbl=&a;
	pint=(int*)pdbl;
    	ix1=*pint;
    	pint++;
    	ix2=*pint;
	ix2=ix2&0x7FFFFFFF;
	*pint=ix2;
	return a;
}


#ifdef DML

void sdc() {
  __asm__ (
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $24, %ebx;"
       "xor %eax, %eax;"
       "add %ebx, %eax;"
       "shl $2, %eax;"
       "mov $0x3f8, %dx;"
       "add $1, %eax;"
       "out %al, %dx;" 
       );
	
}

void correct() {

   __asm__
   (
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $24, %ebx;"
       "xor %eax, %eax;"
       "add %ebx, %eax;"
       "shl $2, %eax;"
       "mov $0x3f8, %dx;"
       "out %al, %dx;" 
       "xor %ebx, %ebx;"
   );

}
#else



#include <stdio.h>
void sdc() {
   printf("SDC occurred!");
}

void correct() {
    printf("Correct\n");
}

#endif


int lattice()
{
	

	double m_q;
	double q;
	double kn;
	double me;
	int outer;
	int i;
	int j;
	int k;
	int t;
	double f;

	double d;
	double dd;
	double px;
	double py;
//	double pz;
	double ipx;
	double ipy;
//	double ipz;

	double pitch;
	double dt;
	double fx;
	double fy;
//	double fz;



	double v0x;
	double v0y;
//	double v0z;
	double vfx;
	double vfy;
//	double vfz;
	
	double* pdbl;
	int* pint;

	int ix1, ix2, iy1, iy2;
    // , iz1, iz2;
	int expected_i2=0x40220000;
	int expected_i1=0;
	double expected = 9.0;

	while(1)
	{
			
		for (outer = 0; outer<100000; outer++) 
		{
			q=1;
			kn=1;
			px=9.0;
			py=9.0;
			// pz=9.0;
			pitch=2;
			me=0.01;
			dt=0.01;

			v0x=0;
			v0y=0;
			// v0z=0;
			m_q=q;
			
			for (t=0;t<STEPS;t++){
				fx=0;
				fy=0;
				// fz=0;
				for (i=0;i<NODE;i++){
						for (j=0;j<NODE;j++){
								for (k=0;k<NODE;k++){
										
										ipx=pitch*(double)i;
										ipy=pitch*(double)j;
										// ipz=pitch*(double)k;
										
									
										d=sqrt((px-ipx)*(px-ipx)+(py-ipy)*(py-ipy));
										// d=sqrt((px-ipx)*(px-ipx)+(py-ipy)*(py-ipy)+(pz-ipz)*(pz-ipz));
										f=kn*q*m_q/(pow(d,2));                                        
																													
																				
										// dd=sqrt((py-ipy)*(py-ipy)+(pz-ipz)*(pz-ipz));
										dd=sqrt((py-ipy)*(py-ipy));
										fx=fx+f*(dd/d)*(px-ipx)/mabs(px-ipx);											
																													
																				
										// dd=sqrt((px-ipx)*(px-ipx)+(pz-ipz)*(pz-ipz));
										dd=sqrt((px-ipx)*(px-ipx));
										fy=fy+f*(dd/d)*(py-ipy)/mabs(py-ipy);
																													
																				
										// dd=sqrt((px-ipx)*(px-ipx)+(py-ipy)*(py-ipy));
										// fz=fz+f*(dd/d)*(pz-ipz)/mabs(pz-ipz);
																		
								}
						}
				}
				
				
				vfx=v0x+dt*fx/me;
				vfy=v0y+dt*fy/me;
				//vfz=v0z+dt*fz/me;
				
				px=px+(v0x+vfx)*dt/2;
				py=py+(v0y+vfy)*dt/2;
				//pz=pz+(v0z+vfz)*dt/2;
				
				v0x=(int)(vfx*1e15+0.5)*1e-15;
				v0y=(int)(vfy*1e15+0.5)*1e-15;
				//v0z=(int)(vfz*1e15+0.5)*1e-15;

			}
			
			// Print out the results in doubleing point and in hex format.
			/* pdbl=&px;
			pint=(int*)pdbl;
			ix1=*pint;
			pint++;
			ix2=*pint;
			pdbl=&py;
			pint=(int*)pdbl;
			iy1=*pint;
			pint++;
			iy2=*pint;
			pdbl=&pz;
			pint=(int*)pdbl;
			iz1=*pint;
			pint++;
			iz2=*pint;
            */

			//	if (ix1==expected_i1 && ix2==expected_i2 && iy1==expected_i1 && iy2==expected_i2 && iz1==expected_i1 && iz2==expected_i2) {
			//  call the assembly routine to write 0{CR} to serial port	
			if(px == expected && py == expected){
				correct();
			}
			
			else {
				sdc();
			}
			
				
		}		
	}
}

int main_test()
{
   lattice();
    return(0);
}

int main(){
 
 __asm__ (
       "xor %rbx, %rbx;"
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $24, %ebx;"   
       "xor %rcx, %rcx;"
       
       "add %rbx, %rcx;"
       "shl $25, %rcx;"
       "add $7, %rcx;"
       "loop_delay:;"
       "   nop;"
       "   loop loop_delay;"
       );

main_test();
return(1);
}



