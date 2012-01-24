.model small
.stack 100h
.data
map db 40 dup(40 dup(1))
    db 10 dup(40 dup(0))
	
.code
main proc
	mov ah,0
	mov al,4h
	int 10h
	mov ax,@data
	mov ds,ax

MAINLOOP:
	call shwMap
	jmp MAINLOOP

EXIT:	
	mov ah,4ch
	int 21h
main endp

pixalize proc
	mov al,8
	mul cx
	mov cx,ax

	mov al,4
	mul dx
	mov dx,ax
	ret
pixalize endp

depixalize proc
	mov ax,cx
	mov cx,8
	div cx
	mov cl,al

	mov ax,dx
	mov dx,4
	div dx
	mov dl,al
	
	ret
depixalize endp
shwMap proc
	
	mov dx,0
	LP1:
		mov cx,0
		mov bx,dx
		mov al,40
		mul bx
		mov bx,ax
		LP2:
			mov si,cx
			mov al,map[si][bx]
			cmp al,1
			je TILE	
			cmp al,2
			je BAR
			cmp al,3
			je BALL
			FIN:
			inc cx
			cmp cx,40
			jne LP2
	inc dx
	cmp dx,50
	jne LP1
	jmp EXIT
TILE:
	call pixalize
	call drwTile
	call depixalize
	jmp FIN
BAR:
	call pixalize
	call drwBar
	call depixalize
	jmp FIN
BALL:
	call pixalize
	call drwBall
	call depixalize
	jmp FIN

EXIT:	
	ret
	
shwMap endp	

drwTile proc
	mov ah,0ch
	mov bl,4
	mov al,2

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

	sub dx,4
	
	ret	
drwTile endp

drwBall proc
	mov ah,0ch
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

	sub cx,5
	sub cx,4
	ret
drwBall endp

drwBar proc
	mov ah,0ch
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

	sub cx,8
	
	ret	
drwBar endp
	
end main
	                                                                                                                                                                                                                                                                   