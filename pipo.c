
#include "PIPO.h"

void pipo128_keygen(uint8_t* rks, const uint8_t* mk)
{		
	for(int i=0; i<32;i++){
		rks[i] = mk[i];
	}
}



void pipo128_ctr_encrypt(uint8_t* dst, const uint8_t* src, const uint16_t src_len, const uint8_t* iv, const uint8_t* rks)
{
	uint8_t iv_counter[8] = {0x00,};
	
	for(int i=2;i<8;i++){
		iv_counter[i] = iv[i-2];
	}
	
	for(int i=0; i<src_len;i++){
		pipo128_encrypt((dst+8*i),iv_counter,rks);
		
		for(int j=0; j<8; j++){
			dst[i*8+j] ^= src[i*8+j];
		}
		
		iv_counter[0]++;
		if(iv_counter[0] == 0){
			iv_counter[1]++;
		}
	}	
}

void pipo256_keygen(uint8_t* rks, const uint8_t* mk)
{
	for(int i=0; i<64;i++){
		rks[i] = mk[i];
	}	
}



void pipo256_ctr_encrypt(uint8_t* dst, const uint8_t* src, const uint16_t src_len, const uint8_t* iv, const uint8_t* rks)
{
	uint8_t iv_counter[8] = {0x00,};
	
	for(int i=2;i<8;i++){
		iv_counter[i] = iv[i-2];
	}
	
	for(int i=0; i<src_len;i++){
		pipo128_encrypt((dst+8*i),iv_counter,rks);
		
		for(int j=0; j<8; j++){
			dst[i*8+j] ^= src[i*8+j];
		}
		
		iv_counter[0]++;
		if(iv_counter[0] == 0){
			iv_counter[1]++;
		}
	}	
}

