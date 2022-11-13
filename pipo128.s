
.global pipo128_encrypt
.type pipo128_encrypt, @function


   #define X0 R16
   #define X1 R17
   #define X2 R18
   #define X3 R19
   #define X4 R20
   #define X5 R21
   #define X6 R22
   #define X7 R23

   #define T0 R24
   #define T1 R25
   #define T2 R30
   #define T3 R31

   #define RK0_0 R0
   #define RK0_1 R1
   #define RK0_2 R2
   #define RK0_3 R3
   #define RK0_4 R4
   #define RK0_5 R5
   #define RK0_6 R6
   #define RK0_7 R7

   #define RK1_0 R8
   #define RK1_1 R9
   #define RK1_2 R10
   #define RK1_3 R11
   #define RK1_4 R12
   #define RK1_5 R13
   #define RK1_6 R14
   #define RK1_7 R15

   #define CNT R26
  

pipo128_encrypt:
	

	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	PUSH R16
	PUSH R17	
	PUSH R28
	PUSH R29

	MOVW R28, R24
	MOVW R26, R22
	MOVW R30, R20

	LD RK0_0, Z+
	LD RK0_1, Z+
	LD RK0_2, Z+
	LD RK0_3, Z+
	LD RK0_4, Z+
	LD RK0_5, Z+
	LD RK0_6, Z+
	LD RK0_7, Z+
	LD RK1_0, Z+
	LD RK1_1, Z+
	LD RK1_2, Z+
	LD RK1_3, Z+
	LD RK1_4, Z+
	LD RK1_5, Z+
	LD RK1_6, Z+
	LD RK1_7, Z+

	LD X0, X+
	LD X1, X+
	LD X2, X+
	LD X3, X+
	LD X4, X+
	LD X5, X+
	LD X6, X+
	LD X7, X+	
	

	CLR R26 //R26 = round count


																		 //round 0
	EOR RK0_0, R26															//RK 0
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, R26
   	
	MOV T0, X7		// X[5] ^= (X[7] & X[6]);						//S_LAYER 0
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X1		// X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X7, X1		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

					// S5_2
   MOV T0, X7		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X1, T2		// T[0] = X[1] ^ T[2];
   

   EOR X0, T1		// X[1] = X[0]^T[1];
   
   		
	CLR T0															//R_LAYER0
  				// left rotate 0

   BST X0, 0	// left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1		// left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  	

	INC R26													//round 1

	EOR RK1_0, R26												//RK 1
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, R26 	

	MOV T0, X1		// X[5] ^= (X[7] & X[6]);					//S_LAYER 1
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X1, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X1		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X0		// X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X1, X0		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X7

					// S5_2
   MOV T0, X1		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X0, T2		// T[0] = X[1] ^ T[2];
   

   EOR X7, T1		// X[1] = X[0]^T[1];		
	
	CLR T0																	//R_LAYER 1
  				// left rotate 0

   BST X7, 0	// left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X0		// left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  
	
	INC R26																//round2
	EOR RK0_0, R26														//RK 2
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, R26 	

	 MOV T0, X0		// X[5] ^= (X[7] & X[6]);								//S_LAYER 2
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X0, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X0		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X7		// X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X0, X7		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

					// S5_2
   MOV T0, X0		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X7, T2		// T[0] = X[1] ^ T[2];
   

   EOR X1, T1		// X[1] = X[0]^T[1];			
	
		
	CLR T0															//R_LAYER2
  				// left rotate 0

   BST X1, 0	// left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X7		// left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

	INC R26																	//round 3	
	
	EOR RK1_0, R26															//RK3
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, R26
   	
	
	 MOV T0, X7		// X[5] ^= (X[7] & X[6]);								//S_LAYER3
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X7, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X7		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X1		// X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X7, X1		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X0

					// S5_2
   MOV T0, X7		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X1, T2		// T[0] = X[1] ^ T[2];
   

   EOR X0, T1		// X[1] = X[0]^T[1];
   			
	CLR T0															//R_LAYER 3
  				// left rotate 0

   BST X0, 0	// left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X1		// left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  
	
	INC R26																//round 4

	EOR RK0_0, R26														//RK 4
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, R26
   	
	MOV T0, X1		// X[5] ^= (X[7] & X[6]);							//S_LAYER4
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X1, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X1		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X0		// X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X1, X0		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

					// S5_2
   MOV T0, X1		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X0, T2		// T[0] = X[1] ^ T[2];
   

   EOR X7, T1		// X[1] = X[0]^T[1];
   		
	CLR T0														//R_LAYER4
  				// left rotate 0

   BST X7, 0	// left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X0		// left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  	

	INC R26												//round 5	

	EOR RK1_0, R26																//RK5
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X0, RK1_7
   EOR RK1_0, R26


   MOV T0, X0		// X[5] ^= (X[7] & X[6]);								//S_LAYER5
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X0, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X0		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X7		// X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X0, X7		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X1

					// S5_2
   MOV T0, X0		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X7, T2		// T[0] = X[1] ^ T[2];
   

   EOR X1, T1		// X[1] = X[0]^T[1];										//R_LAYER5

     CLR T0
  				// left rotate 0

   BST X1, 0	// left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X7		// left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

   ///////////////////////////////////////////round6/////////////////////////////////////////////////////////
 	INC R26
	
																		 //round 6
	EOR RK0_0, R26															//RK 6
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, R26
   	
	MOV T0, X7		// X[5] ^= (X[7] & X[6]);						//S_LAYER 6
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X1		// X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X7, X1		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

					// S5_2
   MOV T0, X7		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X1, T2		// T[0] = X[1] ^ T[2];
   

   EOR X0, T1		// X[1] = X[0]^T[1];
   
   		
	CLR T0															//R_LAYER6
  				// left rotate 0

   BST X0, 0	// left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1		// left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  	

	INC R26													//round 7

	EOR RK1_0, R26												//RK 7
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, R26 	

	MOV T0, X1		// X[5] ^= (X[7] & X[6]);					//S_LAYER 7
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X1, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X1		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X0		// X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X1, X0		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X7

					// S5_2
   MOV T0, X1		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X0, T2		// T[0] = X[1] ^ T[2];
   

   EOR X7, T1		// X[1] = X[0]^T[1];		
	
	CLR T0																	//R_LAYER 7
  				// left rotate 0

   BST X7, 0	// left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X0		// left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  
	
	INC R26																//round8
	EOR RK0_0, R26														//RK 8
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, R26 	

	 MOV T0, X0		// X[5] ^= (X[7] & X[6]);								//S_LAYER 8
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X0, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X0		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X7		// X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X0, X7		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

					// S5_2
   MOV T0, X0		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X7, T2		// T[0] = X[1] ^ T[2];
   

   EOR X1, T1		// X[1] = X[0]^T[1];			
	
		
	CLR T0															//R_LAYER8
  				// left rotate 0

   BST X1, 0	// left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X7		// left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

	INC R26																	//round 9	
	
	EOR RK1_0, R26															//RK9
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, R26
   	
	
	 MOV T0, X7		// X[5] ^= (X[7] & X[6]);								//S_LAYER9
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X7, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X7		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X1		// X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X7, X1		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X0

					// S5_2
   MOV T0, X7		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X1, T2		// T[0] = X[1] ^ T[2];
   

   EOR X0, T1		// X[1] = X[0]^T[1];
   			
	CLR T0															//R_LAYER 9
  				// left rotate 0

   BST X0, 0	// left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X1		// left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  
	
	INC R26																//round 10

	EOR RK0_0, R26														//RK 10
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, R26
   	
	MOV T0, X1		// X[5] ^= (X[7] & X[6]);							//S_LAYER10
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X1, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X1		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X0		// X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X1, X0		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

					// S5_2
   MOV T0, X1		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X0, T2		// T[0] = X[1] ^ T[2];
   

   EOR X7, T1		// X[1] = X[0]^T[1];
   		
	CLR T0														//R_LAYER10
  				// left rotate 0

   BST X7, 0	// left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X0		// left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  	

	INC R26												//round 11	

	EOR RK1_0, R26																//RK5
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X0, RK1_7
   EOR RK1_0, R26


   MOV T0, X0		// X[5] ^= (X[7] & X[6]);								//S_LAYER5
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6		// X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X0, X5		// X[7] ^= X[4];
   EOR X3, X6		// X[6] ^= X[3];

   MOV T0, X5		// X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X0		// X[5] ^= X[7];

   MOV T0, X4		// X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

					//S3
   MOV T0, X7		// X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X0, X7		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X1

					// S5_2
   MOV T0, X0		// T[0] = X[7];
   MOV T1, X6		// T[1] = X[3];
   MOV T2, X5		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4		// T[1] ^= X[5];

   MOV T3, X3		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X7, T2		// T[0] = X[1] ^ T[2];
   

   EOR X1, T1		// X[1] = X[0]^T[1];										//R_LAYER5

     CLR T0
  				// left rotate 0

   BST X1, 0	// left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2		// left rotate 4
   

   SWAP X3		// left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4		// left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6		// left rotate 1      
   ADC X6, T0

   LSL X7		// left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  
   //////////////////////////////////////////////////////////////round 12
   INC R26
	
																		 //round 12
	EOR RK0_0, R26															//RK 12
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, R26
   	
	MOV T0, X7		// X[5] ^= (X[7] & X[6]);						//S_LAYER 12
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3		// X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4		// X[7] ^= X[4];
   EOR X6, X3		// X[6] ^= X[3];

   MOV T0, X4		// X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7		// X[5] ^= X[7];

   MOV T0, X5		// X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

					//S3
   MOV T0, X1		// X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2		// X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2		// X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2			// X[2] = ~X[2];
   SUBI X2, 1 

					// Extend XOR
   EOR X7, X1		// X[7] ^= X[1];	X[3] ^= X[2];	X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

					// S5_2
   MOV T0, X7		// T[0] = X[7];
   MOV T1, X3		// T[1] = X[3];
   MOV T2, X4		// T[2] = X[4];

   MOV T3, T0		// X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6		// T[0] ^= X[6];

   MOV T3, T2		// X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5		// T[1] ^= X[5];

   MOV T3, X6		// X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1		// T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

					// Truncate XOR and bit change
   EOR X2, T0		// X[2] ^= T[0];
   
   EOR X1, T2		// T[0] = X[1] ^ T[2];
   

   EOR X0, T1		// X[1] = X[0]^T[1];
   
   		
	CLR T0															//R_LAYER12
  				// left rotate 0

   BST X0, 0	// left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2		// left rotate 4
   

   LSL X3		// left rotate 1      
   ADC X3, T0 
   
   SWAP X4		// left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5		// left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6		// left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1		// left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0



		///////////////////////////////////////////////////////////round13
	INC R26
	EOR RK1_0, R26
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, R26	
	
	
	ST Y+, X7
	ST Y+, X0
	ST Y+, X2
	ST Y+, X6
	ST Y+, X5
	ST Y+, X4
	ST Y+, X3
	ST Y+, X1

	POP R29
	POP R28
	POP R17
	POP R16
	POP R15
	POP R14
	POP R13
	POP R12
	POP R11
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	
	RET
