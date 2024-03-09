TITLE Project 1 - Basic Logic and Arithmetic Program   (Proj1_wooha.asm)

; Author: Hannah Sophia Woo
; Last Modified: 01/27/24
; OSU email address: woohD@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                Due Date: 01/28/24
; Description: A program that displays my name and the program title on the output screen, displays instructions for the user, 
	; prompts the user to enter three numbers in strictly descending order, calculate the sum and differences, displays 
	; the results and a closing message.
;EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A.


INCLUDE Irvine32.inc

.data

my_name				BYTE	"by Hannah Woo", 0
program_title		BYTE	"         Elementary Arithmetic     ", 0
instructions		BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences.", 0
num_1				SDWORD	?
num_1_prompt		BYTE	"Enter the first number: ", 0
num_2				SDWORD	?
num_2_prompt		BYTE	"Enter the second number: ", 0
num_3				SDWORD	?
num_3_prompt		BYTE	"Enter the third number: ", 0
sum1_2				DWORD	?
difference1_2		DWORD	?
sum1_3				DWORD	?
difference1_3		DWORD	?
sum2_3				DWORD	?
difference2_3		DWORD	?
sum1_2_3			DWORD	?
plus				BYTE	" + ", 0
minus				BYTE	" - ", 0
equals				BYTE	" = ", 0
ec_prompt			BYTE	"**EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A.", 0
negative_prompt		BYTE	"How about handling negative results, eh?", 0
difference2_1		DWORD	?
difference3_1		DWORD	?
difference3_2		DWORD	?
difference3_2_1		DWORD	?
closing_message1	BYTE	"Thanks for using Elementary Arithmetic!  ", 0
closing_message2	BYTE	"Goodbye!", 0

.code
main PROC

	; Introduction
	mov		edx, OFFSET program_title
	call	WriteString
	mov		edx, OFFSET my_name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_prompt
	call	WriteString
	call	CrLf

	call	CrLf
	mov		edx, OFFSET instructions
	call	WriteString
	call	CrLf

	; Get the data
	mov		edx, OFFSET num_1_prompt
	call	WriteString
	mov		edx, OFFSET num_1
	call	ReadDec
	mov		num_1, eax					; store it to num_1

	mov		edx, OFFSET num_2_prompt
	call	WriteString
	mov		edx, OFFSET num_2
	call	ReadDec
	mov		num_2, eax

	mov		edx, OFFSET num_3_prompt
	CALL	WriteString
	mov		edx, OFFSET num_3
	call	ReadDec
	mov		num_3, eax
	call	CrLf

	; Calculate the sum of num 1 and 2
	mov		eax, num_1
	mov		ebx, num_2
	add		eax, ebx
	mov		sum1_2, eax

	; Display the results sum of num 1 and 2
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum1_2
	call	WriteDec
	call	CrLf

	; Calculate the difference of num 1 and 2
	mov		eax, num_1
	mov		ebx, num_2
	sub		eax, ebx
	mov		difference1_2, eax

	; Display the results difference of num 1 and 2
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, difference1_2
	call	WriteDec
	call	CrLf

	; Calculate the sum of num 1 and 3
	mov		eax, num_1
	mov		ebx, num_3
	add		eax, ebx
	mov		sum1_3, eax

	; Display the results sum of num 1 and 3
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum1_3
	call	WriteDec
	call	CrLf

	; Calculate the difference of num 1 and 3
	mov		eax, num_1
	mov		ebx, num_3
	sub		eax, ebx
	mov		difference1_3, eax

	; Display the results difference of num 1 and 3
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, difference1_3
	call	WriteDec
	call	CrLf

	; Calculate the sum of num 2 and 3
	mov		eax, num_2
	mov		ebx, num_3
	add		eax, ebx
	mov		sum2_3, eax

	; Display the results sum of num 2 and 3
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum2_3
	call	WriteDec
	call	CrLf

	; Calculate the difference of num 2 and 3
	mov		eax, num_2
	mov		ebx, num_3
	sub		eax, ebx
	mov		difference2_3, eax

	; Display the results difference of num 2 and 3
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, difference2_3
	call	WriteDec
	call	CrLf

	; Calculate the sum of num 1, num 2 and num 3
	mov		eax, num_1
	mov		ebx, num_2
	add		eax, ebx
	mov		sum1_2_3, eax
	mov		eax, sum1_2_3
	mov		ebx, num_3
	add		eax, ebx
	mov		sum1_2_3, eax

	; Display the results sum of num 1, num 2 and num 3
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum1_2_3
	call	WriteDec
	call	CrLf

	; Negative Result Prompt (extrac credit)
	call	CrLf
	mov		edx, OFFSET negative_prompt
	call	WriteString
	call	CrLf

	; Calculate the difference of num 2 and 1
	call	CrLf
	mov		eax, num_2
	mov		ebx, num_1
	sub		eax, ebx
	mov		difference2_1, eax

	; Display the results difference of num 2 and 1
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString

	; Check if the result is negative and adjust formatting
	mov		eax, difference2_1
	cmp		eax, 0
	jge		non_negative2_1			; Jump if non-negative

	; Display the negative sign and negate the result
	mov		edx, OFFSET minus
	call	WriteString
	neg		difference2_1			; Negate the result to make it positive

	non_negative2_1:
		mov		eax, difference2_1
		call	WriteDec

	; Calculate the difference of num 3 and 1
	call	CrLf
	mov		eax, num_3
	mov		ebx, num_1
	sub		eax, ebx
	mov		difference3_1, eax

	; Display the results difference of num 3 and 1
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString

	; Check if the result is negative and adjust formatting
	mov		eax, difference3_1
	cmp		eax, 0
	jge		non_negative3_1			; Jump if non-negative

	; Display the negative sign and negate the result
	mov		edx, OFFSET minus
	call	WriteString
	neg		difference3_1			; Negate the result to make it positive

	non_negative3_1:
		mov		eax, difference3_1
		call	WriteDec

	; Calculate the difference of num 3 and 2
	call	CrLf
	mov		eax, num_3
	mov		ebx, num_2
	sub		eax, ebx
	mov		difference3_2, eax

	; Display the results difference of num 3 and 2
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString

	; Check if the result is negative and adjust formatting
	mov		eax, difference3_2
	cmp		eax, 0
	jge		non_negative3_2			; Jump if non-negative

	; Display the negative sign and negate the result
	mov		edx, OFFSET minus
	call	WriteString
	neg		difference3_2			; Negate the result to make it positive

	non_negative3_2:
		mov		eax, difference3_2
		call	WriteDec

	; Calculate the difference of num 3, num 2 and num 1
	mov		eax, num_3
	mov		ebx, num_2
	sub		eax, ebx
	mov		difference3_2_1, eax
	mov		eax, difference3_2_1
	mov		ebx, num_1
	sub		eax, ebx
	mov		difference3_2_1, eax

	; Display the results difference of num 3, num 2, and num 1
	call	CrLf
	mov		eax, num_3
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString

	; Check if the result is negative and adjust formatting
	mov		eax, difference3_2_1
	cmp		eax, 0
	jge		non_negative3_2_1			; Jump if non-negative

	; Display the negative sign and negate the result
	mov		edx, OFFSET minus
	call	WriteString
	neg		difference3_2_1				; Negate the result to make it positive

	non_negative3_2_1:
		mov		eax, difference3_2_1
		call	WriteDec
		call	CrLf
	
	; Say Goodbye
	call	CrLf
	mov		edx, OFFSET closing_message1
	call	WriteString
	mov		edx, OFFSET closing_message2
	call	WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
