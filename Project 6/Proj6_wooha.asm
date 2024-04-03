TITLE Project 6 - String Primitives and Macros     (Proj6_wooha.asm)

; Author: Hannah Woo
; Last Modified: March 20, 2024
; OSU email address: wooha@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: March 20, 2024
; Description: This MASM program with macros and procedures to handle strings and signed integers. The macros should
;			   should read and display strings, while the procedures should convert strings to numbers and back. The
;			   main program should use these to get valid integers from the user, store them, and display their sum
;			   and truncated average.

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString Macro
; 
; Displays a prompt and gets the user’s keyboard input into a memory location. 
;
; Postconditions: EAX, ECX, and EDX changed.
;
; Recieves:
;	prompt = prompt message to retrieve a number from the user
;	buffer = string memory location to store the input string from the user
;	count = the number of characters the user inputted after ReadString
;
; Returns: The buffer will not contain the string from the user and the count will represent how large the number is.
; ---------------------------------------------------------------------------------
mGetString	MACRO buffer, max, count
	; Push EAX, ECX and EDX onto the memory stack.
	push	EAX
	push	ECX
	push	EDX

	; Retrieve the string from the user
	mov		EDX, buffer 
	mov		ECX, max
	call	ReadString 
	mov		count, EAX

	; Pop EAX, ECX, AND EDX back into their memory.
	pop		EDX
	pop		ECX
	pop		EAX

ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString Macro
;
; Prints the string which is stored in a specified memory location
;
; Postconditions: EDX changed.
;
; Recieves: 
;	buffer = string memory location that the program will write the string from.
;
; Returns: Displays the buffer string for the user.
; ---------------------------------------------------------------------------------
mDisplayString	MACRO buffer
	; Push EAX, ECX and EDX onto the memory stack.
	push	EDX

	; Display the buffer for the user
	mov		EDX, buffer
	call	WriteString

	; POP EAX, ECX, AND EDX back into their memory.
	pop		EDX

ENDM


ARRAYSIZE = 10

.data

program_title		BYTE		"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures ", 0
programmer_name		BYTE		"Written by: Hannah Woo", 0
introduction_1		BYTE		"Please provide 10 signed decimal integers.", 0
introduction_2		BYTE		"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw", 0
introduction_3		BYTE		"numbers I will display a list of the integers, their sum, and their average value.", 0
prompt_1			BYTE		"Please enter a signed number: ", 0
error_msg			BYTE		"ERROR: You did not enter a signed number or your number was too big. Please try again.", 0
list_msg			BYTE		"You entered the following numbers: ", 0
avg_msg				BYTE		"The truncated average is: ", 0
sum_msg				BYTE		"The sum of these numbers is: ", 0
goodbye				BYTE		"Thanks for playing!",0 
comma				BYTE		", ", 0
instring			BYTE		21 DUP (0)
outstring			BYTE		21 DUP (0)
numarray			SDWORD		ARRAYSIZE DUP(0)
sum					SDWORD		?
avg					SDWORD		?
tempnum				SDWORD		?
bytecount			SDWORD		?
arraycount			DWORD		?
restart				DWORD		0
reverse				BYTE		21 DUP (0)

.code
main PROC

; Display all introductions 
	push	OFFSET program_title
	push	OFFSET programmer_name
	push	OFFSET introduction_1
	push	OFFSET introduction_2
	push	OFFSET introduction_3
	call	introduction

	; Set the counter for 10 numbers for the loop.
	mov		ECX, ARRAYSIZE

_retrieve:
	; Push the counter into the stack and retrieve it after readval.
	push	ECX

	; Retrieve a string from the user and validate if it is a valide number
	push	OFFSET restart
	push	OFFSET numarray
	push	OFFSET arraycount
	push	OFFSET tempnum
	push	OFFSET error_msg
	push	OFFSET prompt_1
	push	OFFSET instring
	push	SIZEOF instring
	push	bytecount
	call	readval

	; Pop the counter back into ECX
	pop		ECX
	
	; If there was an error input then add 1 to the counter.
	cmp		restart, 1
	je		_restart
	jmp		_continue

