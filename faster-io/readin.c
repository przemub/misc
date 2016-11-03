#include <stdio.h>
#include <stdlib.h>

#define BUFS 100000000
char buf[BUFS];
char* wsk = buf;

void load(char* buffer, unsigned count) {
	asm("mov $3, %%eax\n\t"
		"mov $0, %%ebx\n\t"
		"mov %0, %%ecx\n\t"
		"mov %1, %%edx\n\t"
		"int $0x80\n\t"
		"add %%eax, %%ecx\n\t"
		"movb $0, (%%ecx)"
		: 
		: "m" (buffer), "m" (count)
		: "memory", "eax", "ebx", "ecx", "edx"
	   );
}

int read() {
	int out = 0;

	asm("mov %1, %%ecx\n\t"
		"mov %2, %%esi\n\t"

		"dec %%ecx\n\t"
		"czytaj:\n\t"
		"inc %%ecx\n\t"
		"movzbl (%%ecx), %%edx\n\t"

		// czytaj, póki nie trafisz na liczbę
		"cmp $0, %%edx\n\t"
		"je wyjdz\n\t"
		"cmp $0x30, %%edx\n\t"
		"jl czytaj\n\t"
		"cmp $0x39, %%edx\n"
		"jg czytaj\n\t"

		//tu się zaczyna zabawa
		"mov $0, %%eax\n\t"
		"wpisuj:\n\t"
		//(x << 1) + (x << 3) + zn - '0'
		"mov %%eax, %%ebx\n\t"
		"shl $3, %%ebx\n\t"
		"shl $1, %%eax\n\t"
		"add %%ebx, %%eax\n\t"

		"add %%edx, %%eax\n\t"
		"sub $0x30, %%eax\n\t"

		"mov %%eax, %0\n\t"

		"czytaj_znow:\n\t"
		"inc %%ecx\n\t"
		"movzbl (%%ecx), %%edx\n\t"

		"cmp $0x30, %%edx\n\t"
		"jl wyjdz\n\t"
		"cmp $0x39, %%edx\n\t"
		"jg wyjdz\n\t"
		"jmp wpisuj\n\t"
		"wyjdz:\n\t"
		"mov %%ecx, %1"

		: "+r" (out), "+r" (wsk)
		: 
	    : "eax", "ebx", "ecx", "edx"
	);

	return out;
}

int main() {
	load(buf, BUFS);
	//printf("%s\n", buf);

	int val = 0;
	for (int i = 0; i < 5000000-1; i++) {
		int nval = read();
		val = nval;
	}
	printf("%d\n", val);

	return 0;
}

