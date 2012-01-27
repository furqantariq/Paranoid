.model small
.stack 100h
.data
map	db 1 dup(32 dup(0))
	db 23 dup(32 dup(1))
	db 15 dup(32 dup(0))
	db 9 dup(32 dup(0))
	db 16 dup(0),3,15 dup(0)
	db 14 dup(0),2,2,2,2,2,13 dup(0)

barPos db 14
ballPosX dw 16
ballPosY dw 48
intro db "PARANOID"
credits db "BUILD BY FURQAN & HUSNAIN"
instruct db "PRESS SPACE TO CONTINUE"
WIN db "YOU WON"
OVER db "GAME OVER"
ball_dx dw 1
ball_dy dw -1
GAMEOVER_FLAG dw 0
WIN_FLAG dw 1	

.code
main proc

	mov ax,@data
	mov ds,ax

	call loadScreen
	
	mov ah,0
	mov al,4h
	int 10h
	
MAINLOOP:
	mov [WIN_FLAG],1
	call shwMap
	call mvBall
	
	cmp [GAMEOVER_FLAG],1
	je GAMEOVER
	
	cmp [WIN_FLAG],1
	je GAMEWON
	
	
	call detectBoundaries
	call detectCollision
	call getInput
	
	jmp MAINLOOP
		
	GAMEOVER:
		call gameover
	GAMEWON:
		call gamewon

main endp

gamewon proc
	mov ah,0
	mov al,4h
	int 10h
	
	mov si,offset WIN
	mov dl,17
again:	
	mov ah,2
	mov dh,12
	
	int 10h
	
	mov ah,9
	mov bl,2
	mov cx,1
	lodsb
	int 10h
	inc dl
	cmp dl,24
	jne again

	
	mov ah,4ch
	int 21h


gamewon endp

gameover proc
	mov ah,0
	mov al,4h
	int 10h
	
	mov si,offset OVER
	mov dl,15
again:	
	mov ah,2
	mov dh,12
	
	int 10h
	
	mov ah,9
	mov bl,2
	mov cx,1
	lodsb
	int 10h
	inc dl
	cmp dl,24
	jne again

	
	mov ah,4ch
	int 21h

gameover endp

detectCollision proc
	cmp [map+bx+si-32],1
	je UP
	
	C1:
	cmp [map+bx+si+32],1
	je BOTM
	C2:
	cmp [map+bx+si+1],1
	je RIGT
	C3:
	cmp [map+bx+si-1],1
	je LFT
	
	C4:
	cmp [map+bx+si+33],1
	je BRT	
	C5:
	cmp [map+bx+si+31],1
	je BLT
	C6:
	cmp [map+bx+si-33],1
	je ULT
	C7:
	cmp [map+bx+si-31],1
	je URT
	C8:
		ret
URT:
	mov [map+bx+si-31],0
	NEG [ball_dx]
	NEG [ball_dy]
	jmp C8
ULT:
	mov [map+bx+si-33],0
	NEG [ball_dx]
	NEG [ball_dy]
	jmp C8
BLT:
	mov [map+bx+si+31],0
	NEG [ball_dx]
	NEG [ball_dy]
	jmp C8
		
BRT:
	mov [map+bx+si+33],0
	NEG [ball_dx]
	NEG [ball_dy]
	jmp C8
		
LFT:
	mov [map+bx+si-1],0
	NEG [ball_dx]
	jmp C8

RIGT:
	mov [map+bx+si+1],0
	NEG [ball_dx]
	jmp C8
BOTM:
	mov [map+bx+si-32],0
	NEG [ball_dy]
	jmp C8
UP:
	mov [map+bx+si-32],0
	NEG [ball_dy]
	jmp C8
	
	ret
detectCollision endp

loadScreen proc
		mov ah,0
	mov al,4h
	int 10h
	
	mov si,offset intro
	mov dl,15
again:	
	mov ah,2
	mov dh,10
	
	int 10h
	
	mov ah,9
	mov bl,2
	mov cx,1
	lodsb
	int 10h
	inc dl
	cmp dl,23
	jne again
	
	mov si,offset credits
	mov dl,7

again2:	
	mov ah,2
	mov dh,12
	
	int 10h
	
	mov ah,9
	mov bl,2
	mov cx,1
	lodsb
	int 10h
	inc dl
	cmp dl,32
	jne again2
	
	mov si,offset instruct
	mov dl,8
again3:	
	mov ah,2
	mov dh,24
	
	int 10h
	
	mov ah,9
	mov bl,2
	mov cx,1
	lodsb
	int 10h
	inc dl
	cmp dl,31
	jne again3	

again4:	
	mov ah,0
	int 16h
	cmp ah,39h
	jne again4
	
	ret
loadScreen endp	
	
	
getInput proc	
	mov ah,1		
	
	int 16h
	jz RETURN
	
	
	mov ah,0
	int 16h
	
	cmp ah,1h
	je EXIT
	cmp ah,4dh
	je barRight
	cmp ah,4bh
	je barLeft
	jmp RETURN
	
