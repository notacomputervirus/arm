.global main

main:
	LDR	X0, =inputPrompt	// load prompt to display to user
	BL	printf			// print prompt to user

	LDR	X0, =pattern		// load format pattern for scanf input
	LDR	X1, =inputFromUser	// load address of variable to store input
	BL	scanf			// scan input from user

	LDR	X1, =inputFromUser	// load address of input variable
	LDR	X1, [X1]		// load actual value stored at that address
	LDR	X0, =enteredChar	// load message showing entered character
	BL	printf			// print entered character message

	LDR	X1, =inputFromUser	// load address of user input
	LDR	X1, [X1]		// load value of user input
	LDR	X2, =answer		// load address of secret answer
	LDR	X2, [X2]		// load value of secret answer
	CMP	X1, X2			// compare user input to secret answer
	BEQ	correct			// branch to correct if input matches answer
	B	incorrect		// branch to incorrect if input does not match

correct:
	LDR	X0, =displayCorrect	// load correct guess message
	BL	printf			// print correct guess message
	B	myExit			// branch to exit

incorrect:
	LDR	X0, =displayIncorrect	// load incorrect guess message
	BL	printf			// print incorrect guess message
	B	myExit			// branch to exit

myExit:
	MOV	X8, #93			// load exit syscall number into X8
	SVC	0			// make exit syscall (supervisor call)

.data
inputPrompt:	.asciz	"Input an uppercase character: "	// prompt displayed to user
.align 4
enteredChar:	.asciz	"Your entered character is: %c\n"	// message showing entered char
.align 4
pattern:	.asciz	"%c"			// scanf format string 
.align 4
inputFromUser:	.space	4			// 4-byte space to store the user's input character
.align 4
answer:		.asciz	"L"			// secret character
.align 4
displayIncorrect:	.asciz	"You guessed wrong\n"	// message printed on incorrect guess
.align 4
displayCorrect:		.asciz	"You guessed right\n"	// message printed on correct guess
.align 4
