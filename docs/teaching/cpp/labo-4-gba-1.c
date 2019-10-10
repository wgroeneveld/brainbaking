#define SCREEN_WIDTH  240
#define SCREEN_HEIGHT 160

#define REG_DISPLAY (*((volatile uint16 *)0x04000000))
#define DISPLAY_MODE1 0x1000
#define DISPLAY_ENABLE_OBJECTS 0x0040

#define TILE_MEM ((volatile tile_block *)0x06000000)
#define PALETTE_MEM ((volatile palette *)(0x05000000 + 0x200))  // ignore bg mem
#define OAM_MEM ((volatile object *)0x07000000)

#define REG_VCOUNT (*(volatile uint16*) 0x04000006)

#define OAM_MEM  ((volatile object *)0x07000000)
#define Y_MASK 0x0FF
#define X_MASK 0x1FF

#define REG_KEY_INPUT (*((volatile uint16 *)0x04000130))
#define KEY_ANY  0x03FF
#define KEY_LEFT (1 << 5)
#define KEY_RIGHT (1 << 4)

#define VELOCITY 2

typedef unsigned short uint16;      // controle bits voor OAM, RGB
typedef unsigned int uint32;        // 1 tile bit in de GBA
typedef uint32 tile_4bpp[8];        // 8 rijen, elk 1 bit
typedef tile_4bpp tile_block[512];  // tile block = 8 screen blocks, 512 tiles 
typedef uint16 palette[16];         // 16 palettes beschikbaar

typedef struct object {
    uint16 attr0;
    uint16 attr1;
    uint16 attr2;
    uint16 unused;
} __attribute__((packed, aligned(4))) object;

void position(volatile object *obj, int x, int y) {
    obj->attr0 = (obj->attr0 &  ~Y_MASK) | (y & Y_MASK);
    obj->attr1 = (obj->attr1 & ~X_MASK) | (x & X_MASK);
}

void vsync() {
    while (REG_VCOUNT >= 160);
    while (REG_VCOUNT < 160);
}

uint16 get_color(uint16 r, uint16 g, uint16 b) {
    uint16 c = (b & 0x1f) << 10;
    c |= (g & 0x1f) << 5;
    c |= (r & 0x1f);
    return c;
}

volatile object* create_paddle() {
    // 1. kleur
    PALETTE_MEM[0][2] = get_color(31, 0, 0);

    // 2. tile - vanaf hieronder alles bezet tot TILE_MEM[4][6]!
    volatile uint16 *paddle_tile = (uint16*) TILE_MEM[4][2];  // begin vanaf 2
    // vul de tile met de palet index 2 - dit is per rij, vandaar 0x2222
    for(int i = 0; i < 4 * sizeof(tile_4bpp) / 2; i++) {
        paddle_tile[i] = 0x2222;
    }

    // 3. object
    volatile object *paddle_sprite = &OAM_MEM[1];
    paddle_sprite->attr0 = 0x4000; // 4bpp, wide
    paddle_sprite->attr1 = 0x4000; // 32x8 met wide shape
    paddle_sprite->attr2 = 2; // vanaf de 2de tile, palet 0

    return paddle_sprite;
}

volatile object* create_ball() {
    // 1. kleur
    PALETTE_MEM[0][1] = get_color(31, 31, 31); // wit - zie labo 3

    // 2. tile
    volatile uint16 *ball_tile = (uint16*) TILE_MEM[4][1];  // 1 block
    // vul de tile met de palet index 1 - dit is per rij, vandaar 0x1111
    for(int i = 0; i < sizeof(tile_4bpp) / 2; i++) {
        ball_tile[i] = 0x1111;
    }

    // 3. object
    volatile object *ball_sprite = &OAM_MEM[0];
    ball_sprite->attr0 = 0; // 4bpp, square
    ball_sprite->attr1 = 0; // grootte 8x8 met square
    ball_sprite->attr2 = 1; // eerste tile, palet 0

    return ball_sprite;    
}

void initScreen() {
    REG_DISPLAY = DISPLAY_MODE1 | DISPLAY_ENABLE_OBJECTS;
}

uint16 readKeys() {
    return ~REG_KEY_INPUT & KEY_ANY;
}

int main() {
    uint16 keys;
    volatile object* ball = create_ball();
    volatile object* paddle = create_paddle();

    int px = (SCREEN_WIDTH / 2) - (32 / 2);
    int py = SCREEN_HEIGHT - 10;
    position(ball, 50, 50);
    position(paddle, px, py);

    initScreen();

    while(1) {
        vsync();

        keys = readKeys();
        if(keys & KEY_LEFT) {
            px -= VELOCITY;
            if(px < 0) px = 0;
        }
        if(keys & KEY_RIGHT) {
            px += VELOCITY;
            if(px > (SCREEN_WIDTH - 32)) px = SCREEN_WIDTH - 32;
        }

        position(paddle, px, py);
    }
}