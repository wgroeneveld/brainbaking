#define MODE3 0x0003
#define BG2 0x0400

#define WIDTH 240
#define HEIGHT 160

volatile unsigned int *display_control = (volatile unsigned int*) 0x4000000;
volatile unsigned short *vram = (volatile unsigned short*) 0x6000000;

unsigned short get_color(unsigned char r, unsigned char g, unsigned char b) {
    unsigned short c = (b & 0x1f) << 10;
    c |= (g & 0x1f) << 5;
    c |= (r & 0x1f);
    return c;
}

void set_pixel(int x, int y, unsigned short color) {
    vram[y*WIDTH + x] = color;
}

int main() {
    *display_control = MODE3 | BG2;
    unsigned short color = get_color(0, 0, 10);

    for(int x = 0; x < WIDTH; x++) {
    	for(int y = 0; y < HEIGHT; y++) {
    		set_pixel(x, y, color);
    	}
    }

	while(1);
}
