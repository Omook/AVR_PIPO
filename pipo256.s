

.global pipo256_encrypt
.type pipo256_encrypt, @function


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

   #define X0 R16
   #define X1 R17
   #define X2 R18
   #define X3 R19
   #define X4 R20
   #define X5 R21
   #define X6 R22
   #define X7 R23
  
   #define RK2_0 R24
   #define RK2_1 R25
  
   #define T0 R26
   #define T1 R27
   #define T2 R28
   #define T3 R29
  

pipo256_encrypt:
   

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

   PUSH R24
   PUSH R25
   
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
   LD RK2_0, Z+
    LD RK2_1, Z+

   LD X0, X+
   LD X1, X+
   LD X2, X+
   LD X3, X+
   LD X4, X+
   LD X5, X+
   LD X6, X+
   LD X7, X+   
   

   


                                                       //round 0
                                             //RK 0
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   
   MOV T0, X7      // X[5] ^= (X[7] & X[6]);                  //S_LAYER 0
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
   
         
   CLR T0                                             //R_LAYER0
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0     

   LDI T0, 1                                 //round 1

   EOR RK1_0, T0                                 //RK 1
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, T0   

   MOV T0, X1      // X[5] ^= (X[7] & X[6]);               //S_LAYER 1
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X1, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X1      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];      
   
   CLR T0                                                   //R_LAYER 1
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  
   
   LDI T0, 2                                              //round2
   EOR RK2_0, T0
   EOR X1, RK2_0  
   EOR RK2_0, T0
   EOR X7, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X0, T1

    MOV T0, X0      // X[5] ^= (X[7] & X[6]);                        //S_LAYER 2
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X0, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X0      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X7      // X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X0, X7      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

               // S5_2
   MOV T0, X0      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X7, T2      // T[0] = X[1] ^ T[2];
   

   EOR X1, T1      // X[1] = X[0]^T[1];         
   
      
   CLR T0                                             //R_LAYER2
              // left rotate 0

   BST X1, 0   // left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X7      // left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

   LDI T0, 3                                                //round 3   
   
    LDD T1, Z+6
   EOR T1, T0
   EOR X0, T1
   LDD T1, Z+7
   EOR X1, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X6, T1
   LDD T1, Z+10
   EOR X5, T1
   LDD T1, Z+11
   EOR X4, T1
   LDD T1, Z+12
   EOR X3, T1
   LDD T1, Z+13
   EOR X7, T1 
      
   
    MOV T0, X7      // X[5] ^= (X[7] & X[6]);                        //S_LAYER3
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X7, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X7      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
            
   CLR T0                                             //R_LAYER 3
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  
   
   LDI T0, 4                                                 //round 4

   EOR RK0_0, T0                                          //RK 4
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, T0
      
   MOV T0, X1      // X[5] ^= (X[7] & X[6]);                     //S_LAYER4
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X1, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X1      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];
         
   CLR T0                                          //R_LAYER4
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0     

   LDI T0, 5                                 //round 5   

   EOR RK1_0, T0                                             //RK5
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X0, RK1_7
  EOR RK1_0, T0


   MOV T0, X0      // X[5] ^= (X[7] & X[6]);                        //S_LAYER5
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X0, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X0      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X7      // X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X0, X7      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X1

               // S5_2
   MOV T0, X0      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X7, T2      // T[0] = X[1] ^ T[2];
   

   EOR X1, T1      // X[1] = X[0]^T[1];                              //R_LAYER5

     CLR T0
              // left rotate 0

   BST X1, 0   // left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X7      // left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

   ///////////////////////////////////////////round6/////////////////////////////////////////////////////////
    
   
   LDI T0, 6                                              //round 6
    EOR RK2_0, T0
   EOR X0, RK2_0  
   EOR RK2_0, T0
   EOR X1, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X7, T1
      
   MOV T0, X7      // X[5] ^= (X[7] & X[6]);                  //S_LAYER 6
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
   
         
   CLR T0                                             //R_LAYER6
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0     

   LDI T0, 7                                        //round 7

    LDD T1, Z+6
   EOR T1, T0
   EOR X7, T1
   LDD T1, Z+7
   EOR X0, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X6, T1
   LDD T1, Z+10
   EOR X5, T1
   LDD T1, Z+11
   EOR X4, T1
   LDD T1, Z+12
   EOR X3, T1
   LDD T1, Z+13
   EOR X1, T1  

   MOV T0, X1      // X[5] ^= (X[7] & X[6]);               //S_LAYER 7
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X1, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X1      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];      
   
   CLR T0                                                   //R_LAYER 7
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  
   
   LDI T0, 8                                               //round8
   EOR RK0_0, T0                                       //RK 8
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, T0   

    MOV T0, X0      // X[5] ^= (X[7] & X[6]);                        //S_LAYER 8
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X0, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X0      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X7      // X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X0, X7      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

               // S5_2
   MOV T0, X0      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X7, T2      // T[0] = X[1] ^ T[2];
   

   EOR X1, T1      // X[1] = X[0]^T[1];         
   
      
   CLR T0                                             //R_LAYER8
              // left rotate 0

   BST X1, 0   // left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X7      // left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

   LDI T0, 9                                                  //round 9   
   
   EOR RK1_0, T0                                          //RK9
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, T0
      
   
    MOV T0, X7      // X[5] ^= (X[7] & X[6]);                        //S_LAYER9
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X7, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X7      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
            
   CLR T0                                             //R_LAYER 9
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  
   
   LDI T0, 10                                                //round 10

    EOR RK2_0, T0
   EOR X7, RK2_0  
   EOR RK2_0, T0
   EOR X0, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X1, T1
      
   MOV T0, X1      // X[5] ^= (X[7] & X[6]);                     //S_LAYER10
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X1, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X1      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];
         
   CLR T0                                          //R_LAYER10
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0     

   LDI T0, 11                                  //round 11   

   LDD T1, Z+6
   EOR T1, T0
   EOR X1, T1
   LDD T1, Z+7
   EOR X7, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X6, T1
   LDD T1, Z+10
   EOR X5, T1
   LDD T1, Z+11
   EOR X4, T1
   LDD T1, Z+12
   EOR X3, T1
   LDD T1, Z+13
   EOR X0, T1  


   MOV T0, X0      // X[5] ^= (X[7] & X[6]);                        //S_LAYER11
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X0, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X0      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X7      // X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X0, X7      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X1

               // S5_2
   MOV T0, X0      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X7, T2      // T[0] = X[1] ^ T[2];
   

   EOR X1, T1      // X[1] = X[0]^T[1];                              //R_LAYER11

     CLR T0
              // left rotate 0

   BST X1, 0   // left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X7      // left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  
                                                      //round 12
   LDI T0, 12                                               //RK 12
   EOR RK0_0, T0
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, T0
      
   MOV T0, X7      // X[5] ^= (X[7] & X[6]);                  //S_LAYER 12
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X7, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X7      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
   
         
   CLR T0                                             //R_LAYER12
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0     

   LDI T0, 13                                        //round 13

   EOR RK1_0, T0                                 //RK 13
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, T0   

   MOV T0, X1      // X[5] ^= (X[7] & X[6]);               //S_LAYER 13
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X1, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X1      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];      
   
   CLR T0                                                   //R_LAYER 13
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0  
   
   LDI T0, 14                                             //round14
   EOR RK2_0, T0
   EOR X1, RK2_0  
   EOR RK2_0, T0
   EOR X7, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X0, T1

    MOV T0, X0      // X[5] ^= (X[7] & X[6]);                        //S_LAYER 14
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X0, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X0      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X7      // X[2] ^= X[1] & X[0];
   AND T0, X1
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X7
   EOR X1, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X1
   EOR X7, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X0, X7      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X1

               // S5_2
   MOV T0, X0      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X7, T2      // T[0] = X[1] ^ T[2];
   

   EOR X1, T1      // X[1] = X[0]^T[1];         
   
      
   CLR T0                                             //R_LAYER14
              // left rotate 0

   BST X1, 0   // left rotate 7
   LSR X1
   BLD X1, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X7      // left rotate 2
   ADC X7, T0
   ROL X7      
   ADC X7, T0  

   LDI T0, 15                                                //round 15   
   
   LDD T1, Z+6
   EOR T1, T0
   EOR X0, T1
   LDD T1, Z+7
   EOR X1, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X6, T1
   LDD T1, Z+10
   EOR X5, T1
   LDD T1, Z+11
   EOR X4, T1
   LDD T1, Z+12
   EOR X3, T1
   LDD T1, Z+13
   EOR X7, T1  
      
   
    MOV T0, X7      // X[5] ^= (X[7] & X[6]);                        //S_LAYER15
   AND T0, X3 
   EOR X4, T0

   MOV T0, X6      // X[4] ^= (X[3] & X[5]);
   AND T0, X4
   EOR X5, T0

   EOR X7, X5      // X[7] ^= X[4];
   EOR X3, X6      // X[6] ^= X[3];

   MOV T0, X5      // X[3] ^= (X[4] | X[5]);
   OR T0, X4
   EOR X6, T0

   EOR X4, X7      // X[5] ^= X[7];

   MOV T0, X4      // X[4] ^= (X[5] & X[6]);
   AND T0, X3
   EOR X5, T0

               //S3
   MOV T0, X1      // X[2] ^= X[1] & X[0];
   AND T0, X0
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X1
   EOR X0, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X0
   EOR X1, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X7, X1      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X6, X2
   EOR X5, X0

               // S5_2
   MOV T0, X7      // T[0] = X[7];
   MOV T1, X6      // T[1] = X[3];
   MOV T2, X5      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X4
   EOR X3, T3
   
   EOR T0, X3      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X3, T3

   EOR T1, X4      // T[1] ^= X[5];

   MOV T3, X3      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X4, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X1, T2      // T[0] = X[1] ^ T[2];
   

   EOR X0, T1      // X[1] = X[0]^T[1];
            
   CLR T0                                             //R_LAYER 15
              // left rotate 0

   BST X0, 0   // left rotate 7
   LSR X0
   BLD X0, 7

   SWAP X2      // left rotate 4
   

   SWAP X3      // left rotate 3
   BST X3, 0
   LSR X3
   BLD X3, 7  
   
   SWAP X4      // left rotate 6
   LSL X4
   ADC X4, T0
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 5
   LSL X5
   ADC X5, T0   

   LSL X6      // left rotate 1      
   ADC X6, T0

   LSL X1      // left rotate 2
   ADC X1, T0
   ROL X1      
   ADC X1, T0  
   
   LDI T0, 16                                                //round 16

   EOR RK0_0, T0                                       //RK 16
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   
      
   MOV T0, X1      // X[5] ^= (X[7] & X[6]);                     //S_LAYER16
   AND T0, X6 
   EOR X5, T0

   MOV T0, X3      // X[4] ^= (X[3] & X[5]);
   AND T0, X5
   EOR X4, T0

   EOR X1, X4      // X[7] ^= X[4];
   EOR X6, X3      // X[6] ^= X[3];

   MOV T0, X4      // X[3] ^= (X[4] | X[5]);
   OR T0, X5
   EOR X3, T0

   EOR X5, X1      // X[5] ^= X[7];

   MOV T0, X5      // X[4] ^= (X[5] & X[6]);
   AND T0, X6
   EOR X4, T0

               //S3
   MOV T0, X0      // X[2] ^= X[1] & X[0];
   AND T0, X7
   EOR X2, T0

   MOV T0, X2      // X[0] ^= X[2] | X[1];
   OR T0, X0
   EOR X7, T0
   
   MOV T0, X2      // X[1] ^= X[2] | X[0];
   OR T0, X7
   EOR X0, T0

   NEG X2         // X[2] = ~X[2];
   SUBI X2, 1 

               // Extend XOR
   EOR X1, X0      // X[7] ^= X[1];   X[3] ^= X[2];   X[4] ^= X[0];
   EOR X3, X2
   EOR X4, X7

               // S5_2
   MOV T0, X1      // T[0] = X[7];
   MOV T1, X3      // T[1] = X[3];
   MOV T2, X4      // T[2] = X[4];

   MOV T3, T0      // X[6] ^= (T[0] & X[5]);
   AND T3, X5
   EOR X6, T3
   
   EOR T0, X6      // T[0] ^= X[6];

   MOV T3, T2      // X[6] ^= (T[2] | T[1]);
   OR T3, T1
   EOR X6, T3

   EOR T1, X5      // T[1] ^= X[5];

   MOV T3, X6      // X[5] ^= (X[6] | T[2]);
   OR T3, T2
   EOR X5, T3

   MOV T3, T1      // T[2] ^= (T[1] & T[0]);
   AND T3, T0
   EOR T2, T3

               // Truncate XOR and bit change
   EOR X2, T0      // X[2] ^= T[0];
   
   EOR X0, T2      // T[0] = X[1] ^ T[2];
   

   EOR X7, T1      // X[1] = X[0]^T[1];
         
   CLR T0                                          //R_LAYER16
              // left rotate 0

   BST X7, 0   // left rotate 7
   LSR X7
   BLD X7, 7

   SWAP X2      // left rotate 4
   

   LSL X3      // left rotate 1      
   ADC X3, T0 
   
   SWAP X4      // left rotate 5
   LSL X4
   ADC X4, T0  
   

   SWAP X5      // left rotate 6
   LSL X5
   ADC X5, T0
   LSL X5
   ADC X5, T0    

   SWAP X6      // left rotate 3
   BST X6, 0
   LSR X6
   BLD X6, 7 

   LSL X0      // left rotate 2
   ADC X0, T0
   ROL X0      
   ADC X0, T0     

   LDI T0, 17                                 //round 17

   EOR RK1_0, T0                                                //RK17
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X6, RK1_3
   EOR X5, RK1_4
   EOR X4, RK1_5
   EOR X3, RK1_6
   EOR X0, RK1_7
  

   //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡeㅡnㅡdㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ//

   POP R27
   POP R26
   
   
   ST X+, X1
   ST X+, X7
   ST X+, X2
   ST X+, X6
   ST X+, X5
   ST X+, X4
   ST X+, X3
   ST X+, X0

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
.global pipo256_decrypt
.type pipo256_decrypt, @function

 
  
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

   #define X0 R16
   #define X1 R17
   #define X2 R18
   #define X3 R19
   #define X4 R20
   #define X5 R21
   #define X6 R22
   #define X7 R23
  
   #define RK2_0 R24
   #define RK2_1 R25
  
   #define T0 R26
   #define T1 R27
   #define T2 R28
   #define T3 R29

