/*
> Web Development With Assembly
> You might as well just kill yourself now

GAS, x86 32-bit, Linux. 29 II 2016 AD.
*/

.text

.global _start

_start:
movl    $hello, %eax
movl    $len, %ebx
call    printa

# Wczytywanie strony
movl 	$5, %eax 	# open
movl 	$index, %ebx
movl 	$0, %ecx
movl    $0777, %edx
int 	$0x80

movl    %eax, %ebx
movl    $3, %eax 	# read
movl    $DANE, %ecx
movl 	$ROZMIAR, %edx
int     $0x80

lea     DROZMIAR, %ebx
movl    %eax, (%ebx)

# Tworzymy gniazdo
movl    $102, %eax  # socketcall
movl    $1, %ebx    # socket
push    $0
push    $1
push    $2
movl    %esp, %ecx
int     $0x80
movl	%eax, %edx
movl	%eax, %esi

# Łączenie pod port
movl    $102, %eax
movl    $2, %ebx    # bind
pushl   $0
pushw   $0x672b
pushw   $2
movl    %esp, %ecx
pushl   $16
pushl   %ecx
pushl   %edx
movl    %esp, %ecx
int     $0x80

# Nasłuchiwanie
movl    $102, %eax
movl    $4, %ebx    # listen
pushl   $0
pushl   %esi
mov     %esp, %ecx
int     $0x80

nasluch:
movl    $102, %eax
movl    $5, %ebx    # accept
pushl   $0
pushl   $0
pushl   %esi
movl    %esp, %ecx
int     $0x80
movl 	%eax, %edi

movl    $odebrano, %eax
movl    $lenodebrano, %ebx
call    printa

# Wiadomość

movl    %edi, %ebx
movl    $4, %eax    # write
movl    $DANE, %ecx
movl    (DROZMIAR), %edx
int     $0x80

# Zamknięcie połączenia

movl    $6, %eax
movl    %ebx, %ebx
int     $0x80
jmp		nasluch

# Wyjście

movl    $1, %eax    # exit
movl    $0, %ebx
int     $0x80

printa:
movl    %eax, %ecx
movl    %ebx, %edx
movl    $4, %eax    # write
movl    $1, %ebx    # stdout
int     $0x80
ret

.bss

.equ ROZMIAR, 4096
.lcomm DANE, ROZMIAR
.lcomm DROZMIAR, 4

.data

	.long 0

hello:
	.ascii  "Serwer startuje!\n"
	len = . - hello

odebrano:
	.ascii  "Odebrano połączenie.\n"
	lenodebrano = . - odebrano

web:
	.ascii  "Witaj swiecie!\n"
	lenweb = . - web

index:
	.ascii  "index.html"

