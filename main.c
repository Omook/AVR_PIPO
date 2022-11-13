#include <avr/io.h>

/*
 * PIPO_optimization
 *
 * Created: 2022-08-31
 * Author : kookmin university - DongHyun Shin
 */ 

	
/*
pipo128 testvector
pt : 0x26, 0x00, 0x27, 0x1E, 0xF6, 0x52, 0x85, 0x09
mk : 0x97, 0x22, 0x15, 0x2E, 0xAD, 0x20, 0x1D, 0x7E,
     0xD2, 0x28, 0x94, 0x77, 0xDD, 0x16, 0xC4 ,0x6D
ct : 0x27, 0x03, 0x5D, 0xAD, 0x81, 0x29, 0x6B, 0x6B
*/

/*
pipo256 testvector
pt : 0x26, 0x00, 0x27, 0x1E, 0xF6, 0x52, 0x85, 0x09
mk : 0x97, 0x22, 0x15, 0x2E, 0xAD, 0x20, 0x1D, 0x7E,
     0xD2, 0x28, 0x94, 0x77, 0xDD, 0x16, 0xC4 ,0x6D,
     0x33, 0x56, 0xD1, 0x26, 0x06, 0x12, 0xA7, 0x54,
     0xB5, 0x6D, 0xA9, 0x76, 0xA4, 0x3A, 0x9A ,0x00
ct : 0x89, 0x38, 0x52, 0xB6, 0x6F, 0xAE, 0x6D, 0x81
*/


/*ctr_mode block_len*/
#define CTR_len		2

void keyadd(uint8_t* val, uint8_t* rk)
{
	val[0] ^= rk[0];
	val[1] ^= rk[1];
	val[2] ^= rk[2];
	val[3] ^= rk[3];
	val[4] ^= rk[4];
	val[5] ^= rk[5];
	val[6] ^= rk[6];
	val[7] ^= rk[7];
}
void sbox(uint8_t *X)
{
	uint8_t T[3] = { 0, };
	//(MSB: x[7], LSB: x[0])
	// Input: x[7], x[6], x[5], x[4], x[3], x[2], x[1], x[0]
	//S5_1
	X[5] ^= (X[7] & X[6]);
	X[4] ^= (X[3] & X[5]);
	X[7] ^= X[4];
	X[6] ^= X[3];
	X[3] ^= (X[4] | X[5]);
	X[5] ^= X[7];
	X[4] ^= (X[5] & X[6]);
	//S3
	X[2] ^= X[1] & X[0];
	X[0] ^= X[2] | X[1];
	X[1] ^= X[2] | X[0];
	X[2] = ~X[2];
	// Extend XOR
	X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
	//S5_2
	T[0] = X[7];	T[1] = X[3];	T[2] = X[4];
	X[6] ^= (T[0] & X[5]);
	T[0] ^= X[6];
	X[6] ^= (T[2] | T[1]);
	T[1] ^= X[5];
	X[5] ^= (X[6] | T[2]);
	T[2] ^= (T[1] & T[0]);
	// Truncate XOR and bit change
	X[2] ^= T[0];	T[0] = X[1] ^ T[2];	X[1] = X[0]^T[1];	X[0] = X[7];	X[7] = T[0];
	T[1] = X[3];	X[3] = X[6];	X[6] = T[1];
	T[2] = X[4];	X[4] = X[5];	X[5] = T[2];
	// Output: (MSb) x[7], x[6], x[5], x[4], x[3], x[2], x[1], x[0] (LSb)
}
void pbox(uint8_t* X)
{
	X[1] = ((X[1] << 7)) | ((X[1] >> 1));
	X[2] = ((X[2] << 4)) | ((X[2] >> 4));
	X[3] = ((X[3] << 3)) | ((X[3] >> 5));
	X[4] = ((X[4] << 6)) | ((X[4] >> 2));
	X[5] = ((X[5] << 5)) | ((X[5] >> 3));
	X[6] = ((X[6] << 1)) | ((X[6] >> 7));
	X[7] = ((X[7] << 2)) | ((X[7] >> 6));

}

void ENC(uint32_t* PLAIN_TEXT, uint32_t* ROUND_KEY, uint32_t* CIPHER_TEXT){
	
	int i = 0;
	uint8_t* P = (uint8_t*)PLAIN_TEXT;
	uint8_t* RK = (uint8_t*)ROUND_KEY;
	
	for(int i=0;i<13;i++){
		sbox(P);
		pbox(P);
		keyadd(P, RK + (i * 8));
	}
	
}

