.MODEL SMALL 

new_line macro
    mov ah,2
    mov dl,0Ah
    int 21h
    mov ah,2
    mov dl,0Dh
    int 21h 
endm

Five_Digit_in macro in_var
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,10000
    mov ch,0
    mul cx
    add in_var,ax   ;5th digit  
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,1000 
    mov ch,0
    mul cx
    add in_var,ax   ;4th digit    
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,100 
    mov ch,0
    mul cx
    add in_var,ax   ;3rd digit  
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,10 
    mov ch,0
    mul cx
    add in_var,ax   ;2nd digit 
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,1   
    mov ch,0
    mul cx
    add in_var,ax   ;1st digit  
    
endm

Four_Digit_in macro in_var
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,1000 
    mov ch,0
    mul cx
    add in_var,ax   ;4th digit    
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,100 
    mov ch,0
    mul cx
    add in_var,ax   ;3rd digit  
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,10 
    mov ch,0
    mul cx
    add in_var,ax   ;2nd digit 
    
    mov ah,1
    int 21h
    sub al,30h
    
    mov cl,al
    mov ax,1   
    mov ch,0
    mul cx
    add in_var,ax   ;1st digit  
    
endm

    
Five_Digit_out macro out_var  
    
    mov one, 0
    mov two , 0
    mov three , 0
    mov four , 0
    mov five , 0  
    
    mov dx,0
    mov ax,out_var
    mov bx,10
    div bx    
    mov one ,dx ; 1st digit
    
    mov dx ,0
    div bx 
    mov two , dx  ;2nd digit
    
    mov dx ,0
    div bx 
    mov three , dx  ;3rd digit 
    
    mov dx ,0
    div bx 
    mov four , dx  ;4th digit
     
    mov dx ,0
    div bx 
    mov five , dx  ;5th digit
    
    mov ah,2
    mov dx,five 
    add dl,30h
    int 21h  
    
    mov ah,2
    mov dx,four 
    add dl,30h
    int 21h
    
    mov ah,2
    mov dx,three 
    add dl,30h
    int 21h
    
    mov ah,2
    mov dx,two
    add dl,30h
    int 21h
    
    mov ah,2
    mov dx,one
    add dl,30h
    int 21h   
endm

            
    
 
.STACK 100H

.DATA
; decxare variables here 
 
;output Support variable
one dw 0
two dw 0
three dw 0
four dw 0
five dw 0  

;Supporting String 
Insuffient_money_str db "Insufficient Balance.$"
WithDraw_str db "Enter Withdrawal Amount: $"
WithDraw_Sucess_str db "Money Withdrawal Sucessful.New Balance: $" 
Give_mul_of_500_str db "Give Amount Multiple of 500.$"

Deposite_str db "Enter Amount: $"   
Deposite_Sucess_str db "Money Deposite Sucessful.New Balance: $" 

Statement_str db "Mini Statement: $"
Statement_Deposite_str db "Deposited: $" 
Statement_Withdraw_str db "Withdrawn: $"
No_transaction_str db "No Transaction Yet$"

Your_Balance_str db "Your Current Balance is: $"
 
Enter_Acc_Num db "Enter Your Account Number: $"
Enter_pass db "Enter Your Password: $"
No_Acc_Found_str db "No Account Found$"
Wrong_PassWord_str db "Your Password is Wrong$"
User_Option_str db "Choose an Option: $"
Account_Block_For_Multiple_Attempt_str db "This Account is blocked Due to Multiple Failed Attempt$"  

Max_Limit_Exceeded_str  db "Deposite Failed.You Exceed Maximum Balance Limit$"

option_1 db "1.Current Balance$"
option_2 db "2.Deposite$"
option_3 db "3.Withdraw$"
option_4 db "4.Mini Statement$"
option_5 db "5.Exit$"
;Input Supporting                                                                      
Current_withdraw dw 0
Current_deposite dw 0
Current_AccNum dw 0
Current_Pass dw 0
Current_option db 0 
 
;Main Details Array       
BALANCE_ARRAY dw 30000,4000,2000,30000, 2000,500,6000,3000,8000,1000  ;Ten User index format 0,2,4,6,8,10,12,14,16,18    

ACCOUNT_NUMBER_ARRAY dw 00001,00002,00003,00004,00005,00006,00007,00008,00009,00010   ;Ten User index format 0,2,4,6,8,10,12,14,16,18 

ACCOUNT_PASSWORD_ARRAY dw 1234,1234,1234,1234,1234,1234,1234,1234,1234,1234     ;Ten User index format 0,2,4,6,8,10,12,14,16,18   

FAILED_LOGIN_COUNT dw 0,0,0,0,0,0,0,0,0,0


;Sratement Supporting 
Statement_acc db 0

