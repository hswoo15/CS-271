TITLE Project 5 - Arrays, Addressing, and Stack-Passed Parameters     (Proj5_wooha.asm)

; Author: Hannah Woo
; Last Modified: March 4, 2023
; OSU email address: wooha@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  5               Due Date: March 3, 2024
; Description: This program generates an array of random integers, sorts it, calculates and displays the median value, and 
;			   generates another array to count the occurrences of each value within a specified range. 

INCLUDE Irvine32.inc

; (insert macro definitions here)

ARRAYSIZE = 200
LO = 15
HI = 50

.data
programtitle    BYTE "Generating, Sorting, and Counting Random integers!                      Programmed by Hannah Woo",0
intro2          BYTE "This program generates 200 random numbers in the range of 15 to 50, inclusive.",0
intro3          BYTE "Then, it displays the original list, sorts the list, displays the median value,",0
intro4          BYTE "displays the list sorted in ascending order, then displays the number of instances",0
intro5          BYTE "of each generated value, starting with the number of lowest.",0
unsort          BYTE "Your unsorted random numbers: ",0
sort            BYTE "Your sorted random numbers:",0
medianIntro     BYTE "The median value of the array: ",0
instances       BYTE "Your list of instances of each generated number, "
                BYTE "starting with the smallest value:",0
spaces          BYTE " ",0
cList           BYTE "Your list of instances of each generated number, "
                BYTE "starting with the smallest value:",0
farewell        BYTE "Goodbye, and thanks for using my program!",0
randArray       DWORD 200 DUP(?)
counts          DWORD 200 DUP(?)
cArraySize      DWORD 0


.code
main PROC
   ;introduce the program
   push   OFFSET programtitle
   push   OFFSET intro2
   push   OFFSET intro3
   push   OFFSET intro4
   push   OFFSET intro5
   call   introduction

   ;fill the array
   push   OFFSET randArray
   push   ARRAYSIZE
   push   HI
   push   LO
   call   fillArray
   call   CrLf

   ;display title of unsorted array
   push   OFFSET unsort
   call   displayTitle
   call   CrLf

   ;display the unsorted list
   push   OFFSET randArray
   push   ARRAYSIZE
   push   OFFSET spaces
   call   displayList                   
   call   CrLf

   ;sort our array
   push   OFFSET randArray
   push   ARRAYSIZE
   call   sortList

   ;display title of median
   push   OFFSET medianIntro
   call   displayTitle

   ;display median
   push   OFFSET randArray
   push   ARRAYSIZE
   call   displayMedian
   call   CrLf
   call   CrLf

   ;display title of sorted array
   push   OFFSET sort
   call   displayTitle
   call   CrLf
  
   ;display sorted list
   push   OFFSET randArray
   push   ARRAYSIZE
   push   OFFSET spaces
   call   displayList                   
   call   CrLf

   ;display title for count list
   push   OFFSET cList
   call   displayTitle
   call   CrLf

   ;count the items in list and store them in counts
   push   OFFSET randArray
   push   OFFSET counts
   push   ARRAYSIZE
   push   OFFSET cArraySize
   call   countList

   ;display the counted array
   push   OFFSET counts
   push   cArraySize
   push   OFFSET spaces
   call   displayList                   
   call   CrLf
   call   CrLf

   ;display goodbye message
   push   OFFSET farewell
   call   displayTitle
   call   CrLf

	Invoke ExitProcess,0	
main ENDP

introduction PROC
; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: Introduces the program by displaying the provided messages.
;
; Preconditions: The addresses of intro, intro2, intro3, intro4 and intro5 must be valid.
;
; Postconditions: None.
;
; Receives: The addresses of intro, intro2, intro3, intro4 and intro5.
;
; Returns: None.
;
; Registers changed: ebp, edx
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

   mov    edx, [ebp+24]
   call   WriteString
   call   CrLf
   call   CrLf
   mov    edx, [ebp+20]
   call   WriteString
   call   CrLf
   mov    edx, [ebp+16]
   call   WriteString
   call   CrLf
   mov    edx, [ebp+12]
   call   writeString
   call   CrLf
   mov    edx, [ebp+8]
   call   writeString
   call   CrLf

   pop    ebp
   ret    20
