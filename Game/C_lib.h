#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100
#define UPDATE_MSEC  17
typedef struct{
    int X, Y
}SDL_Point;

typedef struct{
    int X, Y, W, H
}SDL_Rect;

typedef struct{
    int mTexture, mWidth, mHeight;
}Texture ;

typedef struct{
    SDL_Point   Position;
    int  AniCount;
    Texture  texture;    
    SDL_Rect Clip[12];
    SDL_Rect BoundBox;
}Entity;

typedef struct{
    Entity  Father;
    int Health_Max  ;
    int Health_Now ;
    int Mana_MAX    ;
    int Mana_Now    ;
}Player;

typedef struct{
    Entity  Father;
    int AniDir      ;
    int Health_Max  ;
    int Health_Now ;
    int Mana_MAX    ;
    int Mana_Now    ;
    int WalkCount   ;
    int WalkX     ;
    int WalkY     ;
}Monster; 

extern Player Player_Main;
extern Monster Monster_Kinds[100];
extern Monster Monster_array[100];
extern int MonsterKinds;
extern int Monster_count;
extern int8_t Map_arr[MAP_BLOCKS_Y][MAP_BLOCKS_X];