Statement_Tag_ARRAY dw 50 dup(?)
                                                                                                   
Statement_Value_ARRAY dw 50 dup(?)

                      

.CODE
MAIN PROC

; initialize DS

MOV AX,@DATA
MOV DS,AX
 
; enter your code here
Main_ATM_SERVICE:

    mov ah,9
    lea dx,Enter_Acc_Num
    int 21h
    
    mov Current_AccNum, 0 
    Five_Digit_in Current_AccNum
    new_line 
    
    mov ax,Current_AccNum   ;To use in compare 
    mov si ,0
    mov cx,10
    
    Check_Account:
    cmp ax,ACCOUNT_NUMBER_ARRAY[si]   ;Compare
    jne Next_Account_Check
     
    Check_PassWord:
    mov ax, FAILED_LOGIN_COUNT[si]
    cmp ax,2
    jg Account_Block_For_Multiple_Attempt
    
    mov ah,9
    lea dx,Enter_pass
    int 21h
    
    mov Current_Pass, 0 
    Four_Digit_in Current_Pass
    new_line
    mov ax,Current_Pass ; Use to compare
    
    cmp ax,ACCOUNT_PASSWORD_ARRAY[si] 
    jne Wrong_PassWord
    
    mov di,si  ; di holds the loged in account index
    
    mov ah,9
    lea dx ,option_1 
    int 21h
    new_line
    
    mov ah,9
    lea dx ,option_2 
    int 21h
    new_line
    
    mov ah,9
    lea dx ,option_3 
    int 21h 
    new_line
    
    mov ah,9
    lea dx ,option_4 
    int 21h
    new_line
    
    mov ah,9
    lea dx ,option_5 
    int 21h
    new_line
    
    User_Option: 
    mov ah,9
    lea dx,User_Option_str
    int 21h
    
    mov ah,1
    int 21h
    sub al,30h
    mov Current_option,al 
    new_line
    
    mov al,Current_option
    
    cmp al,1
    je BALANCE_PROC 
    
    
    cmp al,2
    je DEPOSITE_PROC
    
    
    cmp al,3
    je WITHDRAW_PROC 
  
    cmp al,4
    je STATEMENT_PROC
    
    cmp al,5
    je Log_in_exit 
    
    new_line
    jmp User_Option
    
    BALANCE_PROC:
    call BALANCE 
    new_line
    jmp User_Option 
    
    DEPOSITE_PROC:
    call DEPOSITE
    new_line
    jmp User_Option 
    
    WITHDRAW_PROC:
    call WITHDRAW 
    new_line
    jmp User_Option
    
    STATEMENT_PROC:
    call STATEMENT
    new_line
    jmp User_Option
    
    
    Account_Block_For_Multiple_Attempt:
    mov ah,9
    lea dx, Account_Block_For_Multiple_Attempt_str
    int 21h
    jmp Log_in_exit
    
    
    
        
    
    
    
    
    
    Wrong_PassWord:
    mov ah,9
    lea dx,Wrong_PassWord_str
    int 21h  
    new_line
    
    add FAILED_LOGIN_COUNT[si],1
    mov ax, FAILED_LOGIN_COUNT[si]
    cmp ax,3
    jl Check_PassWord
    
    jmp Account_Block_For_Multiple_Attempt
    
     
     
    Next_Account_Check:
    add si,2 
    loop Check_Account 
    
    mov ah,9
    lea dx,No_Acc_Found_str
    int 21h 
    
    Log_in_exit:
    new_line
    new_line 
    
    jmp Main_ATM_SERVICE
    
    












;exit to DOS
               
MOV AX,4C00H
INT 21H

MAIN ENDP

    
  


;Balance PROC
BALANCE proc 
    mov ah,9
    lea dx,Your_Balance_str
    int 21h
    
    Five_Digit_out BALANCE_ARRAY[di] 
    new_line
    ret
endp BALACE

    