pipo256_decrypt:
   
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

   PUSH R24
   PUSH R25
   
   MOVW R26, R22 //ct
   MOVW R30, R20 //mk

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
   LD RK2_0, Z+
    LD RK2_1, Z+

   LD X0, X+
   LD X1, X+
   LD X2, X+
   LD X3, X+
   LD X4, X+
   LD X5, X+
   LD X6, X+
   LD X7, X+
  
    

   

   LDI T0, 17                                 //round 17

   EOR RK1_0, T0                                                //RK17
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, T0

                                             //round16
     CLR T0                                       //R_LAYER16
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

                                                   //S_LAYER16
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


   LDI T0, 16                                                   //rk16

  EOR RK0_0, T0   
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, T0   

                                                            
                                                   //round15
                                                   //R_LAYER15
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

                                                   //_SLAYER15
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

                                                   //rk 15
    LDI T0, 15      
   
   LDD T1, Z+6
   EOR T1, T0
   EOR X7, T1
   LDD T1, Z+7
   EOR X0, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X3, T1
   LDD T1, Z+10
   EOR X4, T1
   LDD T1, Z+11
   EOR X5, T1
   LDD T1, Z+12
   EOR X6, T1
   LDD T1, Z+13
   EOR X1, T1    

                                                   //round14
                                                   //R_LAYER14


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

                                                   //S_SLAYER14
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
                                                         //rk 14  


  LDI T0, 14      

   EOR RK2_0, T0
   EOR X0, RK2_0  
   EOR RK2_0, T0
   EOR X1, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X7, T1

                                                //round13
     CLR T0                                       //R_LAYER13
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

                                                   //S_LAYER13
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


                                                      //rk13

  LDI T0, 13		
   EOR RK1_0, T0  
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X0, RK1_7
   EOR RK1_0, T0 
                                                            
                                                   //round12
                                                   //R_LAYER12
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

                                                   //_SLAYER12
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

                                                   //rk 12
   LDI T0, 12        
   EOR RK0_0, T0
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   EOR RK0_0, T0     
                                                   //round11
                                                   //R_LAYER11


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

                                                   //S_SLAYER11
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
                                                         //rk 11


  
   LDI T0, 11      
   
   LDD T1, Z+6
   EOR T1, T0
   EOR X0, T1
   LDD T1, Z+7
   EOR X1, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X3, T1
   LDD T1, Z+10
   EOR X4, T1
   LDD T1, Z+11
   EOR X5, T1
   LDD T1, Z+12
   EOR X6, T1
   LDD T1, Z+13
   EOR X7, T1

                                                //round10
     CLR T0                                       //R_LAYER10
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

                                                   //S_LAYER10
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


                                                      //rk10

   LDI T0, 10      

   EOR RK2_0, T0
   EOR X1, RK2_0  
   EOR RK2_0, T0
   EOR X7, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X0, T1
                                                            
                                                   //round9
                                                   //R_LAYER9
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

                                                   //_SLAYER9
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

                                                   //rk 9
   LDI T0, 9		
   EOR RK1_0, T0
   EOR X7, RK1_0
   EOR X0, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X1, RK1_7
   EOR RK1_0, T0   
                                                   //round8
                                                   //R_LAYER8


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

                                                   //S_SLAYER8
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
                                                         //rk 8


   LDI T0, 8      
   EOR RK0_0, T0
   EOR X0, RK0_0
   EOR X1, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X7, RK0_7
   EOR RK0_0, T0


                                             //round7
     CLR T0                                       //R_LAYER7
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

                                                   //S_LAYER7
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


                                                      //rk7

   LDI T0, 7     
   
   LDD T1, Z+6
   EOR T1, T0
   EOR X1, T1
   LDD T1, Z+7
   EOR X7, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X3, T1
   LDD T1, Z+10
   EOR X4, T1
   LDD T1, Z+11
   EOR X5, T1
   LDD T1, Z+12
   EOR X6, T1
   LDD T1, Z+13
   EOR X0, T1
                                                            
                                                   //round6
                                                   //R_LAYER6
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

                                                   //_SLAYER6
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

                                                   //rk 6
   LDI T0, 6      

   EOR RK2_0, T0
   EOR X7, RK2_0  
   EOR RK2_0, T0
   EOR X0, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X1, T1      
                                                   //round5
                                                   //R_LAYER5


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

                                                   //S_SLAYER5
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
                                                         //rk 5


  LDI T0, 5		
   EOR RK1_0, T0  
   EOR X0, RK1_0
   EOR X1, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X7, RK1_7
   EOR RK1_0, T0

   
                                             //round4
     CLR T0                                       //R_LAYER4
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

                                                   //S_LAYER4
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


                                                      //rk4

  LDI T0, 4      
   EOR RK0_0, T0
   EOR X1, RK0_0
   EOR X7, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X0, RK0_7
   EOR RK0_0, T0
                                                            
                                                   //round3
                                                   //R_LAYER3
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

                                                   //_SLAYER3
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

                                                   //rk 3
    LDI T0, 3   
   
   LDD T1, Z+6
   EOR T1, T0
   EOR X7, T1
   LDD T1, Z+7
   EOR X0, T1
   LDD T1, Z+8
   EOR X2, T1
   LDD T1, Z+9
   EOR X3, T1
   LDD T1, Z+10
   EOR X4, T1
   LDD T1, Z+11
   EOR X5, T1
   LDD T1, Z+12
   EOR X6, T1
   LDD T1, Z+13
   EOR X1, T1      
                                                   //round2
                                                   //R_LAYER2


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

                                                   //S_SLAYER2
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
                                                         //rk 2


  LDI T0, 2 

   EOR RK2_0, T0
   EOR X0, RK2_0  
   EOR RK2_0, T0
   EOR X1, RK2_1
   LD T1, Z
   EOR X2, T1
   LDD T1, Z+1
   EOR X3, T1
   LDD T1, Z+2
   EOR X4, T1
   LDD T1, Z+3
   EOR X5, T1
   LDD T1, Z+4
   EOR X6, T1
   LDD T1, Z+5
   EOR X7, T1

   
                                             //round1
     CLR T0                                       //R_LAYER1
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

                                                   //S_LAYER1
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


                                                      //rk1

  LDI T0, 1		
   EOR RK1_0, T0 
   EOR X1, RK1_0
   EOR X7, RK1_1
   EOR X2, RK1_2
   EOR X3, RK1_3
   EOR X4, RK1_4
   EOR X5, RK1_5
   EOR X6, RK1_6
   EOR X0, RK1_7
   
                                                            
                                                   //round0
                                                   //R_LAYER0
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

                                                   //_SLAYER0
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

                                                   //rk 0
    
   EOR X7, RK0_0
   EOR X0, RK0_1
   EOR X2, RK0_2
   EOR X3, RK0_3
   EOR X4, RK0_4
   EOR X5, RK0_5
   EOR X6, RK0_6
   EOR X1, RK0_7
   
      

   //ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡendㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

   POP R27
   POP R26
   
   ST X+, X7
   ST X+, X0
   ST X+, X2
   ST X+, X3
   ST X+, X4
   ST X+, X5
   ST X+, X6
   ST X+, X1

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


   