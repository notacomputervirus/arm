// Use these commands to assemble, link, run and debug this program in qemu on Mac or WSL:

//aarch64-linux-gnu-gcc -static -o studentIOInt studentIOInt.s
// qemu-aarch64 studentIOInt

// For Raspberry Pi, try the following
    //    gcc -o studentIOInt studentIOInt.s
    //    ./studentIOInt 
    
.global main // Must use main because of C library uses. 
    
main:
 
 // Ask the user to enter a number.
        ldr X0, =intInputPrompt    
        bl  printf              
   
 // Set up X0 with the address of input pattern.   
 // scanf puts the input value at the address stored in X1.  
 // After the call to scanf the input is at the address pointed to by X1 which 
 // in this case will be intInput. 
        ldr X0, =intInputPattern // Setup to read in one number.
        ldr X1, =intInput        // load X1 with the addr. of where the input will be stored. 
        bl  scanf                // scan the keyboard.

        ldr X1, =intInput        // Have to reload X1 because it gets wiped out.
        ldr X1, [X1]             // Read the contents of intInput and store in X1
 
  // Print the input number back to the display, the number parameter is in X1
        ldr X0, =intOutputPrompt
        bl  printf
 
       // End of code. 
   myExit: 
         mov X8, #93 // SVC call to exit
         svc 0         // Make the system call. 
      
 
.data
    
    // Declare the strings and data needed  
         intInputPrompt: .asciz "Please enter a number: \n"
         .align 4
         intOutputPrompt: .asciz "The number you entered is: %d \n"
         .align 4

    // Format pattern for scanf call.
        intInputPattern: .asciz "%d"  // integer format for read. 
        .align 4
        intInput: .word 0   // Location used to store the user input.
        .align 4

    // Let the assembler know these are the C library functions. 
        .global printf
    
    //  To use printf:
    //     X0 - Contains the starting address of the string to be printed. The string
    //          must conform to the C coding standards.
    //     X1 - If the string contains an output parameter i.e., %d, %c, etc. register
    //          X1 must contain the value to be printed. 
    // When the call returns registers: X0-X18 are disruptable.
    
            .global scanf
    
    //  To use scanf:
    //      X0 - Contains the address of the input format string used to read the user
    //           input value. In this example it is intInputPattern.  
    //      X1 - Must contain the address where the input value is going to be stored.
    //           In this example memory location intInput declared in the .data section
    //           is being used.  
    // When the call returns registers: X0-X18 are disruptable.
    // Important Notes about scanf:
    //   If the user entered an input that does NOT conform to the input pattern, 
    //   then register X0 will contain a 0. If it is a valid format
    //   then X0 will contain a 1. The input buffer will NOT be cleared of the invalid
    //   input so that needs to be cleared out before attempting anything else.
    //
    // Additional notes about scanf and the input patterns:
    //    1. If the pattern is %s or %c it is not possible for the user input to generate
    //       and error code. Anything that can be typed by the user on the keyboard
    //       will be accepted by these two input patterns. 
    //    2. If the pattern is %d and the user input 12.123 scanf will accept the 12 as
    //       valid input and leave the .123 in the input buffer. 
    //    3. If the pattern is "%c" any white space characters are left in the input
    //       buffer. In most cases user entered carrage return remains in the input buffer
    //       and if you do another scanf with "%c" the carrage return will be returned. 
    //       To ignore these "white" characters use " %c" as the input pattern. This will
    //       ignore any of these non-printing characters the user may have entered.
    //

 
    
