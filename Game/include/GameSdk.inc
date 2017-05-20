;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;                               Game SDK
;       author  : terrynini
;       created : 2017/04/20
;       updated : 2017/05/15
;       version : 0.3
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;IFNDEF GAMESDK_INC
;GAMESDK_INC equ <1>
;ENDIF
;==========================================================================
;                   Declatation of Global variable
;..........................................................................

SCREEN_WIDTH            equ 816d   
SCREEN_HALF_WIDTH       equ 408d
SCREEN_HEIGHT           equ 624d
SCREEN_HALF_HEIGHT      equ 312d
UPDATE_MSEC             equ 17d
MAP_BLOCKS_X            equ 100d
MAP_BLOCKS_Y            equ 100d
ROOM_MAX_WIDTH          equ 20d
ROOM_MAX_HEIGHT         equ 20d
MAX_ROOMS               equ 100d
PLAYER_ATTACK           equ 0
Max_Monster             equ 40
;==========================================================================
;                           Declaration of extern function
;..........................................................................
extern SDL_Init:near
extern SDL_CreateWindow:near
extern SDL_DestroyWindow:near
extern SDL_Quit:near
extern SDL_PollEvent:near
extern SDL_RWFromFile:near
extern SDL_LoadBMP_RW:near
extern SDL_GetWindowSurface:near
extern SDL_UpperBlit:near
extern SDL_UpdateWindowSurface:near
extern SDL_FreeSurface:near
extern SDL_Delay:near
extern SDL_SetHint:near
extern SDL_CreateRenderer:near
extern SDL_SetRenderDrawColor:near
extern SDL_CreateTextureFromSurface:near
extern SDL_RenderClear:near
extern SDL_RenderCopy:near
extern SDL_RenderPresent:near
extern SDL_DestroyTexture:near
extern SDL_RenderCopyEx:near
extern SDL_GetKeyboardState:near
extern SDL_SetTextureAlphaMod:near
extern SDL_SetTextureBlendMode:near
extern Mix_OpenAudio:near
extern IMG_Init:near
extern IMG_Load:near
extern IMG_Quit:near
extern TTF_Init:near
extern TTF_OpenFont:near
extern TTF_RenderText_Solid:near
extern TTF_RenderText_Blended:near
extern Mix_LoadMUS:near
extern SDL_RWFromFile:near
extern Mix_LoadWAV_RW:near
extern Mix_PlayChannelTimed:near
extern Mix_PlayMusic:near
extern Mix_HaltMusic:near
extern SDL_GetTicks:near
extern SDL_Delay:near
extern IMG_LoadTexture:near
extern Mix_PauseMusic:near
extern SDL_SetWindowIcon:near
extern SDL_CreateRGBSurface:near
extern SDL_HasIntersection:near
extern SDL_RenderFillRect:near
extern time:near
extern srand:near
extern rand:near
extern C_FloodFill:near
extern Map_Walkable:near
extern Map_StartPoint:near
extern C_Move:near
extern C_Monster_Generate:near
extern C_Add_Monster_Kind:near
extern C_Monster_Move:near
extern C_Monster_Damage:near
extern C_Monster_Dead:near
extern C_SkillStack:near
extern C_SkillRender:near
extern C_Monster_CD:near
;==========================================================================
;                           Declaration of SDL_Static
;..........................................................................
SDL_WINDOW_SHOWN                equ 4h
SDL_WINDOWPOS_UNDEFINED         equ 1fff0000h
SDL_INIT_VIDEO                  equ 20h
SDL_INIT_AUDIO                  equ 10h
SDL_KEYDOWN                     equ 300h
SDL_QUIT                        equ 100h
SDLK_RIGHT                      equ 4000004fh
SDLK_LEFT                       equ 40000050h
SDLK_DOWN                       equ 40000051h
SDLK_UP                         equ 40000052h
IMG_INIT_PNG                    equ 2h
SDL_FLIP_NONE                   equ 0
SDL_BLENDMODE_BLEND             equ 1
SDL_RENDERER_ACCELERATED        equ 2h    
SDL_RENDERER_PRESENTVSYNC       equ 4h
SDL_SCANCODE_UP                 equ 52h
SDL_SCANCODE_DOWN               equ 51h
SDL_SCANCODE_LEFT               equ 50h
SDL_SCANCODE_RIGHT              equ 4fh
SDL_SCANCODE_SPACE              equ 2ch
SDL_SCANCODE_B                  equ 5
SDL_SCANCODE_M                  equ 16
SDL_TRUE                        equ 1
MIX_DEFAULT_FORMAT              equ 8010h
AUDIO_MUSIC                     equ 1
AUDIO_WAV                       equ 0

