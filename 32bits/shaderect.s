	section	.data
	msg	db  'shadedrect.bmp',0x00

	section	.bss
bmpheadline:	resb	54
pixel_array:	resb	40000000	

section	.text
	global	shaderect	
shaderect:
	push	ebp
	mov	ebp, esp
	sub	esp, 20
	push	ebx
	push	esi
	push	edi

	mov	eax, [ebp+12]
	lea	eax, [eax+eax*2]
	mov 	ebx, eax
	add	ebx, 3
	mov	ecx, 3
	not	ecx
	and	ecx, ebx
	sub	ecx, eax 
	mov	[ebp-20], ecx

        mov  	ebx, 0                  
        mov   	esi, pixel_array            
loopy:
	mov	edi, [ebp+16]
	mov	ecx, [edi]
	push	ecx
	mov	ecx, [edi+8]
	push	ecx
	mov	ecx, [ebp+8]
	dec	ecx
	push	ecx
	push	ebx
	call	intpl
	pop	ebx
	pop	ecx
	pop	ecx
	pop	ecx
	mov	[ebp-12], eax

	mov	ecx, [edi+4]
	push	ecx
	mov	ecx, [edi+12]
	push	ecx
	mov	ecx, [ebp+8]
	dec	ecx
	push	ecx
	push	ebx
	call	intpl
	pop	ebx
	pop	ecx
	pop	ecx
	pop	ecx
	mov	[ebp-16], eax
	mov    	edi, 0
loopx:
	mov	ecx, [ebp-16]
	push	ecx
	mov	ecx, [ebp-12]
	push	ecx
	mov	ecx, [ebp+12]
	dec	ecx
	push	ecx
	push	edi
	call	intpl
	pop	edi
	pop	ecx
	pop	ecx
	pop	ecx

        mov   	[esi], eax

	add   	esi, 3
        inc    	edi
	cmp	edi, [ebp+12]
        jne    	loopx
	add	esi, [ebp-20]
endrow:
	inc	ebx
	cmp	ebx, [ebp+8]
        jne   	loopy

	mov	eax, bmpheadline
	mov	byte [eax], 'B'
	mov	byte [eax+1], 'M' 
	mov 	dword[eax+10], 54
	mov	dword[eax+14], 40
	mov	byte [eax+26], 1
	mov	byte [eax+28], 24 
	mov	ecx, [ebp+12]
	mov	[eax+18], ecx
	lea	ecx, [ecx+ecx*2]
	add	ecx, [ebp-20]
	mov	edx, [ebp+8]
	mov	[eax+22], edx
	imul	ecx, edx
	mov	[ebp-8], ecx
	mov	[eax+34], ecx
	add	ecx, 54
	mov	[eax+2], ecx
	
    	mov     eax, 5                           
    	mov     ebx, msg                                                        
    	mov     ecx, 1101o
	mov 	edx, 0666o         
    	int	0x80                               

    	mov     [ebp-4], eax

    	mov     eax, 4
    	mov     ebx, [ebp-4]
    	mov     ecx, bmpheadline
    	mov     edx, 54
    	int	0x80

    	mov     eax, 4
    	mov     ebx, [ebp-4]
    	mov     ecx, pixel_array
    	mov     edx, [ebp-8]
    	int	0x80     

    	mov     eax, 6   
    	mov     ebx, [ebp-4]     
    	int	0x80                            

	pop 	edi
	pop 	esi
	pop 	ebx
	mov	esp, ebp
	pop	ebp
	ret

	global	intpl
intpl:
	push	ebp
	mov	ebp, esp
	sub	esp, 4

	mov	eax, [ebp+8]
	mov	ecx, [ebp+12]
	mov	edx, 0
	shl	eax, 16
	div	ecx
	mov	edx, 0
	mov	dl, [ebp+20]
	imul	edx, eax
	shr	edx, 16
	mov	[ebp-4], dl
	mov	dl, [ebp+21]
	imul	edx, eax
	shr	edx, 16
	mov	[ebp-3], dl
	mov	dl, [ebp+22]
	imul	edx, eax
	shr	edx, 16
	mov	[ebp-2], dl
	mov	ecx, 1
	shl	ecx, 16
	sub	ecx, eax
	mov	dl, [ebp+16]
	imul	edx, ecx
	shr	edx, 16
	add	[ebp-4], dl
	mov	dl, [ebp+17]
	imul	edx, ecx
	shr	edx, 16
	add	[ebp-3], dl
	mov	dl, [ebp+18]
	imul	edx, ecx
	shr	edx, 16
	add	[ebp-2], dl
	mov	eax, [ebp-4]

	mov	esp, ebp
	pop	ebp
	ret
