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





#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROUND0(a, b, c, d, k, s, t)  ROUND_TAIL(a, b, d ^ (b & (c ^ d)), k, s, t)
#define ROUND1(a, b, c, d, k, s, t)  ROUND_TAIL(a, b, c ^ (d & (b ^ c)), k, s, t)
#define ROUND2(a, b, c, d, k, s, t)  ROUND_TAIL(a, b, b ^ c ^ d        , k, s, t)
#define ROUND3(a, b, c, d, k, s, t)  ROUND_TAIL(a, b, c ^ (b | ~d)     , k, s, t)

#define ROUND_TAIL(a, b, expr, k, s, t)    \
	a += (expr) + UINT32_C(t) + block[k];  \
	a = b + (a << s | a >> (32 - s));




/* Function prototypes */

int self_check();
void md5_hash(uint8_t *message, uint32_t len, uint32_t hash[4]);
void md5_compress(uint32_t state[4], uint32_t block[16]);
void *memset_nik(void *s, int c, size_t n);



/* Self-check */

int self_check() {
	uint32_t hash[4];
	uint8_t msg = 97;
	md5_hash(&msg, 1, hash);
	if 
(hash[0]!=UINT32_C(0xB975C10C)||hash[1]!=UINT32_C(0xA8B6F1C0)||hash[2]!=UINT32_C(0xE299C331)||hash[3]!=UINT32_C(0x61267769)) 
		return 0;
	else
		return 1;
}

/* Full message hasher */

void md5_hash(uint8_t *message, uint32_t len, uint32_t hash[4]) {
	
	uint32_t i;
	uint32_t block[16];
	uint8_t *byteBlock = (uint8_t*)block;
	uint32_t rem;

	hash[0] = UINT32_C(0x67452301);
	hash[1] = UINT32_C(0xEFCDAB89);
	hash[2] = UINT32_C(0x98BADCFE);
	hash[3] = UINT32_C(0x10325476);
	
	
	for (i = 0; i + 64 <= len; i += 64)
		md5_compress(hash, (uint32_t*)(message + i));
	
	
	rem = len - i;
	memcpy(byteBlock, message + i, rem);
	
	byteBlock[rem] = 0x80;
	rem++;
	if (64 - rem >= 8)
		memset_nik(byteBlock + rem, 0, 56 - rem);
	else {
		memset_nik(byteBlock + rem, 0, 64 - rem);
		md5_compress(hash, block);
		memset_nik(block, 0, 56);
	}
	block[14] = len << 3;
	block[15] = len >> 29;
	md5_compress(hash, block);
}