/*****************************************************************************
*                                                          *
*                                                          *
*                     decryption
*                                                          *
*                                                          *
******************************************************************************/
.global pipo128_decrypt
.type pipo128_decrypt, @function

 
   
  #define X0 R18
   #define X1 R19
   #define X2 R20
   #define X3 R21
   #define X4 R22
   #define X5 R23
   #define X6 R24
   #define X7 R25

   #define T0 R30
   #define T1 R31
   #define T2 R0
   #define T3 R1

   #define RK0_0 R2
   #define RK0_1 R3
   #define RK0_2 R4
   #define RK0_3 R5
   #define RK0_4 R6
   #define RK0_5 R7
   #define RK0_6 R8
   #define RK0_7 R9

   #define RK1_0 R10
   #define RK1_1 R11
   #define RK1_2 R12
   #define RK1_3 R13
   #define RK1_4 R14
   #define RK1_5 R15
   #define RK1_6 R16
   #define RK1_7 R17

   #define CNT R26

pipo128_decrypt:
   

   PUSH R0
   PUSH R1
   PUSH R2
   PUSH R3
   PUSH R4
   PUSH R5
   PUSH R6
   PUSH R7
   PUSH R8
   PUSH R9
   PUSH R10
   PUSH R11
   PUSH R12
   PUSH R13
   PUSH R14
   PUSH R15
   PUSH R16
   PUSH R17
   PUSH R28
   PUSH R29

   MOVW R28, R24   //pt --> Y
   MOVW R26, R22   //ct --> X
   MOVW R30, R20   //mk --> Z

   LD RK0_0, Z+
   LD RK0_1, Z+
   LD RK0_2, Z+
   LD RK0_3, Z+
   LD RK0_4, Z+
   LD RK0_5, Z+
   LD RK0_6, Z+
   LD RK0_7, Z+
   LD RK1_0, Z+
   LD RK1_1, Z+
   LD RK1_2, Z+
   LD RK1_3, Z+
   LD RK1_4, Z+
   LD RK1_5, Z+
   LD RK1_6, Z+
   LD RK1_7, Z+

   LD X0, X+
   LD X1, X+
   LD X2, X+
   LD X3, X+
   LD X4, X+
   LD X5, X+
   LD X6, X+
   LD X7, X+

   PUSH R26   

   

   LDI CNT, 13 // Round cnt = 13--