;==========================================================================
;                           Declaration of Struct for SDL
;..........................................................................
SDL_Color Struct
    R       BYTE ?
    G       BYTE ?  
    B       BYTE ?
    A       BYTE ?
SDL_Color ENDS

Texture Struct
    mTexture    DWORD ?
    mWidth      DWORD ?
    mHeight     DWORD ?
Texture ENDS

SDL_Rect Struct
    X   SDWORD  ?
    Y   SDWORD  ?
    W   SDWORD  ?
    H   SDWORD  ?
SDL_Rect ENDS

SDL_Point Struct
    X   SDWORD ?
    Y   SDWORD ?
SDL_Point ENDS

;==========================================================================
;                  Declaration of Struct for emulating class
;..........................................................................

Entity  Struct
    Position    SDL_Point {}
    AniCount    SDWORD ?
    texture     Texture {?, ?, ?}
    Clip        SDL_Rect 12 DUP({?, ?, 48, 48})
    BoundBox    SDL_Rect {?, ?, ?, ?}
Entity  ENDS

Entitytwo  Struct
    Position    SDL_Point {}
    AniCount    SDWORD ?
    texture     Texture {?, ?, ?}
    Clip        SDL_Rect 21 DUP({?, ?, 48, 48})
    BoundBox    SDL_Rect {?, ?, ?, ?}
Entitytwo  ENDS

Player Struct
    Father      Entity {}
    Health_Max  SDWORD 100
    Health_Now  SDWORD 50
    Mana_Max    SDWORD 200
    Mana_Now    SDWORD 150
    Face        DWORD  0
Player ENDS

Monster Struct
    Father      Entity {}
    AniDir      SDWORD 1
    Health_Max  SDWORD 250
    Health_Now  SDWORD ?
    Mana_MAX    SDWORD 200
    Mana_Now    SDWORD ?
    WalkCount   DWORD  0
    WalkX       DWORD  0
    WalkY       DWORD  0
    Casting     DWORD  0
    ID          DWORD  0
Monster ENDS

Skill Struct
    Father      Entitytwo {}
    ID          DWORD 0
    CD          DWORD 0
    Damage      SDWORD 0
    Cost        SDWORD 0
Skill ENDS
;==========================================================================
;                   Declatation of Procedure
;..........................................................................

MusicLoader         proto :ptr DWORD, :ptr BYTE, :BYTE
MusicPlayer         proto :DWORD, :BYTE

Texturerender       proto :DWORD, :DWORD, :Texture, :DWORD, :ptr SDL_Rect
TextureLoader       proto :ptr Texture, :ptr DWORD, :DWORD

FontRender          proto :ptr DWORD, :ptr Texture, :DWORD, :DWORD, :DWORD
FontLoader          proto :ptr BYTE, :ptr DWORD          

State_Init          proto
SetState            proto :DWORD                        
StateTickTock       proto
StateRender         proto

StateGame_Init      proto
StateGame_TickTock  proto
StateGame_Render    proto

Map_Init            proto
Map_Render          proto

CreatureController_Init     proto
CreatureController_Render   proto
CreatureController_TickTock proto

StatusBar_Init      proto
StatusBar_Render    proto
StatusBar_TickTock  proto

StateTitle_Init     proto
StateTitle_TickTock proto
StateTitle_Render   proto

BackPack_Init       proto
BackPack_TickTock   proto
BackPack_Render     proto

MainCharactor_Init      proto
MainCharactor_TickTock  proto
MainCharactor_Render    proto


Monsters_Init       proto
Monsters_TickTock   proto
Monsters_Render     proto

Skill_Init           proto
Skill_TickTock      proto
Skill_Render        proto
Skill_Stack          proto :DWORD

StateDead_Init      proto
StateDead_TickTock  proto
StateDead_Render    proto
;==========================================================================
;                   Declatation of State
;..........................................................................

STATE_TITLE     equ 0
STATE_GAME      equ 1
STATE_BACKPACK  equ 2
STATE_DEAD      equ 3