void test_pipo128()
{
	uint8_t mk[16] = { 
		0x97, 0x22, 0x15, 0x2E, 0xAD, 0x20, 0x1D, 0x7E, 
		0xD2, 0x28, 0x94, 0x77, 0xDD, 0x16, 0xC4 ,0x6D};
	uint8_t pt[8] = {
		0x26, 0x00, 0x27, 0x1E, 0xF6, 0x52, 0x85, 0x09};
	uint8_t pt2[8] = {0x00,};
	uint8_t ct[8] = {0x00,};
	uint8_t rk[] = {0x00,};
		
	/* key schedule */	
	//pipo128_keygen(rk, mk);
	//라운드마다 마스터 키를 절반씩 번갈아가면서 라운드키를 생성한다. 
	//암/복호화 시 키스케줄링을 거치지 않고 마스터 키를 번갈아 가며 사용하였다.
	
	/* 1-block encrypt/decrypt*/
	pipo128_encrypt(ct, pt, mk);
	pipo128_decrypt(pt2, ct, mk);
	
	/* CTR encrypt/decrypt*/	
	uint8_t *pt_ctr =(uint8_t*)calloc( CTR_len*8, sizeof(uint8_t));
	uint8_t *pt_ctr2 =(uint8_t*)calloc( CTR_len*8, sizeof(uint8_t));
	//test pt
	pt_ctr[0] = 1;
	pt_ctr[8] = 2;
	uint8_t *ct_ctr =(uint8_t*)calloc(CTR_len*8, sizeof(uint8_t));
	uint8_t iv[6]= {0x00,};	// 2-byte를 counter로 사용한다. 8-> iv : 6, counter : 2
	
	pipo128_ctr_encrypt(ct_ctr, pt_ctr, CTR_len, iv, mk);
	pipo128_ctr_encrypt(pt_ctr2, ct_ctr, CTR_len, iv, mk);
	
}

void test_pipo256()
{
	uint8_t mk[32] = { 
		0x97, 0x22, 0x15, 0x2E, 0xAD, 0x20, 0x1D, 0x7E, 
		0xD2, 0x28, 0x94, 0x77, 0xDD, 0x16, 0xC4 ,0x6D,
	    0x33, 0x56, 0xD1, 0x26, 0x06, 0x12, 0xA7, 0x54, 
		0xB5, 0x6D, 0xA9, 0x76, 0xA4, 0x3A, 0x9A ,0x00};
	uint8_t pt[8] = {
		0x26, 0x00, 0x27, 0x1E, 0xF6, 0x52, 0x85, 0x09};
	uint8_t pt2[8] = {0x00,}; 
	uint8_t ct[8] = {0x00,};
	uint8_t rk[] = {0x00,};
		
	/* key schedule*/
	//pipo256_keygen(rk, mk);
	// 라운드마다 마스터 키를 절반씩 번갈아가면서 라운드키를 생성한다.
	// 암/복호화 시 키스케줄링을 거치지 않고 마스터 키를 번갈아 가며 사용하였다.
	
	/* 1-block encrypt/decrypt*/
	pipo256_encrypt(ct, pt, mk);
	pipo256_decrypt(pt2, ct, mk);
	
	/* CTR encrypt/decrypt*/	
	uint8_t *pt_ctr =(uint8_t*)calloc( CTR_len*8, sizeof(uint8_t));
	uint8_t *pt_ctr2 =(uint8_t*)calloc( CTR_len*8, sizeof(uint8_t));
	//test pt
	pt_ctr[0] = 1;
	pt_ctr[8] = 2;
	uint8_t *ct_ctr =(uint8_t*)calloc(CTR_len*8, sizeof(uint8_t));
	uint8_t iv[6]= {0x00,};	// 2-byte를 counter로 사용한다. 8-> iv : 6, counter : 2
	
	pipo256_ctr_encrypt(ct_ctr, pt_ctr, CTR_len, iv, mk);
	pipo256_ctr_encrypt(pt_ctr2, ct_ctr, CTR_len, iv, mk);
	
}

int main(void)
{
	
	test_pipo128();
	test_pipo256();
	
	return 0;
}