//DE_LOOP_IN:
															//round 13
   EOR RK1_0, CNT											//RK
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1


     CLR T0													//R_LAYER
              // left rotate 0      
               
   LSL X1      // left rotate 1      
   ADC X1, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X7      // left rotate 6      
   LSL X7
   ADC X7, T0
   LSL X7
   ADC X7, T0   

																	//S_LAYER
   MOV T0, X0
   MOV T1, X6
   MOV T2, X5
             // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X0   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X1, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X7, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X0, X7   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5, X0   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X0, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X0
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X1   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[2] ^= X[1] & X[0];
   AND T3, X7
   EOR X2, T3


																		//round12

  EOR RK0_0, CNT
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1

																	//R_LAYER
  CLR T0
              // left rotate 0      
               
   LSL X7      // left rotate 1      
   ADC X7, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X0      // left rotate 6      
   LSL X0
   ADC X0, T0
   LSL X0
   ADC X0, T0   

																	//_SLAYER
   MOV T0, X1
   MOV T1, X6
   MOV T2, X5
     // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X1   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X7, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X0, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X1, X0   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X1   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X1, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X1
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X7   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[2] ^= X[1] & X[0];
   AND T3, X0
   EOR X2, T3

																	//round 11
    EOR RK1_0, CNT
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1       
   
																	//R_LAYER


 CLR T0
              // left rotate 0      
               
   LSL X0      // left rotate 1      
   ADC X0, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X1      // left rotate 6      
   LSL X1
   ADC X1, T0
   LSL X1
   ADC X1, T0 

																	//S_SLAYER
   MOV T0, X7
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X7   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X0, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X1, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X7, X1   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X7   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X7, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X7
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X0   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[2] ^= X[1] & X[0];
   AND T3, X1
   EOR X2, T3
																			//round 10  


  EOR RK0_0, CNT
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1

																		//R_LAYER
 CLR T0
              // left rotate 0      
               
   LSL X1      // left rotate 1      
   ADC X1, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X7      // left rotate 6      
   LSL X7
   ADC X7, T0
   LSL X7
   ADC X7, T0
																	//S_LAYER
   MOV T0, X0
   MOV T1, X6
   MOV T2, X5
  // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X0   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X1, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X7, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X0, X7   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X0   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X0, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X0
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X1   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[2] ^= X[1] & X[0];
   AND T3, X7
   EOR X2, T3

															  //round 9          
   EOR RK1_0, CNT
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X0, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1
   
   															  //R_LAYER   
  CLR T0
              // left rotate 0      
               
   LSL X7      // left rotate 1      
   ADC X7, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X0      // left rotate 6      
   LSL X0
   ADC X0, T0
   LSL X0
   ADC X0, T0   
															  //S_LAYER     
   MOV T0, X1
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X1   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X7, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X0, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X1, X0   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X1   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X1, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X1
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X7   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[2] ^= X[1] & X[0];
   AND T3, X0
   EOR X2, T3

																  //round 8   
 EOR RK0_0, CNT
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1
																  //R_LAYER
 CLR T0
              // left rotate 0      
               
   LSL X0      // left rotate 1      
   ADC X0, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X1      // left rotate 6      
   LSL X1
   ADC X1, T0
   LSL X1
   ADC X1, T0
																  //S_LAYER
  MOV T0, X7
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X7   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X0, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X1, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X7, X1   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X7   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X7, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X7
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X0   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[2] ^= X[1] & X[0];
   AND T3, X1
   EOR X2, T3


   															//round 7
   EOR RK1_0, CNT											//RK
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1


     CLR T0													//R_LAYER
              // left rotate 0      
               
   LSL X1      // left rotate 1      
   ADC X1, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X7      // left rotate 6      
   LSL X7
   ADC X7, T0
   LSL X7
   ADC X7, T0   

																	//S_LAYER
   MOV T0, X0
   MOV T1, X6
   MOV T2, X5
             // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X0   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X1, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X7, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X0, X7   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5, X0   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X0, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X0
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X1   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[2] ^= X[1] & X[0];
   AND T3, X7
   EOR X2, T3


																		//round6

  EOR RK0_0, CNT
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1

																	//R_LAYER
  CLR T0
              // left rotate 0      
               
   LSL X7      // left rotate 1      
   ADC X7, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X0      // left rotate 6      
   LSL X0
   ADC X0, T0
   LSL X0
   ADC X0, T0   

																	//_SLAYER
   MOV T0, X1
   MOV T1, X6
   MOV T2, X5
     // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X1   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X7, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X0, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X1, X0   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X1   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X1, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X1
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X7   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[2] ^= X[1] & X[0];
   AND T3, X0
   EOR X2, T3

																	//round 5
    EOR RK1_0, CNT
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1       
   
																	//R_LAYER


 CLR T0
              // left rotate 0      
               
   LSL X0      // left rotate 1      
   ADC X0, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X1      // left rotate 6      
   LSL X1
   ADC X1, T0
   LSL X1
   ADC X1, T0 

																	//S_SLAYER
   MOV T0, X7
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X7   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X0, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X1, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X7, X1   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X7   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X7, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X7
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X0   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[2] ^= X[1] & X[0];
   AND T3, X1
   EOR X2, T3
																			//round 4


  EOR RK0_0, CNT
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1

																		//R_LAYER
 CLR T0
              // left rotate 0      
               
   LSL X1      // left rotate 1      
   ADC X1, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X7      // left rotate 6      
   LSL X7
   ADC X7, T0
   LSL X7
   ADC X7, T0
																	//S_LAYER
   MOV T0, X0
   MOV T1, X6
   MOV T2, X5
  // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X0   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X1, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X7, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X0, X7   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X0   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X0, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X0
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X1   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[2] ^= X[1] & X[0];
   AND T3, X7
   EOR X2, T3

															  //round 3         
   EOR RK1_0, CNT
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X0, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1
   
   															  //R_LAYER   
  CLR T0
              // left rotate 0      
               
   LSL X7      // left rotate 1      
   ADC X7, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X0      // left rotate 6      
   LSL X0
   ADC X0, T0
   LSL X0
   ADC X0, T0   
															  //S_LAYER     
   MOV T0, X1
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X1   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X7, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X0, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X1, X0   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X1   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X1, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X1
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X7   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[2] ^= X[1] & X[0];
   AND T3, X0
   EOR X2, T3

																  //round 2
 EOR RK0_0, CNT
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1
																  //R_LAYER
 CLR T0
              // left rotate 0      
               
   LSL X0      // left rotate 1      
   ADC X0, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X1      // left rotate 6      
   LSL X1
   ADC X1, T0
   LSL X1
   ADC X1, T0
																  //S_LAYER
  MOV T0, X7
   MOV T1, X6
   MOV T2, X5
            // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X7   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X0, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X1, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X7, X1   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X7   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X7, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X7
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X0   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X0, T3

   MOV T3, X0   //X[2] ^= X[1] & X[0];
   AND T3, X1
   EOR X2, T3


   
   															//round 1
   EOR RK1_0, CNT											//RK
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, CNT
   SUBI CNT,1


    CLR T0													//R_LAYER
              // left rotate 0      
               
   LSL X1      // left rotate 1      
   ADC X1, T0

   SWAP X2      // left rotate 4      
   

   SWAP X3      // left rotate 5      
   LSL X3
   ADC X3, T0 
   
   LSL X4      // left rotate 2      
   ADC X4, T0
   ROL X4      
   ADC X4, T0

  SWAP X5      // left rotate 3      
   BST X5, 0
   LSR X5
   BLD X5, 7   

   BST X6, 0   // left rotate 7      
   LSR X6
   BLD X6, 7

  SWAP X7      // left rotate 6      
   LSL X7
   ADC X7, T0
   LSL X7
   ADC X7, T0   

																	//S_LAYER
   MOV T0, X0
   MOV T1, X6
   MOV T2, X5
              // S5_2
   MOV T3, X3   // X[4] ^= (X[3] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T2   // X[3] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4   //T[1] ^= X[4];
   EOR T0, X3   //T[0] ^= X[3];

   MOV T3, T0   //T[2] ^= (T[1] & T[0]);
   AND T3, T1
   EOR T2, T3

   MOV T3, X0   //X[3] ^= (X[4] & X[7]);
   AND T3, X4
   EOR X3, T3
      
            ////  Extended XOR
   EOR X1, T1   //X[0] ^= T[1]; X[1] ^= T[2]; X[2] ^= T[0];
   EOR X7, T2
   EOR X2, T0

   MOV T0, X3   //T[0] = X[3]; X[3] = X[6]; X[6] = T[0];
   MOV X3, X6
   MOV X6, T0

   MOV T0, X5   //T[0] = X[5]; X[5] = X[4]; X[4] = T[0];
   MOV X5, X4
   MOV X4, T0

            ////  Truncated XOR
   EOR X0, X7   //X[7] ^= X[1];    X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

            // Inv_S5_1
   MOV T3, X6   //X[4] ^= (X[5] & X[6]);
   AND T3, X5
   EOR X4, T3

   EOR X5,X0   //X[5] ^= X[7];

   MOV T3, X5   //X[3] ^= (X[4] | X[5]);
   OR T3, X4
   EOR X3, T3

   EOR X6, X3   //X[6] ^= X[3];
   EOR X0, X4   //X[7] ^= X[4];

   MOV T3, X5   //X[4] ^= (X[3] & X[5]);
   AND T3, X3
   EOR X4, T3

   MOV T3, X6   //X[5] ^= (X[7] & X[6]);
   AND T3, X0
   EOR X5, T3

            //// Inv_S3
   NEG X2      //X[2] = ~X[2]; 111  
   SUBI X2, 1

   MOV T3, X1   //X[1] ^= X[2] | X[0];
   OR T3, X2
   EOR X7, T3

   MOV T3, X7   //X[0] ^= X[2] | X[1];
   OR T3, X2
   EOR X1, T3

   MOV T3, X1   //X[2] ^= X[1] & X[0];
   AND T3, X7
   EOR X2, T3


													//round0
  EOR RK0_0, CNT
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, CNT
   SUBI CNT,1

    POP R26
   
   ST Y+, X1
   ST Y+, X7
   ST Y+, X2
   ST Y+, X3
   ST Y+, X4
   ST Y+, X5
   ST Y+, X6
   ST Y+, X0
   
   POP R29
   POP R28
   POP R17
   POP R16
   POP R15
   POP R14
   POP R13
   POP R12
   POP R11
   POP R10
   POP R9
   POP R8
   POP R7
   POP R6
   POP R5
   POP R4
   POP R3
   POP R2
   POP R1
   POP R0
   
   RET


   