_restart:
	; If an error has occuredc then add 1 to the counter for the loop.
	inc		ECX

_continue:
	LOOP	_retrieve

	; Subprocedures below will help with displaying the desired contents of the array.

	; Display the list of numbers
	push	OFFSET tempnum
	push	OFFSET reverse
	push	OFFSET outstring
	push	OFFSET list_msg
	push	OFFSET comma
	push	OFFSET numarray
	push	ARRAYSIZE
	call	displayList

	; Display the sum of the array
	push	OFFSET reverse
	push	OFFSET outstring
	push	OFFSET sum_msg
	push	OFFSET sum
	push	OFFSET numarray
	push	ARRAYSIZE
	call	displaysum

	; Display the average of the array.
	push	OFFSET reverse
	push	OFFSET outstring
	push	ARRAYSIZE
	push	OFFSET avg_msg
	push	OFFSET sum
	push	OFFSET avg
	call	displayavg

	;Extra Space
	call	Crlf
	call	Crlf
	
	; Say Goodbye
	push	OFFSET goodbye
	call	farewell


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
;
; Displays an introduction message containing the title and author of the program.
; Displayes the description of the duties of the program.
;
; Postconditions: EDX changed
;
; Recieves: 
;   [EBP + 24] = program_title
;	[EBP + 20] = programmer_name
;	[EBP + 16] = introduction_1
;	[EBP + 12] = introduction_2
;	[EBP + 8] = introduction_3
;
; Returns: Displays introduction messages to the user.
; ---------------------------------------------------------------------------------
introduction PROC
	; PUSH EBP into the stack and Set EBP as ESP
	push	EBP 
	mov		EBP, ESP 

	mDisplayString	[EBP + 24]
	call	Crlf
	mDisplayString	[EBP + 20]
	call	Crlf
	call	Crlf
	mDisplayString	[EBP + 16]
	call	Crlf
	mDisplayString	[EBP + 12]
	call	Crlf
	mDisplayString	[EBP + 8]
	call	Crlf
	call	Crlf

	; Return back to the original address.
	pop		EBP 
	ret		24

introduction ENDP

; ---------------------------------------------------------------------------------
; Name: readval
;
; Retrieve a valid signed number from the user.
; If it is not a valid number display an error message for the user and try again.
; If the number is valid add the number to the next open spot in the array.
;
; Postconditions: EAX, EBX, ECX, EDX, EDI, ESI changed
;
; Recieves: 
;	[EBP + 40] = restart = if an error message was prompted then add one to the outside ecx counter.
;	[EBP + 36] = numarray = Array that holds all the numbers
;	[EBP + 32] = arraycount = provides the correct spacing to place the next number in the array.
;	[EBP + 28] = temp_num = temporary place holder for the num converted.
;   [EBP + 24] = error_msg = String to notify the user that an error has occured.
;	[EBP + 20] = prompt_1 = Display the prompt for the user to input a number.
;	[EBP + 16] = instring = buffer string to retrieve a number from the user.
;	[EBP + 12] = The size of the number that can be inputed from the user.
;	[EBP + 8] = bytecount = amount of character the user inputed.
;
; Returns: Retrieves the number from the user and updates the numarray with a SDWORD value.
; ---------------------------------------------------------------------------------
readval PROC
	CLD
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Restart the restart counter.
	MOV		EAX, [EBP + 40]
	MOV		EBX, 0
	MOV		[EAX], EBX

_start:
	; Display the prompt for the user to input a number.
	mDisplayString	[EBP + 20]
	JMP _getuser

_getuser:
	; Call the macro to retrieve a stirng from the user.
	mGetString	[EBP + 16], [EBP + 12], [EBP + 8]

	; Establish all necessary registers.
	MOV		ECX, [EBP + 8]
	MOV		ESI, [EBP + 16]
	MOV		EBX, 0
	MOV		EDI, [EBP + 28]
	MOV		[EDI], EBX
	MOV		EDX, 0
	
	; If the characters entered from the user is greater than 11, then display an error.
	CMP		ECX, 11
	JG		_wrong
	JMP		_proceed