barRight:
	cmp [barPos],27
	jge RETURN

	mov bx,offset barPos
	mov bx,[bx]
	mov bh,0
	mov [map+32*49+bx],bh
	mov [map+32*49+bx+5],2
	inc [barPos]

	jmp RETURN	

barLEFT:	
	cmp [barPos],0
	jle RETURN

	mov bx,offset barPos
	mov bx,[bx]
	mov bh,0
	mov [map+32*49+bx-1],2
	mov [map+32*49+bx+4],0
	dec [barPos]
	
	jmp RETURN	

RETURN:
	mov ah,0ch
	int 21h
	
	ret
	
EXIT:	
	mov ah,4ch
	int 21h
getInput endp

mvBall proc
	mov bx,offset ballPosX
	mov si,offset ballPosY
	mov bx,[bx]
	mov si,[si]
	xor ax,ax
	mov al,32
	mul si
	mov si,ax
	mov [map+bx+si],0

	mov di,offset ball_dx
	mov ax,[di]
	add [ballPosX],ax
	cmp [ballPosX],ax
	mov di,offset ball_dy
	mov ax,[di]
	add [ballPosY],ax
	cmp [ballPosY],ax
	
	mov bx,offset ballPosX
	mov si,offset ballPosY
	mov bx,[bx]
	mov si,[si]
	xor ax,ax
	mov al,32
	mul si
	mov si,ax
	mov [map+bx+si],3

	ret
	
mvBall endp

detectBoundaries proc
	cmp [ballPosX],31
	je NEGX
	cmp [ballPosX],0
	je NEGX
C2:	cmp [ballPosY],0
	je NEGY

	cmp [ballPosY],48
	je BOTTOM
E:	
	ret

NEGX:	
	NEG [ball_dx]
	jmp C2

NEGY:	
	NEG [ball_dy]
	jmp E

BOTTOM:
	cmp [map+bx+si+32],2
	je NEGY
	
	cmp [ball_dx],1
	je N33
	jne N32
	N33: 
		cmp [map+bx+si+33],2	
		je NEGB
	N32:
		cmp [map+bx+si+31],2
		je NEGB
		
	
	mov GAMEOVER_FLAG,1
	jmp E
	
NEGB:
	NEG [ball_dy]
	NEG [ball_dx]
	jmp E
	

detectBoundaries endp	


	
pixalize proc
	mov al,8
	mul si
	mov cx,ax

	mov al,4
	mul di
	mov dx,ax
	ret
pixalize endp


shwMap proc
	
	mov di,0
	LP1:
		mov si,0
		LP2:
			mov bx,di
			mov ax,32
			mul bx
			mov bx,ax
			mov ah,0
			mov al,map[si][bx]
			cmp al,0
			je BLANK
			cmp al,1
			je TILE	
			cmp al,2
			je BAR
			cmp al,3
			je BALL
			FIN:
			inc si
			cmp si,32
			jne LP2
		inc di
		cmp di,50
		jne LP1
		jmp EXIT
	
TILE:
	mov [WIN_FLAG],0
	call pixalize
	call drwTile

	jmp FIN
BAR:
	call pixalize
	call drwBar

	jmp FIN
BALL:
	call pixalize
	call drwBall

	jmp FIN

BLANK:
	call pixalize
	call drwBlank

	jmp FIN

EXIT:	
	ret
	
shwMap endp	

drwTile proc
	mov ah,0ch
	mov bl,3
	mov al,3
	inc cx
	inc dx

LP1:
	mov bh,7
	LP2:	
		int 10h
		inc cx
		dec bh
		jnz LP2
	inc dx
	sub cx,7
	dec bl
	jnz LP1

	ret	
drwTile endp

drwBlank proc
	mov ah,0ch
	mov bl,4
	mov al,0

LP1:
	mov bh,8
	LP2:	
		int 10h
		inc cx
		dec bh
		jnz LP2
	inc dx
	sub cx,8
	dec bl
	jnz LP1

	ret	
drwBlank endp

drwBall proc
	mov ah,0ch
	mov al,2
	add cx,2
	mov bl,4
	LP1:
		int 10h
		inc cx
		dec bl
		jnz LP1
	inc dx
	int 10h
	mov bl,5
	LP2:
		dec cx
		int 10h
		dec bl
		jnz LP2
	inc dx
	mov bl,6
	LP3:
		int 10h
		inc cx
		dec bl
		jnz LP3
	sub cx,5
	inc dx
	mov bl,4
	LP4:
		int 10h
		inc cx
		dec bl
		jnz LP4

	
	ret
drwBall endp

drwBar proc
	mov ah,0ch
	mov al,1
	mov bl,2								

LP1:
	mov bh,8
	LP2:	
		int 10h
		inc cx
		dec bh
		jnz LP2
	inc dx
	sub cx,8
	dec bl
	jnz LP1

	ret	
drwBar endp
	
end main
	                                                                                                                                                                                                                                                                   