introduction ENDP



fillArray PROC
; ---------------------------------------------------------------------------------
; Name: fillArray
;
; Fills an array with random numbers within a specified range.
;
; Preconditions: The address of the array must be valid.
;
; Postconditions: None.
;
; Receives:
;     [ebp+20] = address of the array
;     [ebp+16] = size of the array
;     [ebp+12] = upper limit of the random numbers range
;     [ebp+8] = lower limit of the random numbers range
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

   mov    esi, [ebp+20]           ;address of array
   mov    ecx, [ebp+16]           

_GetNumber:
   ;generate a random number within our range
   mov    eax, [ebp+12]           
   sub    eax, [ebp+8]           
   inc    eax
   call   RandomRange
   add    eax, [ebp+8]           

   ;store the random number in our next array position
   mov    [esi], eax
   add    esi, 4
   loop   _GetNumber

   pop    ebp
   ret    16
fillArray ENDP

displayTitle PROC
; ---------------------------------------------------------------------------------
; Name: displayTitle
;
; Displays a title string.
;
; Preconditions: The address of the title string must be valid.
;
; Postconditions: None.
;
; Receives:
;     [ebp+8] = address of the title string
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

   mov    edx, [ebp+8]           
   call   WriteString

   pop    ebp
   ret    4
displayTitle ENDP

displayList PROC
; ---------------------------------------------------------------------------------
; Name: displayList
;
; Displays an array of integers in columns of 20 elements.
;
; Preconditions: The address of the array and its size must be valid.
;
; Postconditions: Changes registers esi, ecx, ebx.
;
; Receives:
;     [ebp+16] = address of the array
;     [ebp+12] = size of the array
;     [ebp+8] = address of the spaces string
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

;setup the list and counter
   mov    esi, [ebp+16]           ;address of array
   mov    ecx, [ebp+12]           
   mov    edx, [ebp+8]           

;setup a columns counter
   mov    ebx, 20                  
      
;display the array
_DisplayLoop:
   mov    eax, [esi]
   call   WriteDec
   call   WriteString
   add    esi, 4
   dec    ebx
   cmp    ebx, 0
   jnz    _Continue
;if out of columns, make a new line
   mov    ebx, 20                   ;reset columns counter
   call   CrLf
_Continue:
   loop   _DisplayLoop

   pop    ebp
   ret    12
displayList ENDP

sortList PROC
; ---------------------------------------------------------------------------------
; Name: sortList
;
; Sorts an array of integers in ascending order.
;
; Preconditions: The address of the array and its size must be valid.
;
; Postconditions: Changes registers esi, ebx.
;
; Receives:
;     [ebp+12] = address of the array
;     [ebp+8] = size of the array
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

   mov    ecx, [ebp+8]           ;arraySize
   mov    esi, [ebp+12]           ;array
   sub    ecx, 1                   ;to keep our loop control in bounds

_Start:
   push   esi
   mov    ebx, 0
_Compare:
   mov    eax, [esi]             ;move next number into eax
   cmp    eax, [esi+4]           
   jg     _Switch               
   inc    ebx                   
   add    esi, 4
   cmp    ebx, ecx              
   je     _SortLoop              ;if no more numbers, loop around again
   jmp    _Compare

_Switch:
   push   eax
   push   ebx
   call   exchangeElements
   pop    ebx
   pop    eax
   pop    esi
   jmp    _Start

;if no switch, and at max, loop to next number to be compared
_SortLoop:
   pop    esi
   add    esi, 4
   loop   _Start

   pop    ebp
   ret    8
sortList ENDP