_proceed:
	; Check if the first character is a + or a -
	LODSB
	DEC		ECX
	CMP		AL, 43
	JE		_positive
	CMP		AL, 45
	JE		_negative

	; If there is no sign then treat the first character as a positive number.
	INC		ECX
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong
	SUB		AL,48

	; Add the character as the first one, if the input is a single digit then add it to the array.
	ADD		[EDI], AL
	CMP		ECX, 1
	JE		_addarray
	loop	_positive

_negative:
	; Multiplies the current number by 10
	MOV		EDX, 0
	MOV		EAX, [EDI]
	MOV		EBX, 10					
	MUL		EBX	

	; If the multipication causes it to go over 32 bits, then raise an error. Else, continue
	CMP		EDX, 0
	JNZ		_wrong
	MOV		[EDI], EAX							
	
	; Clear EAX
	mov		EAX, 0

	; Use string primitives to go through the string and determine if the inputs are numbers.
	LODSB							
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong

	; If they are numbers then subtract it by 48 and put it in the number generator.
	SUB		AL, 48
	MOVSX	EBX, AL
	MOV		EAX, [EDI]

	; If the addition causes the number to go over 32 bit registry, raise an error.
	ADD		EAX, EBX
	JC		_wrong
	MOV		[EDI], EAX
	loop	_negative	
	
	; Converts the number to a negative number
	MOV		EAX, [EDI]
	NEG		EAX
	MOV		[EDI], EAX
	JMP		_addarray

_positive:
	; Multiploes the current number by 10
	MOV		EDX, 0
	MOV		EAX, [EDI]
	MOV		EBX, 10					
	MUL		EBX					
	CMP		EDX, 0
	JNZ		_wrong
	MOV		[EDI], EAX	

	; Clear EAX
	mov		EAX, 0

	; Use string primitives to go through the string and determine if the inputs are numbers.
	LODSB							
	CMP		AL, 48
	JL		_wrong
	CMP		AL, 58
	JG		_wrong
	
	; If they are numbers then subtract it by 48 and put it in the number generator.
	SUB		AL, 48
	MOVSX	EBX, AL
	MOV		EAX, [EDI]

	; If the addition causes the number to go over 32 bit registry, raise an error.
	ADD		EAX, EBX
	JC		_wrong
	MOV		[EDI], EAX

	loop	_positive					
	JMP		_addarray

_addarray:

	; Have ESI be the new value that we are putting into the array and ESI as the array address we are putting the number in.
	MOV		ESI, [EDI]
	MOV		EDI, [EBP + 36]
	MOV		EAX, [EBP + 32]

	; Space the address of the array to the next open spot.
	MOV		EBX, [EAX]
	ADD		EDI, EBX
	ADD		EBX, 4

	; Add four for the next spot of the array and place the number into the open array.
	MOV		[EAX], EBX
	MOV		[EDI], ESI

	JMP		_done

_wrong:
	; Display an error message letting the user know that they put in the wrong number
	mDisplayString	[EBP + 24]

	; Set the restart flag to 1.
	MOV		EAX, [EBP + 40]
	MOV		EBX, 1
	MOV		[EAX], EBX

	;Extra space
	CALL	Crlf

_done:
	POP		EBP 
	RET		36

readval ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Given a numeral value, covert it to a string with ASCII conversion.
; Reverse the string as the base result will be backways.
;
; Postcondition: EAX, EBX, ECX, EDX, EDI, ESI were changed
;
; Recieves: 
;	[EBP + 16] = reverse, which is what the actual string should be.
;	[EBP + 12] = outstring for the string
;	[EBP + 8] = value that should be turned into a string
;
; Returns: Will display a string for the user.
; ---------------------------------------------------------------------------------
writeval PROC
	CLD
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 
	
	; EAX will represent the number and EDI will be where the temp string will be written
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]
	MOV		EDI, [EBP + 12]

	; If the number is less than 0 then append the negative sign to the string
	CMP		EAX, 0
	JE		_zero
	JL		_negative
	JMP		_positive

