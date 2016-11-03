; szybsze wczytywanie

segment .text

global read

read:
mov ecx, [esp+0x4]
push ebp
push ebx
mov ebp, esp
sub esp, 5 ;zarezerwowanie pamięci

dec ecx
czytaj:
inc ecx
movzx edx, byte [ecx]

; czytaj, póki nie trafisz na liczbę
cmp edx, 0x30
jl czytaj
cmp edx, 0x39
jg czytaj

; tu się zaczyna zabawa
mov dword [esp], 0
wpisuj:
; (x << 1) + (x << 3) + zn - '0'
mov eax, dword [esp]
mov ebx, eax
shl ebx, 3
shl eax, 1
add eax, ebx

add eax, edx
sub eax, 0x30

mov dword [esp], eax

czytaj_znow:
inc ecx
movzx edx, byte [ecx]

cmp edx, 0x30
jl wyjdz
cmp edx, 0x39
jg wyjdz
jmp wpisuj

wyjdz:
mov eax, [esp]
add esp, 5

pop ebx
pop ebp
ret

