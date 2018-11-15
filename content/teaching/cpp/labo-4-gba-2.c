#include <stdlib.h>

#define SCREEN_WIDTH  240
#define SCREEN_HEIGHT 160

#define REG_DISPLAY (*((volatile uint16 *)0x04000000))
#define DISPLAY_MODE1 0x1000
#define DISPLAY_ENABLE_OBJECTS 0x0040

#define TILE_MEM ((volatile tile_block *)0x06000000)
#define TILE_MEM_FG 4
#define TILE_MEM_BG 1
#define PALETTE_MEM ((volatile palette *)(0x05000000 + 0x200))  // ignore bg mem
#define PALETTE_MEM_BG ((volatile palette *)(0x05000000))
#define PALETTE_SIZE 256

#define OAM_MEM ((volatile object *)0x07000000)
#define OAM_HIDE_MASK 0x300         // 0000 0000 0011 0000 0000
#define OAM_HIDE 0x200              // 0000 0000 0010 0000 0000
#define OAM_Y_MASK 0x0FF
#define OAM_X_MASK 0x1FF

#define REG_VCOUNT (*(volatile uint16*) 0x04000006)

#define REG_KEY_INPUT (*((volatile uint16 *)0x04000130))
#define KEY_ANY  0x03FF
#define KEY_LEFT (1 << 5)
#define KEY_RIGHT (1 << 4)

#define VELOCITY 2

typedef unsigned char uint8;
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

// vergeet niet dat deze eigenschappen redundant zijn en geheugen innemen voor niets...
// het is echter een pak eenvoudiger om mee te werken dan OAM bitshifting
typedef struct sprite {
    int x;  // position
    int y;
    int dx; // velocity
    int dy;
    uint8 w;  // dimensions (simple hitbox detection)
    uint8 h;
    volatile object *obj;
} sprite;

void position(sprite *s) {
    volatile object *obj = s->obj;
    int x = s->x;
    int y = s->y;
    obj->attr0 = (obj->attr0 &  ~OAM_Y_MASK) | (y & OAM_Y_MASK);
    obj->attr1 = (obj->attr1 & ~OAM_X_MASK) | (x & OAM_X_MASK);
}

void vsync() {
    while (REG_VCOUNT >= 160);
    while (REG_VCOUNT < 160);
}

uint16 color(uint16 r, uint16 g, uint16 b) {
    uint16 c = (b & 0x1f) << 10;
    c |= (g & 0x1f) << 5;
    c |= (r & 0x1f);
    return c;
}

int next_oam_mem;
int next_tile_mem = 1;

int is_hidden(sprite *s) {
    volatile object *obj = s->obj;
    return obj->attr0 & OAM_HIDE;
}

void hide(sprite *s) {
    volatile object *obj = s->obj;
    obj->attr0 = (obj->attr0 & ~OAM_HIDE_MASK) | OAM_HIDE;
}

volatile object* create_object(int attr0, int attr1, int attr2) {
    volatile object *obj = &OAM_MEM[next_oam_mem++];
    obj->attr0 = attr0;
    obj->attr1 = attr1;
    obj->attr2 = attr2;

    return obj;    
}

volatile object* copy_object(volatile object* other) {
    return create_object(other->attr0, other->attr1, other->attr2);
}

sprite* create_sprite(volatile object* obj, int initialx, int initialy, uint8 w, uint8 h) {
    sprite* s = (sprite*) malloc(sizeof(sprite));
    s->obj = obj;
    s->x = initialx;
    s->y = initialy;
    s->w = w;
    s->h = h;
    position(s);
    return s;
}

