TITLE Project 4 - Nested Loops and Procedures     (Proj4_wooha.asm)

; Author: Hannah Woo
; Last Modified: 02/25/24
; OSU email address: wooha@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4                Due Date: 02/25/24
; Description: This program calculates and displays prime numbers. The program should prompt the user to enter the number of 
;			   prime numbers they would like to see, validate the input, and then display the prime numbers up to the nth 
;			   prime. The program also has the extra credit option which is to align the output columns 
;              so that the first digit of each number on a row matches with the row above.

INCLUDE Irvine32.inc

LOWER_BOUND = 1
UPPER_BOUND = 200

.data

program_title			BYTE	"Prime Numbers Programmed by Hannah Woo", 0
extracredit				BYTE	"EC: Align the output columns (the first digit of each number on a row should match with the row above). (1pt)", 0
instruction1			BYTE	"Enter the number of prime numbers you would like to see.",13,10 
						BYTE	"I'll accept orders for up to 200 primes.", 13, 10, 13, 10, 0
userinput_prompt		BYTE	"Enter the number of primes to display [1 ... 200]: ", 0
userinput				DWORD	?
errormessage			BYTE	"No primes for you! Number out of range. Try again.", 0
farewellmessage			BYTE	"Results certified by Hannah Woo. Goodbye.", 0
space					BYTE	" ",9,0			
row						DWORD	10				; only 10 prime numbers per line 
numberToCheck			DWORD	1
invalidInputFlag		DWORD	0				; checks whether the input provided by the user is invalid
isPrimeFlag				DWORD	0				; checks whether a number is prime or not
numberOfPrimesDisplayed	DWORD	0


.code
main PROC

	call	introduction
	call	getUserData
	call    showPrimes
	call	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP


introduction PROC
; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: Displays the program title and instructions to the user.
;
; Preconditions: None.
;
; Postconditions: None. No registers are changed by this procedure.
;
; Receives: Nothing
;
; Returns: Nothing. No data is returned by this procedure.
; ---------------------------------------------------------------------------------
	mov		edx, OFFSET program_title
	call	WriteString
	call	CrLf

	mov		edx, OFFSET extracredit
	call	WriteString
	call	CrLf

	call	CrLf
	mov		edx, OFFSET instruction1
	call	WriteString
	RET
introduction ENDP


getUserData PROC
; ---------------------------------------------------------------------------------
; Name: getUserData
;
; Description: Prompts the user to enter a number and validates the input.
;
; Preconditions: Assumes WriteString, ReadDec, and validate are functional. Assumes
;     LOWER_BOUND and UPPER_BOUND are defined constants.
;
; Postconditions: userinput contains a valid number between LOWER_BOUND and UPPER_BOUND.
;
; Receives: No explicit inputs.
;
; Returns: No explicit returns.
; ---------------------------------------------------------------------------------
userinputLoop:
	mov		edx, OFFSET userinput_prompt
	call	WriteString
	call	ReadDec
	mov		userinput, eax
	call	validate
	cmp		invalidInputFlag, 1
	je		userinputLoop
	call	Crlf
	ret

getUserData ENDP


validate PROC 
; ---------------------------------------------------------------------------------
; Name: validate
;
; Description: Validates the user input to ensure it is within the specified range.
;
; Preconditions: Assumes LOWER_BOUND and UPPER_BOUND are defined constants.
;
; Postconditions: None. No registers are changed by this procedure.
;
; Receives:
;     userinput: user's input number to be validated
;     LOWER_BOUND, UPPER_BOUND: constants defining the valid input range
;
; Returns: None. If the input is invalid, the procedure sets invalidInputFlag to 1.
; ---------------------------------------------------------------------------------
	; Check if userinput is less than 1
	mov		eax, userinput
	cmp		eax, LOWER_BOUND
	jl		error

	; Check if userinput is greater than 200
	cmp		eax, UPPER_BOUND
	jg		error

	; If user input is valid, proceed to valid
	jmp		valid

error:
	; Display error message
	mov		edx, OFFSET errormessage
	call	WriteString
	call	CrLf
	; set invalidInputFlag flag
	mov		invalidInputFlag, 1
	ret

valid:
	; Set the invalidInputFlag to 0
	mov		invalidInputFlag, 0
	ret

validate ENDP


showPrimes PROC
; ---------------------------------------------------------------------------------
; Name: showPrimes
;
; Description: Displays prime numbers up to the user's specified limit.
;
; Preconditions: Assumes isPrime is functional.
;
; Postconditions: None.
;
; Receives: Nothing explicit.
;
; Returns: Nothing explicit.
; ---------------------------------------------------------------------------------
    mov        ecx, userinput

    ; Checks if the user input is equal to 1
    cmp        userInput, 1
    ; If it is, then jump to HandleSpecialCase
    je        HandleSpecialCase

CheckforPrimesLoop:
    ; Reset isPrimeFlag
    mov		isPrimeFlag, 0
    inc     numberToCheck
    call    isPrime

    ; Print numberToCheck
    cmp     isPrimeFlag, 0
    je      Checkforprimesloop 

    mov        eax, numberToCheck
    call         WriteDec
    mov        edx, OFFSET space
    call    WriteString
    inc        numberOfPrimesDisplayed
    ; Check if a new line is needed
    mov        edx, 00000000h
    mov        eax, numberOfPrimesDisplayed
    div        row
    cmp        edx, 0
    je        newLine
    jmp        continueloop

newLine:
    call    Crlf

continueloop:
    LOOP    CheckforPrimesLoop
	cmp		ecx, 0
	je		done


HandleSpecialCase:                ; Special case that handles when prime is 1
    mov        eax, 2
    call    WriteDec

done:
    call Crlf
    call Crlf
    ret

showPrimes ENDP



isPrime PROC 
; ---------------------------------------------------------------------------------
; Name: isPrime
;
; Description: Checks if a given number is prime.
;
; Preconditions: None.
;
; Postconditions: isPrimeFlag is set to 1 if the number is prime, 0 otherwise.
;
; Receives: Nothing explicit.
;
; Returns: Nothing explicit.
; ---------------------------------------------------------------------------------
	; Check to see if numberToCheck is a prime or not
	xor		ebx, ebx	; Reset EBX (use ebx instead of ecx for the loop counter)
	mov		ebx, numberToCheck
	dec		ebx		; Decrement ebx to start checking from numberToCheck - 1

Checkifprime:
	cmp		ebx, 1
	je		PrimeCheckCompleted
	mov		edx, 0
	mov		eax, numberToCheck
	div		ebx
	cmp		edx, 0
	je		done
	dec		ebx		; Decrement ebx for the next iteration
	jmp		Checkifprime
	
PrimeCheckCompleted:
	; It's a prime if the loop completes and does not jump to done
	mov		isPrimeFlag, 1
	
done:
	; If remainder is 0, then ebx is a multiple
	ret

isPrime ENDP


farewell PROC
; ---------------------------------------------------------------------------------
; Name: farewell
;
; Description: Displays a farewell message to the user.
;
; Preconditions: None.
;
; Postconditions: None. No registers are changed by this procedure.
;
; Receives: No explicit inputs. Assumes CrLf and WriteString are functional.
;
; Returns: None. No data is returned by this procedure.
; ---------------------------------------------------------------------------------

	call	CrLf
	mov		edx, OFFSET farewellmessage
	call	WriteString
	ret

farewell ENDP


END main