;Withdraw PROC
WITHDRAW proc   ; Use di as the acc index
          
    mov Current_withdraw , 0 
    
    mov ah,9
    lea dx, WithDraw_str
    int 21h   
    
    Five_Digit_in Current_withdraw  
    
    new_line 
    
    ;Multiple of 500 or not Check
    mov dx,0
    mov ax,Current_withdraw  
    mov bx,500
    div bx
    cmp dx,0
    jne Give_mul_of_500_withdraw 
    
    ;Main WithDrawal Proccess   
    mov ax,Current_withdraw
    mov bx,BALANCE_ARRAY[di] ; Use di as the acc index
    sub bx,ax
    cmp bx,0
    jl Insuffient_money  
    
    mov BALANCE_ARRAY[di],bx ;; Use di as the acc index
    
    
    mov ah,9
    lea dx,WithDraw_Sucess_str
    int 21h 
    
    Five_Digit_out BALANCE_ARRAY[di] ; Use di as the acc index  
    
        ; Add to statement 
        
        mov ax, di ; Use di as the acc index
        mov bx,10
        mul bx
        mov si,ax     ;row at si 
        ;add si,6
        
        mov ax,Current_withdraw
        mov dx,Statement_Tag_ARRAY[si]
        mov Statement_Tag_ARRAY[si],'w'
        mov cx,Statement_Value_ARRAY[si]
        mov Statement_Value_ARRAY[si], ax
        
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx 
        mov bx, Statement_Tag_ARRAY[si] ;trst
        xchg Statement_Value_ARRAY[si],cx
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx
        xchg Statement_Value_ARRAY[si],cx   
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx 
        xchg Statement_Value_ARRAY[si],cx
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx
        xchg Statement_Value_ARRAY[si],cx
        
         
    
    jmp Exit_WithDraw
    
    
    Insuffient_money:
        mov ah,9
        lea dx, Insuffient_money_str 
        int 21h  
        jmp Exit_WithDraw
    
    Give_mul_of_500_withdraw:
        mov ah,9
        lea dx,Give_mul_of_500_str 
        int 21h 
    Exit_WithDraw: 
        new_line
        ret
endp WITHDRAW 


;Deposite PROC 
DEPOSITE proc    ;;use di as acc index
    mov Current_deposite, 0 
    
    mov ah,9
    lea dx, Deposite_str
    int 21h   
    
    Five_Digit_in Current_deposite  
    
    new_line
    
    ;Multiple of 500 or not Check
    mov dx,0
    mov ax,Current_deposite  
    mov bx,500
    div bx
    cmp dx,0
    jne Give_mul_of_500_deposite
    
    ;Main Deposite Proccess  
    mov ax,Current_deposite
    mov bx,BALANCE_ARRAY[di] ;use di as acc index
    add bx,ax 
    cmp bx,0
    jl Max_Limit_Exceeded
    
    mov BALANCE_ARRAY[di],bx   ;use di as acc index
    
    mov ah,9
    lea dx,Deposite_Sucess_str
    int 21h 
    
    Five_Digit_out BALANCE_ARRAY[di] ;;use di as acc index
    
    ;Add Statement
        mov ax, di ; Use di as the acc index
        mov bx,10
        mul bx
        mov si,ax     ;row at si 
        
        mov ax,Current_deposite
        mov dx,Statement_Tag_ARRAY[si]
        mov Statement_Tag_ARRAY[si],'d'
        mov cx,Statement_Value_ARRAY[si]
        mov Statement_Value_ARRAY[si], ax
        
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx 
        xchg Statement_Value_ARRAY[si],cx
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx
        xchg Statement_Value_ARRAY[si],cx   
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx 
        xchg Statement_Value_ARRAY[si],cx
        
        add si,2
        xchg Statement_Tag_ARRAY[si],dx
        xchg Statement_Value_ARRAY[si],cx
        
    
    jmp Exit_Deposite
    
    Max_Limit_Exceeded:
        mov ah,9
        lea dx, Max_Limit_Exceeded_str 
        int 21h  
        jmp Exit_Deposite
        
    
    Give_mul_of_500_deposite:
        mov ah,9
        lea dx,Give_mul_of_500_str 
        int 21h 
    Exit_Deposite: 
        new_line  
        ret
endp DEPOSITE 
  
;Statement
STATEMENT proc     ;use di as acc index
     mov ah,9
     lea dx,Statement_str
     int 21h
     new_line
     
     mov cx,5 
     
     mov ax, di ; Use di as the acc index
        mov bx,10
        mul bx
        mov si,ax     ;row at si 
        
     Main_Statement:   
     cmp Statement_Tag_ARRAY[si],0000
     je Statement_Exit 
     
     cmp Statement_Tag_ARRAY[si],'w'
     jne Deposite_Statement
     
     mov ah,9
     lea dx,Statement_Withdraw_str
     int 21h
     Five_Digit_out Statement_Value_ARRAY[si]
      
     add si,2
     new_line
     loop Main_Statement
     jmp Statement_Exit
     
     
     Deposite_Statement:
     mov ah,9
     lea dx,Statement_Deposite_str
     int 21h
     Five_Digit_out Statement_Value_ARRAY[si]  
     
     add si,2
     new_line
     loop Main_Statement
     
     
     Statement_Exit:
        cmp cx,5
        jne Statement_Main_exit
        
        mov ah,9
        lea dx,No_transaction_str
        int 21h
        new_line
        Statement_Main_exit:
        ret
endp STATEMENT
     
        
    END MAIN