_negative:
	; Set ESI to 1 to make it a negative number.
	MOV		ESI, 1

	; Put EAX back as the number we are going ot iterate through.
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]
	NEG		EAX

	; Initialize a counter for numbers to be input
	MOV		EBX, 1
	PUSH	EBX
	JMP		_writeloop

_positive:
	; Set ESI to 0 to make it a positive number
	MOV		ESI, 0

	; Put EAX back as the number we are going ot iterate through.
	MOV		EAX, [EBP + 8]
	MOV		EAX, [EAX]

	; Initialize a counter for numbers to be input
	MOV		EBX, 0
	PUSH	EBX

_writeloop:
	; increae the counter by 1
	POP		EBX
	ADD		EBX, 1
	PUSH	EBX

	; Divide the number that you want by 10 and the remainder is now in EDX.
	MOV		EBX, 10
	MOV		EDX, 0
	CDQ
	IDIV	EBX

	; Temporary move the EAX aside so that we can write the string into the tempword.
	MOV		EBX, EAX
	MOV		EAX, EDX
	ADD		EAX, 48
	STOSB

	; move the divided number back into EAX and repeat the loop.
	MOV		EAX, EBX

	; If the number we are dividing by is 0, leave.
	CMP		EAX, 0
	JE		_reverse
	JMP		_writeLoop

_zero:
	; Display a zero and leave the funciton.
	MOV		AL, 48
	STOSB

	mDisplayString [EBP + 12]
	JMP		_out
	
_reverse:
	; If it is negative then we need to append the negative sign afterwards.
	CMP		ESI, 1
	JE		_sign
	JMP		_nosign

_sign:
	; Place the negative sign at the end of the string.
	MOV		AL, 45
	STOSB

_nosign:
	; The following reverse string was referenced from the canvass module.
	POP		EBX
	MOV		ECX, EBX
	MOV		ESI, [EBP + 12]
	ADD		ESI, ECX
	DEC		ESI
	MOV		EDI, [EBP + 16]

_revloop:
	STD
	LODSB
	CLD
	STOSB
	LOOP	_revLoop

_donewrite:
	mDisplayString [EBP + 16]

;Clear both the temp and the reserve string
	MOV		AL, 0
	MOV		ECX, EBX
	MOV		EDI, [EBP + 16]
	REP		STOSB

;Clear both the temp and the reserve string
	MOV		AL, 0
	MOV		ECX, EBX
	MOV		EDI, [EBP + 12]
	REP		STOSB

	_out:

	POP		EBP 
	RET		12
writeval ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; 
; It will loop through the array and place the number of its current iteration into tempnum
; then tempnum will be pushed with the outstring and reverse in order to CALL writeval
;
; Postcondition: EAX, EBX, ECX, EDX, EDI were changed
;
; Recieves:
;	[EBP + 8] = ARRAYSIZE
;	[EBP + 12] = address of numArray
;	[EBP + 16] = Comma, spacing inbetween numbers
;	[EBP + 20] = list_msg = display title of the list to show that it is the list of all numbers.
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user.
;	[EBP + 32] = tempnum = Placeholder for the number to be converted to a string is sent to WriteBal
;
; Returns: Displays the list of numbers from the array
; ---------------------------------------------------------------------------------
displayList	Proc
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Set the count ECX to the size of the array and EDI to the address of the array.
	MOV		ECX, [EBP + 8]
	MOV		EDI, [EBP + 12]
	MOV		EBX, [EBP + 32]

	; Display the title in the console.
	CALL CrLf
	mDisplayString	[EBP + 20]
	call CrLf

_dlloop:
	; Move the current value into tempnum.
	MOV		EAX, [EDI]
	MOV		[EBX], EAX
	
	; Push the registries for ECX, EDI, and EBX.
	PUSH	ECX
	PUSH	EDI
	PUSH	EBX
	
	; Push the necessary addresses to WriteVal
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 32]
	CALL	WriteVal

	; Restore registers
	POP		EBX
	POP		EDI
	POP		ECX

	; If we are at the end of the displaylist, then do not print a comma.
	CMP		ECX, 1
	JE		_noextracomma
	JMP		_extracomma
