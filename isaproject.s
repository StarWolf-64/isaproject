// The code you must implement is provided in ISAproject.pdf

// Define stack start address
.stack 0x5000

// Define address of printf
.text 0x7000
.label printf

.data 0x100
.label sia
50
43
100
-5
-10
50
0 //check if value is equal to zero
.label sib
500
43
100
-5
-10
50
0
.label fmt1
.string //sia[%d]: %d
.label fmt2
.string //Something bad
.label fmt3 // 
.string //s1: %d, s2: %d 
.label a1
0
.label a2
0
.label fmt4
.string //cmp_arrays(sia, sib): %d
.label fmt5
.string //cmp_arrays(sia, sia): %d
.label fmt6
.string //cmp_arrays(ia, sib): %d
.text 0x300
// r0 has ia - address of null terminated array
// sum_array is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack
.label sum_array
sub r13,r13,#12 //allocate memory for stack
str r4,[r13,#0] // stores r4
str r5,[r13,#4] // stores r5
str r14,[r13,#8] // stores link register
mov r1,0 //int s=0;
.label sum_array_condit //start of the loop
ldr r4,[r0],#4 //get value of array
cmp r4,#0 //while(*ia !=0) 
beq break1 //leave loop if equal
add r1,r1,r4 //increment s+=*ia
bal sum_array_condit //return to the start of the loop
.label break1 //if you leave loop go here
mov r0,r1 //value meant to be returned
ldr r4, [r13,#0] //reload r4
ldr r5, [r13,#4] //reload r5
ldr r14,[r13,#8] //reload link reg from stack
add r13,r13,#12 //return memory
mov r15,r14 //return 
.text 0x400
// r0 has ia1 - address of null terminated array
// r1 has ia1 - address of null terminated array
// cmp_arrays must allocate a stack
// Save lr on stack and allocate space for local vars
.label cmp_arrays
sub r13,r13,#12 //allocate memory for stack
str r4,[r13,#0] // stores r4
str r5,[r13,#4] // stores r5
str r14,[r13,#8] // stores link register
mov r4,r0 //passes the addr of arry 1 sia
mov r5,r1
//mva r4,0x100 //passes the addr of arry 1 sia
blr sum_array    //Call sum_array 1st time
str r0,a1  // put value into label
mov r0,r5 
//mva r4,0x11C //passes addr arry 2 sib
blr sum_array //Call sum_array 2nd time
str r0,a2 //store return val into label
mov r0,r1 //mov r1(2nd) to r0(1st arg)
mov r1,fmt3 //puts the format str into r1
ldr r2,a1
ldr r3,a2
ker #0x11 // Kernel call to printf
cmp r2,r3 //compare the arrays get resp values
beq equal //branch if ==
bgt s1G // branch if s1>s2
blt s2G // branch if s1<s2
.label equal
mov r0,0
bal endS 
.label s1G
mov r0,1
bal endS 
.label s2G
mov r0,-1
.label endS                
ldr r4, [r13,#0] //reload r4 Deallocate stack
ldr r5, [r13,#4] //reload r5
ldr r14,[r13,#8] //reload link reg from stack
add r13,r13,#12 //return memory
mov r15, r14 // return
.text 0x500
// r0 has ia - address of null terminated array
// numelems is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack
.label numelems
sub r13, r13, #12	//allocate memory for stack
str r4, [r13, #0]	//store r4
str r5, [r13, #4]	//store r5
str r14, [r13, #8]	//store link register
mov r1, 0		//set c = 0
.label elem_loop  	//this is where it goes when it starts the loop
ldr r4, [r0], #4        //get value of array, post increment 
cmp r4, 0		//checks if the value is 0		
beq break		//if conditions met, leave loop
add r1, r1, 1		//increment c
bal elem_loop 		//returns to start of loop
.label break		//this is where it goes if it leaves the loop
mov r0, r1		//temporary hardcoded 7 return value
ldr r4, [r13, #0]	//reloads r4 back from stack
ldr r5, [r13, #4]	//reloads r5 back from stack
ldr r14, [r13, #8]	//reloads link register back from stack
add r13, r13, #12	//returns memory
mov r15, r14       // return

.text 0x600
// r0 has ia - address of null terminated array
// sort must allocate a stack
// Save lr on stack and allocate space for local vars
.label sort
sub r13, r13, #24 // Allocate stack
str r0, [r13, #0] //array pointer
str r4, [r13, #4]
str r5, [r13, #8]
str r6, [r13, #12]
str r7, [r13, #16]
str r14, [r13, #20]
blr numelems    // count elements in ia[]
mov r4, r0
mov r1, 0	// i counter = 0
.label outerloop  // create nested loops to sort
ldr r0, [r13, #0]
mov r2, 0	// j counter = 0
sub r3, r4, 1
sub r3, r3, r1
cmp r1, r4
bge endouter
.label innerloop
cmp r2, r3
bge endinner
ldr r5, [r0]
ldr r6, [r0, #4]
.label sortif
cmp r5, r6
ble endsortif
str r5, [r0, #4]
str r6, [r0]
.label endsortif
add r0, r0, #4
add r2, r2, 1
bal innerloop
.label endinner
add r1, r1, 1
bal outerloop
.label endouter
ldr r4, [r13, #4]
ldr r5, [r13, #8]
ldr r6, [r13, #12]
ldr r7, [r13, #16]
ldr r14, [r13, #20]
add r13, r13, #24  // Deallocate stack
mov r15, r14       // return - sort is a void function

.text 0x700
// r0 has ia - address of null terminated array
// smallest must allocate a stack
// Save lr on stack and allocate space for local vars
.label smallest
sub r13, r13, #20   // space for smallest, i, r4, r5, and lr
str r4, [r13, #8]   // save r4 on stack
str r5, [r13, #12]  // save r5 on stack
str r14, [r13, #16] // save lr on stack
ldr r2, [r0]
str r2, [r13, #0]   // int smallest = a[0]
mov r4, r0          // put address of a in r4
mov r3, #0
str r3, [r13, #4]   // for (int i = 0;
blr numelems
mov r1,r0 
.label loop1
ldr r5, [r4],#4     // put ia[i] in r5, post increment r4
cmp r5, r2          // if ia[i]>smallest
bgt skip1
mov r2, r5          // update smallest
str r2, [r13, #0]   // smallest = a[i]
.label skip1
add r3, r3, #1
str r3, [r13, #4]   // for ( ; ; i++)
cmp r3, r1          // for( ; i < size; )
blt loop1            // continue looping until i >= size
mov r0, r2          // place smallest in r0
ldr r4, [r13, #8]   // restore r4
ldr r5, [r13, #12]  // restore r5
ldr r14, [r13, #16] // restore lr
add r13, r13, #20   // restore r13
mov r15, r14        // return to caller

.text 0x800
// r0 has an integer
// factorial must allocate a stack
// Save lr on stack and allocate space for local vars
.label factorial
sub r13, r13, #16 // Allocate stack
str r0, [r13, #0] //store incoming value
str r4, [r13, #4]
str r5, [r13, #8]
str r14, [r13, #12]
cmp r0, 1
bne noteq
bal postif
.label noteq
sub r0, r0, 1
blr factorial    // factorial calls itself
ldr r1, [r13, #0]
mul r0, r1, r0
.label postif
ldr r4, [r13, #4]
ldr r5, [r13, #8]
ldr r14, [r13, #12]
add r13, r13, #16 // Deallocate stack
//mov r0, 120        // hardcode 5! as return value
mov r15, r14       // return

.text 0x900
// This sample main implements the following
// int main() {
//     int n = 0, l = 0, c = 0;
//     printf("Something bad");
//     for (int i = 0; i < 3; i++)
//         printf("ia[%d]: %d", i, sia[i]);
//     n = numelems(sia);
//     sm1 = smallest(sia);
//     cav = cmp_arrays(sia, sib);
// }
.label main

sbi sp, sp, 40     // allocate space for stack
                   // [sp,0] is int cav
                   // [sp,4] is int n
                   // [sp,8] is int sm1
str lr, [sp, 16]   // [sp,12] is lr (save lr)
mov r0, 0
str r0, [sp, 0]    // cav = 0;
str r0, [sp, 4]    // n = 0;
str r0, [sp, 8]    // sm1 = 0;
str r0, [sp,12]    //sm2 =0;
mov r0,#2
str r0, [sp,20]
mov r0,#3
str r0, [sp,24]
mov r0,#5
str r0, [sp,28]
mov r0,#1
str r0, [sp,32]
mov r0,#0
str r0, [sp,36]
mva r0,sia //parameters for compare_array 
mva r1,sib //other parm
blr cmp_arrays //branch to method
str r0,[sp,0] // storing the output depending on condit
mov r1,r0 //put in place for printf
mva r0,fmt4 //put value to be printed
blr printf //first print
mva r0,sia //parameters for compare_array
mva r1,sia //other parm
blr cmp_arrays //branch to method
str r0,[sp,0] // storing the output depending on condit
mov r1,r0 //put in place for printf
mva r0,fmt5 //put value to be printed
blr printf //second print
mov r0,4 //three line repres sib[0]=4
mva r1,sib
str r0,[r1,#0]
mva r0,sia //parameters for compare_array
mva r1,sib //other parm
blr cmp_arrays //branch to method
str r0,[sp,0] // storing the output depending on condit
mov r1,r0 //put in place for printf
mva r0,fmt4 //put value to be printed
blr printf //third print
ldr r0,[sp,20]
mva r1,sia //other parm
blr cmp_arrays //branch to method
str r0,[sp,0] // storing the output depending on condit
mov r1,r0 //put in place for printf
mva r0,fmt6 //put value to be printed
blr printf //fourth print


// printf("Something bad");
// Kernel call to printf expects parameters
// r1 - address of format string - "Something bad"
// mva r1, bad
// ker #0x11
// The os has code for printf at address 0x7000
// The code there generates the ker instruction
// You call printf with
// r0 - has address of format string - "Something bad"
mva r0, fmt2
blr printf
//
// for (int i = 0; i < 4; i++)
//     printf("ia[%d]: %d", i, sia[i]);
mov r4, 0          // i to r4
mva r5, sia   // address is sia to r5
//mva r0, sia 	//test value
//blr sort	//test value
.label loop4times  // print 3 elements if sia
cmp r4, 4
bge end_loop4times
// Kernel call to printf expects parameters
// r1 - address of format string - "ia[%d]: %d"
// r2 - value for first %d
// r3 - value for second %d
mva r1, fmt1       // fmt1 to r1
mov r2, r4         // i to r2
ldr r3, [r5], 4    // sia[i] to r3
ker #0x11          // Kernel call to printf
adi r4, r4, 1      // i++
bal loop4times
.label end_loop4times
// int n = numelems(sia);
mva r0, sia        // put address of sia in r0
blr numelems       // n = numelems(sia)
str r0, [sp, 4]
// int sm1 = smallest(sia);
mva r0, sia        // put address of sia in r0
blr smallest       // sm1 = smallest(sia)
str r0, [sp, 8]    // store return value in sm1
// cav = cmp_arrays_sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays
str r0, [sp, 0]
// Do not deallocate stack.
// This leaves r13 with an address that can be used to dump memory
// > d 0x4ff0 
// Shows the three hardcoded values stored in cav, n, and sm1.
// 0x4ff0 (0d20464) 0xffffffff 0x0000000a 0x00000002
.label end
bal end            // branch to self
