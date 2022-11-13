#ifndef _SHA3_H_
#define _SHA3_H_




#ifdef __cplusplus
extern "C"
{
#endif



	int sha3_hash(uint8_t* output, int outLen, uint8_t* input, int inLen, int bitSize, int useSHAKE);

#else

#endif