volatile object* create_paddle() {
    // 1. kleur
    PALETTE_MEM[0][2] = color(31, 0, 0);

    // 2. tile - vanaf hieronder alles bezet tot TILE_MEM[4][6]!
    volatile uint16 *paddle_tile = (uint16*) TILE_MEM[TILE_MEM_FG][next_tile_mem];  // begin vanaf 2
    next_tile_mem += 4;
    // vul de tile met de palet index 2 - dit is per rij, vandaar 0x2222
    for(int i = 0; i < 4 * sizeof(tile_4bpp) / 2; i++) {
        paddle_tile[i] = 0x2222;
    }

    // 3. object: 4bpp, wide - 32x8 met wide shape - vanaf de 2de tile, palet 0
    return create_object(0x4000,  0x4000, 2);
}

volatile object* create_ball() {
    // 1. kleur
    PALETTE_MEM[0][1] = color(31, 31, 31); // wit - zie labo 3

    // 2. tile
    volatile uint16 *ball_tile = (uint16*) TILE_MEM[TILE_MEM_FG][next_tile_mem];  // 1 block
    next_tile_mem++;
    // vul de tile met de palet index 1 - dit is per rij, vandaar 0x1111
    for(int i = 0; i < sizeof(tile_4bpp) / 2; i++) {
        ball_tile[i] = 0x1111;
    }

    // 3. object: 4bpp, square - grootte 8x8 met square - eerste tile, palet 0
    return create_object(0, 0, 1);
}

void initScreen() {
    REG_DISPLAY = DISPLAY_MODE1 | DISPLAY_ENABLE_OBJECTS;
}

uint16 readKeys() {
    return ~REG_KEY_INPUT & KEY_ANY;
}

void velocity(sprite *s) {
    s->x += s->dx;
    if(s->x < 0) s->x = 0;
    if(s->x > (SCREEN_WIDTH - s->w)) s->x = SCREEN_WIDTH - s->w;

    s->y += s->dy;
    if(s->y < 0) s->y = 0;
    if(s-> y > (SCREEN_HEIGHT - s->h)) s->y = SCREEN_HEIGHT - s->h;
}

int collides(sprite *s, sprite *o) {
    if((abs(s->x - o->x) < (s->w + o->w) / 2)
        && abs(s->y - o->y) < (s->h + o->h) / 2) {
        return 1;
    }
    return 0;
}

void you_died() {

}

int main() {
    uint16 keys, score = 0;
    sprite *ball = create_sprite(create_ball(), 50, 50, 8, 8);
    ball->dx = 2;
    ball->dy = 1;

    sprite *paddle = create_sprite(create_paddle(), (SCREEN_WIDTH / 2) - (32 / 2), SCREEN_HEIGHT - 10, 32, 8);

    sprite *blocks[5][3];
    for(int i = 0; i < 3; i++) {
        for(int j = 0; j < 5; j++) {
            blocks[i][j] = create_sprite(copy_object(paddle->obj), ((SCREEN_WIDTH / 5) * j) + 10, 5 + (10 * i), 32, 8);
        }
    }

    initScreen();

    while(1) {
        vsync();

        keys = readKeys();
        if(keys & KEY_LEFT) {
            paddle->dx = -VELOCITY;
            velocity(paddle);
        }
        if(keys & KEY_RIGHT) {
            paddle->dx = VELOCITY;
            velocity(paddle);
        }

        ball->x += ball->dx;
        ball->y += ball->dy;

        if(ball->x <= 0 || ball->x >= (SCREEN_WIDTH - ball->w)) {
            ball->dx = -ball->dx;
        }
        if(ball->y <= 0 || collides(ball, paddle)) {
            ball->dy = -ball->dy;
        }

        if(ball->y >= (SCREEN_HEIGHT - ball->h)) {
            you_died();
        } else {
            for(int i = 0; i < 3; i++) {
                for(int j = 0; j < 5; j++) {
                    sprite* block = blocks[i][j];
                    
                    if(!is_hidden(block) && collides(ball, block)) {
                        hide(block);
                        score++;

                        ball->dy = -ball->dy;
                    }
                }
            }
        }


        position(paddle);
        position(ball);
    }
}