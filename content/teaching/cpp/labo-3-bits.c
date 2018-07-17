
#include <limits.h>
#include <stdio.h>

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef uint32 tile_4bpp[8];

// tip: https://www.binaryhexconverter.com/hex-to-binary-converter
#define Y_MASK 0x0FF
#define X_MASK 0x1FF
#define KEY_RIGHT (1 << 4)

void print_sizes() {
	printf("hoeveel bits zit er in ene byte hier? %d\n", CHAR_BIT);
	printf("sizeof BYTES unsigned short %d - unsigned int BYTES: %d\n", sizeof(uint16), sizeof(uint32));
	printf("sizeof BITS unsigned short %d - unsigned int BITS: %d\n", sizeof(uint16) * CHAR_BIT, sizeof(uint32) * CHAR_BIT);
	printf("sizeof arr8 uint32: %d\n", sizeof(tile_4bpp));	
}

void print_bits(int size, void* ptr) {
    uint8 *b = (uint8*) ptr;
    uint8 byte;
    int i, j;

    for (i = size-1; i >= 0; i--) {
        for (j = CHAR_BIT - 1; j >= 0; j--) {
            byte = (b[i] >> j) & 1;
            printf("%u", byte);

            if(j == 4) printf(" ");
        }
        printf(" ");
    }
    printf("\n");
}

int main() {
	uint16 nr;		// kijk wat er gebeurt als dit als uint8 gedefiniëerd is! 
	print_sizes();
	printf("\n");

	nr = KEY_RIGHT;
	printf("key right (1 << 4): \t\t");
	print_bits(sizeof(nr), &nr);

	nr = nr << 1;
	printf("key right na nog 1 bitshift: \t");
	print_bits(sizeof(nr), &nr);

	// tip: https://en.wikipedia.org/wiki/Bitwise_operations_in_C
	nr = nr | KEY_RIGHT;
	printf("opgeteld met bitwise OR |: \t");
	print_bits(sizeof(nr), &nr);

	nr = ~nr;
	printf("inverse met bitwise ~: \t\t");
	print_bits(sizeof(nr), &nr);

	printf("\n");

	nr = X_MASK;
	printf("x mask: \t\t\t");
	print_bits(sizeof(nr), &nr);
	nr = Y_MASK;
	printf("y mask: \t\t\t");
	print_bits(sizeof(nr), &nr);

	return 0;
}
