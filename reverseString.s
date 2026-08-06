.global main

main:
	// prompt user
	LDR	X0, =inputPrompt	// load address
	BL	printf

	// read string
	LDR	X0, =scanPattern
	LDR	X1, =inputBuffer
	BL	scanf

	// measure length of string
	LDR	X20, =inputBuffer	// base address of buffer
	MOV	X21, #0			// counts length


lengthMeasure:
	ADD	X3, X20, X21		// ADD X20  and X21 and store result in X3
	LDR	W1, [X3]		// load 4 bytes
 	CBZ	W1, lengthEnd		// if character is '\0\, stop 
	ADD	X21, X21, #1		// advance length counter
	B	lengthMeasure


lengthEnd:
    // X21 holds the string length

    // print length of string
	LDR	X0, =stringLength
	MOV	X1, X21
	BL	printf

    // print original string
	LDR	X0, =stringOriginal
	LDR	X1, =inputBuffer
	BL	printf

    // reverse the string
	LDR	X22, =reversedBuffer 	//base address
	MOV	X23, #0			// write index L/R
	SUB	X24, X21, #1		// read index


reverse:

	CMP	X24, #0			// if index < 0, done
	BMI	reverseEnd

	ADD	X3, X20, X24		// x3 is address of input buffer
	LDR	W1, [X3]		// load 4 bytes
	ADD	X3, X22, X23		// address of reversed buffer
	STR	W1, [X3]		// store 4 bytes
	SUB	X24, X24, #1		// move reading index left
	ADD	X23, X23, #1		// move writing index right
	B	reverse

reverseEnd:

	MOV	W1, #0
	ADD	X3, X22, X23		// address of reversed buffer
	STR	W1, [X3]		// write 4 zero bytes to terminate string

	// print reversed string
	LDR	X0, =stringReversed
	LDR	X1, =reversedBuffer
	BL	printf

	// exit
	MOV	X0, #0
	MOV	X8, #93
	SVC 0

.data

inputPrompt:    .asciz  "Enter a string: \n"
.align 4

scanPattern:    .asciz  "%20[^\n]"
.align 4

stringLength:      .asciz  "Length of string: %ld\n"
.align 4

stringOriginal:    .asciz  "Original string:  \"%s\"\n"
.align 4

stringReversed:    .asciz  "Boom! Reversed: \"%s\"\n"
.align 4

// 24 bytes: 20 characters + null spc + 3 bytes padding for W-register
inputBuffer:    .space  24
.align 4

reversedBuffer: .space  24
.align 4

// C LIBRARY
.global printf
.global scanf