void md5_compress(uint32_t state[4], uint32_t block[16]) {
	uint32_t a = state[0];
	uint32_t b = state[1];
	uint32_t c = state[2];
	uint32_t d = state[3];
	
	ROUND0(a, b, c, d,  0,  7, 0xD76AA478)
	ROUND0(d, a, b, c,  1, 12, 0xE8C7B756)
	ROUND0(c, d, a, b,  2, 17, 0x242070DB)
	ROUND0(b, c, d, a,  3, 22, 0xC1BDCEEE)
	ROUND0(a, b, c, d,  4,  7, 0xF57C0FAF)
	ROUND0(d, a, b, c,  5, 12, 0x4787C62A)
	ROUND0(c, d, a, b,  6, 17, 0xA8304613)
	ROUND0(b, c, d, a,  7, 22, 0xFD469501)
	ROUND0(a, b, c, d,  8,  7, 0x698098D8)
	ROUND0(d, a, b, c,  9, 12, 0x8B44F7AF)
	ROUND0(c, d, a, b, 10, 17, 0xFFFF5BB1)
	ROUND0(b, c, d, a, 11, 22, 0x895CD7BE)
	ROUND0(a, b, c, d, 12,  7, 0x6B901122)
	ROUND0(d, a, b, c, 13, 12, 0xFD987193)
	ROUND0(c, d, a, b, 14, 17, 0xA679438E)
	ROUND0(b, c, d, a, 15, 22, 0x49B40821)
	ROUND1(a, b, c, d,  1,  5, 0xF61E2562)
	ROUND1(d, a, b, c,  6,  9, 0xC040B340)
	ROUND1(c, d, a, b, 11, 14, 0x265E5A51)
	ROUND1(b, c, d, a,  0, 20, 0xE9B6C7AA)
	ROUND1(a, b, c, d,  5,  5, 0xD62F105D)
	ROUND1(d, a, b, c, 10,  9, 0x02441453)
	ROUND1(c, d, a, b, 15, 14, 0xD8A1E681)
	ROUND1(b, c, d, a,  4, 20, 0xE7D3FBC8)
	ROUND1(a, b, c, d,  9,  5, 0x21E1CDE6)
	ROUND1(d, a, b, c, 14,  9, 0xC33707D6)
	ROUND1(c, d, a, b,  3, 14, 0xF4D50D87)
	ROUND1(b, c, d, a,  8, 20, 0x455A14ED)
	ROUND1(a, b, c, d, 13,  5, 0xA9E3E905)
	ROUND1(d, a, b, c,  2,  9, 0xFCEFA3F8)
	ROUND1(c, d, a, b,  7, 14, 0x676F02D9)
	ROUND1(b, c, d, a, 12, 20, 0x8D2A4C8A)
	ROUND2(a, b, c, d,  5,  4, 0xFFFA3942)
	ROUND2(d, a, b, c,  8, 11, 0x8771F681)
	ROUND2(c, d, a, b, 11, 16, 0x6D9D6122)
	ROUND2(b, c, d, a, 14, 23, 0xFDE5380C)
	ROUND2(a, b, c, d,  1,  4, 0xA4BEEA44)
	ROUND2(d, a, b, c,  4, 11, 0x4BDECFA9)
	ROUND2(c, d, a, b,  7, 16, 0xF6BB4B60)
	ROUND2(b, c, d, a, 10, 23, 0xBEBFBC70)
	ROUND2(a, b, c, d, 13,  4, 0x289B7EC6)
	ROUND2(d, a, b, c,  0, 11, 0xEAA127FA)
	ROUND2(c, d, a, b,  3, 16, 0xD4EF3085)
	ROUND2(b, c, d, a,  6, 23, 0x04881D05)
	ROUND2(a, b, c, d,  9,  4, 0xD9D4D039)
	ROUND2(d, a, b, c, 12, 11, 0xE6DB99E5)
	ROUND2(c, d, a, b, 15, 16, 0x1FA27CF8)
	ROUND2(b, c, d, a,  2, 23, 0xC4AC5665)
	ROUND3(a, b, c, d,  0,  6, 0xF4292244)
	ROUND3(d, a, b, c,  7, 10, 0x432AFF97)
	ROUND3(c, d, a, b, 14, 15, 0xAB9423A7)
	ROUND3(b, c, d, a,  5, 21, 0xFC93A039)
	ROUND3(a, b, c, d, 12,  6, 0x655B59C3)
	ROUND3(d, a, b, c,  3, 10, 0x8F0CCC92)
	ROUND3(c, d, a, b, 10, 15, 0xFFEFF47D)
	ROUND3(b, c, d, a,  1, 21, 0x85845DD1)
	ROUND3(a, b, c, d,  8,  6, 0x6FA87E4F)
	ROUND3(d, a, b, c, 15, 10, 0xFE2CE6E0)
	ROUND3(c, d, a, b,  6, 15, 0xA3014314)
	ROUND3(b, c, d, a, 13, 21, 0x4E0811A1)
	ROUND3(a, b, c, d,  4,  6, 0xF7537E82)
	ROUND3(d, a, b, c, 11, 10, 0xBD3AF235)
	ROUND3(c, d, a, b,  2, 15, 0x2AD7D2BB)
	ROUND3(b, c, d, a,  9, 21, 0xEB86D391)
	
	state[0] += a;
	state[1] += b;
	state[2] += c;
	state[3] += d;
}

void *memset_nik(void *s, int c, size_t n)
{
    unsigned char* p = (unsigned char*)s;
    while(n--)
        *p++ = (unsigned char)c;
    return s;
}


void start_delay() {
  __asm__ (
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $18, %ebx;"   /* cpuid is bits 24-31 */
       "xor %ecx, %ecx;"
       "add %ebx, %ecx;"
       "shl $20, %rcx;"
       "loop_delay_2:"
       "   loop loop_delay_2;"
       );
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

int main_test()
{
   // start_delay();
    int i = 0;
    int j = 0;
    int k = 0;
	int a = 4;
	int b = 5;
	int c = 0;
	int is_passed = 0;
    while(1){
      for(i = 0; i <= INNER_LOOPS; i++) {
          for(k = 0; k <= OUTER_LOOPS; k++)
		  {
			is_passed = self_check();
			if(is_passed == 0)
				sdc();
			else if(is_passed == 1)
				correct();
		  
		  }
          for(k = 0; k <= OUTER_LOOPS; k++)
          {
            j = j - 1;
			is_passed = self_check();
			if(is_passed == 0)
				sdc();
			else if(is_passed == 1)
				correct();

		  }

         if (j!=0) {
             sdc();
             while(1){}
         }
      }
      correct();
    }
    return(0);
}

int main(){
  __asm__ (
       "xor %eax, %eax;"
       "mov $0x01, %eax;"
       "cpuid;"
       "shr $24, %ebx;"   /* cpuid is bits 24-31 */
       "xor %ecx, %ecx;"
       "add %ebx, %ecx;"
       "shl $25, %rcx;"
       "add $7, %ecx;"
       "loop_delay:;"
       "   nop;"
       "   loop loop_delay;"
       );
main_test();
return(1);
}

