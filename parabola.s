	; rsi - szerokość
	; rdx - wysokość

	; xmm0 - alpha
	; xmm1 - K_parameter
	; xmm2 - Kprim_parameter
	; xmm3 - V_start
	; xmm4 - przyciaganie
	; xmm5 - Vy
        ; xmm6 - Vx
	; r12 - y poprzednie
	; r13 - x poprzednie

section .text
	global parabola

parabola:
	push rbp
	mov rbp, rsp
	
					; skopiowanie wysokosci i szerokości
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



	;przesuniecie do wiersza
	cvtsd2si r10, xmm5 		; konwersja Vy
	mov r12, r10
	mov r15, rdi  			; r15 - poczatek bitmapy ( lewy górny )
	sub r8, r10 			; r8 = 600 - Vy ( bo odwrotny uklad wspol)
	shl r8, 3   			; razy 8 z racji 64 r8=r8*3
	add r15,r8 			; przesuniesie do wiersza 
	

	;przesuniecie sie do kolumny
	cvtsd2si r11, xmm6 		; konwersja Vx
	mov r13, r11
	mov rbx, [r15] 			; rbx = aktuaalne miejsce w bitmapie
	add rbx, r11   			; przesuwam sie po X rbx=rbx+Vx
	mov al, 255			; rysowanie
	mov [rbx], al

loop:
	mov r8, rsi
	mov r9, rdx	

	movsd xmm7, xmm5			;xmm7 = Vy_(n-1)
	mulsd xmm7, xmm7			;xmm7 = (Vy_(n-1))^2
	mulsd xmm7, xmm2			;xmm7 = (Vy_(n-1))^2 * K'
	subsd xmm7, xmm4			;xmm7 = K'*(Vy_(n-1))^2 - przyciaganie
        addsd xmm5, xmm7			;xmm5 = Vy_(n-1) - K'*(Vy_(n-1))^2 - przyciaganie

	
	
	cvtsd2si r10, xmm5 			; konwersja Vy
	add r10, r12				; nowy y = Vy + poprzedni y
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
	add r11, r13			; nowy x = Vx + poprzedni x
	mov r13, r11
	
	

	mov rbx, [r15] 			; rbx = aktuaalne miejsce w bitmapie
	add rbx, r11   			; przesuwam sie po X rbx=rbx+Vx
	mov al, 255			; rysowanie
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


