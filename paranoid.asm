.model small
.stack 100h
.data
map	db 1 dup(32 dup(0))
	db 23 dup(32 dup(1))
	db 15 dup(32 dup(0))
	db 16 dup(0),3,15 dup(0)
	db 9 dup(32 dup(0))
	db 14 dup(0),2,2,2,2,2,13 dup(0)

barPos db 15	
	
.code
main proc
	mov ah,0
	mov al,4h
	int 10h

	mov ah,0bh
	mov bh,1
	mov bl,0
	int 10h

	mov ax,@data
	mov ds,ax
	
	

MAINLOOP:
	call shwMap

	mov ah,0
	int 16h
	cmp ah,39h
	je EXIT
	cmp ah,4dh
	je barRight
	cmp ah,4bh
	je barLeft
	
	jmp MAINLOOP

barRight:
	cmp [barPos],28
	je MAINLOOP

	xor ax,ax
	mov al,32
	mov bx,38
	mul bx
	mov bx,ax
	mov bx,offset barPos
	mov si,[bx]
	mov [map+32*39+si],0
	mov [map+32*39+si+5],2
	inc [barPos]
	
	jmp MAINLOOP	

barLEFT:	

jmp MAINLOOP
	
EXIT:	
	mov ah,4ch
	int 21h
main endp

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

EXIT:	
	ret
	
shwMap endp	

drwTile proc
	mov ah,0ch
	mov bl,2
	mov al,3
	inc cx
	inc dx

LP1:
	mov bh,6
	LP2:	
		int 10h
		inc cx
		dec bh
		jnz LP2
	inc dx
	sub cx,6
	dec bl
	jnz LP1

	ret	
drwTile endp

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
	                                                                                                                                                                                                                                                                   