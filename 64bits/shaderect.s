	section	.data
	msg	db  'shadedrect.bmp',0x00

	section	.bss
bmpheadline:	resb	54
pixel_array:	resb	40000000	
	
	section	.text
	global	shaderect	
shaderect:
	push	rbp
	mov	rbp, rsp
	push	rbx
	push	r12
	push	r13
	push	r14
	push	r15

	lea	eax, [esi+esi*2]
	mov 	ebx, eax
	add	ebx, 3
	mov	ecx, 11b
	not	ecx
	and	ecx, ebx
	sub	ecx, eax 
	mov	r12d, ecx

        mov  	r14d, 0                
        mov   	r13, pixel_array            
loopy:
	mov	r15, rdx
	push	rdi
	push	rsi
	push	rdx
	mov	ecx, [r15]
	mov	edx, [r15+8]
	mov	esi, edi
	dec	esi
	mov	edi, r14d
	call	intpl
	pop	rdx
	pop	rsi
	pop	rdi
	mov	r8d, eax

	push	rdi
	push	rsi
	push	rdx
	push	r8
	mov	ecx, [r15+4]
	mov	edx, [r15+12]
	mov	esi, edi
	dec	esi
	mov	edi, r14d
	call	intpl
	pop	r8
	pop	rdx
	pop	rsi
	pop	rdi
	
	mov	r9d, eax
	mov    	r15d, 0
loopx:
	push	rdi
	push	rsi
	push	rdx
	push	r9
	push	r8
	mov	ecx, r9d
	mov	edx, r8d
	dec	esi
	mov	edi, r15d
	call	intpl
	pop	r8
	pop	r9
	pop	rdx
	pop	rsi
	pop	rdi

        mov   	[r13], eax 

	add   	r13, 3
        inc    	r15d
	cmp	r15d, esi
       	jne    	loopx
	add	r13, r12
	
endrow:
	inc	r14d
	cmp	r14d, edi
        jne   	loopy
	mov	eax, bmpheadline
	mov	byte [eax], 'B'
	mov	byte [eax+1], 'M' 
	mov 	dword[eax+10], 54
	mov	dword[eax+14], 40
	mov	byte [eax+26], 1
	mov	byte [eax+28], 24 
	mov	[eax+18], esi
	lea	ecx, [esi+esi*2]
	add	ecx, r12d
	mov	edx, edi
	mov	[eax+22], edx
	imul	ecx, edx
	mov	r14d, ecx
	mov	[eax+34], ecx
	add	ecx, 54
	mov	[eax+2], ecx
	

	mov     rax,85 
    	mov     rdi,msg                          
                                              
    	mov     rsi,111111111b                    
    	syscall                                    

    	mov     r8, rax

    	mov     rax, 1                         
    	mov     rdi, r8                     
    	mov     rsi, bmpheadline        
    	mov     rdx, 54  
   	syscall                        

    	mov     rax, 1           
    	mov     rdi, r8                     
    	mov     rsi, pixel_array                
    	mov     rdx, r14           
    	syscall                    


    	mov     rax, 3               
    	mov     rdi, r8                   
   	syscall  
	           
	pop	r15
	pop	r14
	pop	r13                                                          
	pop	r12
	pop 	rbx
	mov	rsp, rbp
	pop	rbp
	ret

	global	intpl
intpl:
	mov	r8d, ecx
	mov	r9d, edx
	mov	eax, edi
	mov	ecx, esi
	mov	edx, 0
	mov	r10, 0
	shl	eax, 16
	div	ecx
	mov	edx, 0
	mov	dl, r8b
	imul	edx, eax
	shr	edx, 16
	or	r10d, edx
	shr	r8d, 8
	mov	dl, r8b
	imul	edx, eax
	shr	edx, 16
	shl	edx, 8
	or	r10d, edx
	shr	r8d, 8
	mov	edx, 0
	mov	dl, r8b
	imul	edx, eax
	shr	edx, 16
	shl	edx, 16
	or	r10d, edx
	mov	ecx, 1
	shl	ecx, 16
	sub	ecx, eax
	mov	edx, 0
	mov	dl, r9b
	imul	edx, ecx
	shr	edx, 16
	add	r10d, edx
	shr	r9d, 8
	mov	dl, r9b
	imul	edx, ecx
	shr	edx, 16
	shl	edx, 8
	add	r10d, edx
	shr	r9d, 8
	mov	edx, 0
	mov	dl, r9b
	imul	edx, ecx
	shr	edx, 16
	shl	edx, 16
	add	r10d, edx
	mov	eax, r10d
	ret
