
;   A prime number (or a prime) is a natural number greater than 1 that has no positive divisors other than 1 and itself.

;	*****************************************************************************************************************
;	*														*
;	* Please note how the comments on the right allows almost anybody to create the assembly language to its left	*
;	*														*
;	*****************************************************************************************************************

.MODEL  SMALL

.stack  100H			; start the stack at SS:100H

    .DATA
           VAl1     DB      ?
           NL1      DB      0AH,0DH,'ENTER NO:','$' 
           NL2      DB      0AH,0DH,'IT IS NOT PRIME','$'
           NL3      DB      0AH,0DH,'IT IS PRIME','$'

           .CODE
    MAIN:
            MOV AX,@DATA	; setup the DS register value
            MOV DS,AX

            LEA DX,NL1		; setup console out
            MOV AH,09H		; to print ASCII string asking the
            INT 21H		; user to enter a number
    
            MOV AH,01H		; setup to read an ASCII number (0-9) into AL
            INT 21H		; via DOS interrupt
            SUB AL,30H		; subtract ASCII numeric bias of 30H leaving raw binary in AL
            MOV VAL1,AL		; save a copy of this binary value as a variable

            CMP VAL1, 1H        ; compare the inputted value with 1
            JBE LBL2            ; if it is 0 or 1 output that the number is not prime

            CMP VAL1, 3H        ; compare the inputted value with 3
            JBE LBL3            ; if it is 0|1|2|3 output that the number is prime

            ; note, the case of 0 or 1 can not reach to this part of code, because of the comparision on line 34
            
            MOV AH,00		; clear AH so we have a clean AX/CL division
            MOV CL,2		; set up to divide AX by 2
            DIV CL		; with quotient in AL, remainder in AH
            MOV CL,AL		; copy the quotient (which is 1/2 the inputted value, prime or not) into CL

    LBL1:
            MOV AH,00		; again, clear AH so we have a clean AX/CL division
            MOV AL,VAL1		; setup to divide the inputted value
            DIV CL		; by 1/2 of itself
            CMP AH,00		; then check if there is a remainder in AH, if zero it was an even division
            JZ LBL2		; if so, notify the user that we do not have a prime
            DEC CL		; decrement CL by one until
            CMP CL,1		; it reaches a value of 1
            JNE LBL1		; keep dividing the inputted value by decremented divisor values, started from VAL1/2 down to 2. Loop until divisor = 1
            JMP LBL3		; if divisor = 1 than VAL1 was not equally divisible by any number from 1 to VAL/2, notify user that the inputted value is a prime number 
    
    LBL2:
    
            MOV AH,09H		; setup to notify user
            LEA DX,NL2		; that the value entered
            INT 21H		; is not a prime by a DOS console out of NL2 ASCII string and
            JMP EXIT		; Exit to DOS prompt
    
    LBL3:
            MOV AH,09H		; setup to notify user
            LEA DX,NL3		; that the value entered
            INT 21H		; is a prime by a DOS console out of NL2 ASCII string
           
           			; code flows to termination and to DOS prompt
    
    EXIT:
            MOV AH,4CH		; setup to terminate program and
            INT 21H		; return to the DOC prompt
    

            END     MAIN
