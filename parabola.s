	; rsi - width
	; rdx - height

	; xmm0 - alpha
	; xmm1 - K_parameter
	; xmm2 - Kprim_parameter
	; xmm3 - V_start
	; xmm4 - gravity
	; xmm5 - Vy
        ; xmm6 - Vx
	; r12 - previous y 
	; r13 - previous x 

section .text
	global parabola

parabola:
	push rbp
	mov rbp, rsp
	
					; width and height copied
	mov r8, rsi
	mov r9, rdx
	

					; Vy
	movsd [rsp - 64], xmm0
	fld qword [rsp - 64]
	fsin
	fstp qword [rsp- 64]
	movsd xmm5, [rsp - 64]

	mulsd xmm5, xmm3

					; Vx
	movsd [rsp - 64], xmm0
	fld qword [rsp - 64]
	fcos
	fstp qword [rsp- 64]
	movsd xmm6, [rsp - 64]

	mulsd xmm6, xmm3



	;move to proper line
	cvtsd2si r10, xmm5 		; Vy conversion
	mov r12, r10
	mov r15, rdi  			; r15 - beginning of bitmap  ( left top )
	sub r8, r10 			; r8 = 600 - Vy ( reverse coordinate system )
	shl r8, 3   			; multiplied by 8 because 64 r8=r8*3
	add r15,r8 			; Shift to line
	

	;move to proper column
	cvtsd2si r11, xmm6 		; Vx conversion
	mov r13, r11
	mov rbx, [r15] 			; rbx = actual place in the bitmap
	add rbx, r11   			; moving - X rbx=rbx+Vx
	mov al, 255			; drawing
	mov [rbx], al

loop:
	mov r8, rsi
	mov r9, rdx	

	movsd xmm7, xmm5			;xmm7 = Vy_(n-1)
	mulsd xmm7, xmm7			;xmm7 = (Vy_(n-1))^2
	mulsd xmm7, xmm2			;xmm7 = (Vy_(n-1))^2 * K'
	subsd xmm7, xmm4			;xmm7 = K'*(Vy_(n-1))^2 - gravity
        addsd xmm5, xmm7			;xmm5 = Vy_(n-1) - K'*(Vy_(n-1))^2 - gravity

	
	
	cvtsd2si r10, xmm5 			;  Vy conversion
	add r10, r12				;  new_y = Vy + previous_y
	mov r12, r10			

	cmp r10, 0				; if(Vy<0) -> end
	jl end
	cmp r10,rsi
	jg end
	

	mov r15, rdi 				
	sub r8, r10 			
	shl r8, 3   			
	add r15,r8 


	movsd xmm8, xmm6			;xmm8 = Vx_(n-1)
	mulsd xmm8, xmm8			;xmm8 = (Vx_(n-1))^2
	mulsd xmm8, xmm1			;xmm8 = (Vx_(n-1))^2 * K
	subsd xmm6, xmm8			;xmm6 = = Vx_(n-1) - K*(Vx_(n-1))^2

	cvtsd2si r11, xmm6
	add r11, r13			; new_x = Vx + previous_x
	mov r13, r11
	
	

	mov rbx, [r15] 			; rbx = actual place in the bitmap
	add rbx, r11   			; moving - X rbx=rbx+Vx
	mov al, 255			; drawing
	mov [rbx], al	

	cmp r11,0
	jl end
	cmp r11,rsi
	jg end
	
		
	jmp loop

	

end:	
	mov rsp, rbp	
	pop rbp
	ret