_extracomma:
	; Add space inbetween the numbers and increment ESI, If ESI is 20 then we need to skip the line.
	mDisplayString	[EBP + 16]
	ADD		EDI, 4
_noextracomma:
	LOOP	_dlloop

	; Add space 
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		28

displayList	ENDP


; ---------------------------------------------------------------------------------
; Name: displaysum
; 
; It will loop through the array and summate the elements into sum.
; then sum will be pushed with the outstring and reverse in order to CALL writeval
;
; Postcondition: EAX, EBX, ECX EDX, EDI, ESI were changed
;
; Recieves:
;	[EBP + 8] = ARRAYSIZE
;	[EBP + 12] = address of numArray
;	[EBP + 16] = sum of numbers
;	[EBP + 20] = display title of the list to show that it is the list of all numbers.
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user.
;
; Returns: A list of numbers will be displayed to the user.
; ---------------------------------------------------------------------------------
displaysum PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 

	; Set the count ECX to the size of the array and EDI to the address of the array.
	MOV		ECX, [EBP + 8]
	MOV		EDI, [EBP + 12]
	MOV		ESI, [EBP + 16]

	; Display the title in the console.
	mDisplayString	[EBP + 20]

_dsloop:
	; Move the current value at address EDI into EAX.
	MOV		EAX, [EDI]
	MOV		EBX, [ESI]
	ADD		EAX, EBX

	; Continually adds the array elements.
	MOV		[ESI], EAX
	ADD		EDI, 4
	LOOP	_dsloop

	; Push the necessary addresses to WriteVal
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 16]
	CALL	WriteVal

	; Add space
	CALL	Crlf

	; Return back to the original address.
	POP		EBP 
	RET		24
displaysum ENDP

; ---------------------------------------------------------------------------------
; Name: displayavg
;
; Divide the sum by the size of the array to find the average of the list.
; then avg will be pushed with the outstring and reverse in order to CALL writeval
;
; Recieves: 
;	[EBP + 8] = avg = keeps track  of the average of the numbers.
;	[EBP + 12] = sum = keeps track of the sum of the numbers.
;	[EBP + 16] = Message to prompt the user this is the average of the list of numbers.
;	[EBP + 20] = Size of the Array
;	[EBP + 24] = outstring, temperary outstring for the writeval.
;	[EBP + 28] = reverse = reversed string to actually output to the user
;
; Returns: Displayes the average to the user using the writeval procedure
; ---------------------------------------------------------------------------------
displayavg PROC
	; PUSH EBP into the stack and Set EBP as ESP
	PUSH	EBP 
	MOV		EBP, ESP 
	
	; Display the type of information will be displayed for the user.
	mDisplayString	[EBP + 16]

	; Set up necessary registers for division.
	MOV		ECX, [EBP + 8]
	MOV		EDX, 0
	MOV		EAX, [EBP + 12]
	MOV		EBX, [EBP + 20]

	; Divide the sum by the array size and move the contents into the avg
	MOV		EAX, [EAX]
	CDQ
	IDIV	EBX

	; The number will always round down positive so if the number is negative then round to the lowest number.
	CMP		EAX, 0
	JL		_lower
	JMP		_same

_lower:
	DEC		EAX

_same:
	; Place the new average into avg.
	MOV		[ECX], EAX

	; Move the current value at address EDI into EAX.
	PUSH	[EBP + 28]
	PUSH	[EBP + 24]
	PUSH	[EBP + 8]
	CALL	WriteVal

	; Return back to the original address.
	pop		EBP 
	ret		24
displayavg ENDP

; ---------------------------------------------------------------------------------
; Name: farewell

; Display's goodbye message to the user
;
; Recieves: 
;	[EBP + 8] = goodbye
;
; Returns: the goodbye message to the user
; ---------------------------------------------------------------------------------
farewell PROC
	; PUSH EBP into the stack and Set EBP as ESP
	push	EBP 
	mov		EBP, ESP 
	
	; Display the goodbye message
	mDisplayString	[EBP + 8]
	call	Crlf

	; Return back to the original address.
	pop		EBP 
	ret		4

farewell ENDP

END main
