;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;                               Game SDK
;       author  : terrynini
;       created : 2017/04/20
;       updated : 2017/05/01
;       version : 0.2
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
MAP_BLOCKS_ROW          equ 100d
MAP_BLOCKS_COL          equ 100d
;==========================================================================
;                           Declaration of SDL_functions
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
    W   DWORD  ?
    H   DWORD  ?
SDL_Rect ENDS

SDL_Point Struct
    X   SDWORD ?
    Y   SDWORD ?
SDL_Point ENDS

;==========================================================================
;                  Declaration of Struct for emulating class
;..........................................................................

Entity  Struct
    X           SDWORD ?
    Y           SDWORD ?
    AniCount    SDWORD ?
    texture     Texture {?, ?, ?}
    Clip        SDL_Rect 12 DUP({?, ?, 48, 48})
    BoundBox    SDL_Rect {?, ?, ?, ?}
Entity  ENDS

Player Struct
    Father      Entity {}
    Health_Max  SDWORD 100
    Health_Now  SDWORD 50
    Mana_MAX    SDWORD 200
    Mana_Now    SDWORD 150
Player ENDS


;==========================================================================
;                   Declatation of Procedure
;..........................................................................

TextureLoader       proto :ptr Texture, :ptr DWORD, :DWORD          ;fileptr: ptr DWORD, gRender:DWORD
MusicLoader         proto :ptr DWORD, :ptr BYTE, :BYTE ;AudioPtr:ptr DWORD, FilePtr:ptr BYTE, LoadType:BYTE
MusicPlayer         proto :DWORD, :BYTE                 ;AudioPtr:DWORD, PlayType:BYTE
Texturerender       proto :DWORD, :DWORD, :Texture, :DWORD, :ptr SDL_Rect ; X:DWORD, Y:DWORD, TEXTURE:Texture, gRender:DWORD
FontRender          proto :ptr DWORD, :ptr Texture, :DWORD, :DWORD;TextField:ptr DWORD, Texturept:ptr Texture, gFont:DWORD, gRender:DWORD
FontLoader          proto :ptr BYTE, :ptr DWORD          ;ttfFileptr:ptr BYTE, FontPtr:ptr DWORD
StateTickTock       proto
StateRender         proto
StateTitle_TickTock proto
StateTitle_Render   proto
MediaLoader         proto :DWORD                        ;gRender

State_Init          proto
SetState            proto :DWORD                        ;State:DWORD
StateGame_TickTock  proto
StateGame_Render    proto

Map_Init            proto
Map_Render          proto

CreatureController_Init     proto
CreatureController_Render   proto
CreatureController_TickTock proto

StatusBar_Init      proto
StatusBar_Render    proto
 
;==========================================================================
;                   Declatation of State
;..........................................................................

STATE_TITLE     equ 0
STATE_GAME      equ 1