exchangeElements PROC
; ---------------------------------------------------------------------------------
; Name: exchangeElements
;
; Swaps two elements in an array.
;
; Preconditions: None.
;
; Postconditions: None.
;
; Receives:
;     esi = address of the first element
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

;swap items in array
   mov    eax, [esi]               ;current number
   mov    ebx, [esi+4]           
   mov    [esi], ebx
   mov    [esi+4], eax

   pop    ebp
   ret      
exchangeElements ENDP

displayMedian PROC
; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; Displays the median of an array of integers.
;
; Preconditions: The address of the array and its size must be valid.
;
; Postconditions: None.
;
; Receives:
;     [ebp+8] = address of the array
;     [ebp+12] = size of the array
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp
   mov    ebx, 2
   mov    esi, [ebp+12]           ;array

;check if list size is even or odd
   mov    edx, 0
   mov    eax, [ebp+8]           
   cdq
   idiv   ebx
   mov    ecx, eax               ;move into the counter for following loops
   cmp    edx, 0                  
   je     _EvenLoop
;odd array
   mov    ecx, eax
   sub    ecx, 1
_OddLoop:
   add    esi, 4
   loop   _OddLoop
   mov    eax, [esi]
   jmp    _Continue

;even array
_EvenLoop:
   add    esi, 4
   loop   _EvenLoop
;if no direct median, combine two middle numbers and get average of those
   mov    eax, [esi]
   add    eax, [esi-4]
   mov    ebx, 2
   cdq
   idiv   ebx

;display the new median
_Continue:
   call   WriteDec

   pop    ebp
   ret    8
displayMedian ENDP

countList PROC
; ---------------------------------------------------------------------------------
; Name: countList
;
; Counts the instances of each unique element in an array and stores them in another array.
;
; Preconditions: The addresses of the array and counts array, and the size of the array, must be valid.
;
; Postconditions: Changes registers esi, ebx, edi, cArraySize.
;
; Receives:
;     [ebp+20] = address of the array
;     [ebp+16] = address of the counts array
;     [ebp+12] = size of the array
;     [ebp+8] = address of the variable holding the size of the counts array
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp
   mov    esi, [ebp+20]       ; array
   mov    ecx, [ebp+12]       
   mov    ebx, -1             
   mov    edi, OFFSET counts  

   _Restart:
   inc    ebx                ; move to the next number to count instances
   mov    eax, 0             

   _Continue:
   cmp    ecx, 0             ; check if array is empty
   je     _Print             
   cmp    ebx, [esi]         
   jne    _Print             
   inc    eax               
   add    esi, 4             
   loop   _Continue          ; repeat until all numbers in the array are checked

   _Print:
   ; Add the count to the counts array
   cmp    eax, 0             
   je     _SkipZero          
   mov    [edi], eax         
   add    edi, 4             
   inc    cArraySize         ; increment the count of unique numbers
   _SkipZero:
   cmp    ebx, HI            
   jne    _Restart           
   pop    ebp
   ret    16
countList ENDP

addToList PROC
; ---------------------------------------------------------------------------------
; Name: addToList
;
; Adds a count to the counts array.
;
; Preconditions: None.
;
; Postconditions: None.
;
; Receives:
;     [ebp+8] = count of instances
;     [ebp+12] = address of the counts array
;
; Returns: None.
; ---------------------------------------------------------------------------------
   push   ebp
   mov    ebp, esp

   mov    esi, [ebp+8]        ; count of instances
   mov    edi, [ebp+12]       
   mov    ecx, cArraySize     

   ; Find an empty spot in the counts array to add the count
   _FindEmptySpot:
   cmp    ecx, 0              ; check if array is empty
   je     _Finish             
   cmp    dword ptr [edi], 0  ; Check if current spot is empty
   jne    _NextSpot          
   mov    [edi], esi         
   jmp    _Finish

   _NextSpot:
   add    edi, 4              ; Move to the next spot
   loop   _FindEmptySpot      

   _Finish:
   pop    ebp
   ret    8
addToList ENDP

END main
