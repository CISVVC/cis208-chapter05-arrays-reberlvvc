; auth: Logan Reber
; file: asm_main.asm
; date: 11/16/17
; 

%include "asm_io.inc"

%define ARL1 5			;Array Length Definitions
%define	ARL2 7			;
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h
	
	scale1 dd 5		;declaring scalars
	scale2 dd 4		;

; uninitialized data is put in the .bss segment
;
segment .bss
	arr1 	resw ARL1 	;declaring arrays
	arr2	resw ARL2 	;
;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0             ; setup routine
        pusha
; *********** Start  Assignment Code *******************
	mov	ecx, ARL1	;Set ECX to Array Size
	mov	ebx, arr1	;Set EBX to Array Address
fill_loop1:
	mov	[ebx], cx	;Set current element to CX
	add	ebx, 2		;Move to next element in Array
	loop	fill_loop1	;

	mov	ecx, ARL2	;Set ECX to Array Size
	mov	ebx, arr2	;Set EBX to Array Address
fill_loop2:
	mov	[ebx], cx	;Set current element to CX
	add	ebx, 2		;Move to next element in Array
	loop	fill_loop2	;

	mov	ebx, arr1	;EAX = Array Address
	mov	ecx, ARL1	;EBX = Array Size
	mov	edx, [scale1]	;ECX = Scalar
	push	edx
	push	ecx		;push parameters to the stack
	push	ebx
	call	array_scale	;Scales the array
	add	esp, 12		;pop useless data off the stack
	
	mov	ebx, arr2	;EAX = Array Address
	mov	ecx, ARL2	;EBX = Array Size
	mov	edx, [scale2]	;ECX = Scalar
	push	edx
	push	ecx		;push parameters to the stack
	push	ebx
	call	array_scale	;Scales the array
	add	esp, 12		;pop useless data off the stack

	xor	eax, eax	;Empty EAX
	mov	ecx, ARL1	;use Array length for loops
	mov	ebx, arr1	;EBX = Array Address
show_loop1:
	mov	ax,[ebx]	;put current element in AX
	call	print_int	;output
	call	print_nl	
	add	ebx, 2		;next element
	loop	show_loop1
	
	call	print_nl

	xor	eax, eax	;Empty EAX
	mov	ecx, ARL2	;use array length for loops
	mov	ebx, arr2	;EBX = Array Address
show_loop2:
	mov	ax,[ebx]	;put current element in AX
	call	print_int	;output
	call	print_nl
	add	ebx, 2		;next element
	loop	show_loop2
; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret

array_scale:
;----------------------------------
;Parameters:
;	Array pointer 	@ EBP +  8
;	Array size	@ EBP + 12
;	Array scalar	@ EBP + 16
;----------------------------------
	push	ebp
	mov	ebp, esp
	pusha
	
	xor	eax, eax	;Empty EAX
	mov	ebx, [ebp+8]	;Array Address
	mov	ecx, [ebp+12]	;Array Size
	mov	edx, [ebp+16]	;Scalar
for_length:
	mov	ax,[ebx]	;Put current element in AX
	imul	ax,dx		;Multiply AX by DX(Scalar)
	mov	[ebx], ax	;Move product into array
	add	ebx, 2		;Next Element
	loop 	for_length	

	popa
	pop	ebp
	ret
