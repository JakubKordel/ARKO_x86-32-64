section	.text
	global	shaderect	
shaderect:
	push	ebp
	mov	ebp, esp
	sub	esp, 68
	push	ebx
	push	esi
	push	edi

	mov	eax, [ebp+16]
	lea	eax, [eax+eax*2]
	mov 	ebx, eax
	add	ebx, 3
	mov	ecx, 3
	not	ecx
	and	ecx, ebx
	sub	ecx, eax 
	mov	[ebp-68], ecx

	mov	esi, [ebp+20]
	mov	ecx, [ebp+12]
	mov	[ebp-4], ecx
	dec	ecx

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi]
	mov	bl, [esi+8]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-16], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-40], eax

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi+1]
	mov	bl, [esi+9]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-12], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-36], eax

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi+2]
	mov	bl, [esi+10]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-8 ], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-32], eax

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi+4]
	mov	bl, [esi+12]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-28], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-52], eax

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi+5]
	mov	bl, [esi+13]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-24], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-48], eax

	mov	eax, 0
	mov	ebx, 0
	mov	al, [esi+6]
	mov	bl, [esi+14]
	sub	eax, ebx
	cdq
	shl	ebx, 16
	mov	[ebp-20], ebx
	shl	eax, 16
	idiv	ecx
	mov	[ebp-44], eax

	mov	esi, [ebp+8]
loopy:	
	mov	ecx, [ebp+16]
	dec	ecx

	mov	eax, [ebp-28]
	mov	ebx, [ebp-16]
	sub	eax, ebx
	cdq
	idiv	ecx
	mov	[ebp-64], eax

	mov	eax, [ebp-24]
	mov	ebx, [ebp-12]
	sub	eax, ebx
	cdq
	idiv	ecx
	mov	[ebp-60], eax

	mov	eax, [ebp-20]
	mov	ebx, [ebp-8]
	sub	eax, ebx
	cdq
	idiv	ecx
	mov	[ebp-56], eax

	mov     edi, [ebp+16]
	mov	eax, [ebp-8]
	mov	ebx, [ebp-12]
	mov	ecx, [ebp-16]
loopx:
	mov	edx, ecx
	shr	edx, 16
        mov   	[esi], dl
	mov 	edx, ebx
	shr	edx, 16
	mov	[esi+1], dl
	mov	edx, eax
	shr	edx, 16
	mov	[esi+2], dl
	add   	esi, 3
        add	ecx, [ebp-64]
	add	ebx, [ebp-60]
	add	eax, [ebp-56]
	dec	edi
        jnz    	loopx

	add	esi, [ebp-68]

	mov	eax, [ebp-40]
	add	[ebp-16], eax
	mov	eax, [ebp-36]
	add	[ebp-12], eax
	mov	eax, [ebp-32]
	add	[ebp-8], eax
	mov	eax, [ebp-52]
	add	[ebp-28], eax
	mov	eax, [ebp-48]
	add	[ebp-24], eax
	mov	eax, [ebp-44]
	add	[ebp-20], eax

	dec	dword [ebp-4]
        jnz   	loopy                        

	pop 	edi
	pop 	esi
	pop 	ebx
	mov	esp, ebp
	pop	ebp
	ret
