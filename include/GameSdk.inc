;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;                               Game SDK
;       author  : terrynini
;       created : 2017/04/20
;       version : 0.1
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IFNDEF GAMESDK_INC
GAMESDK_INC equ <1>
ENDIF

;==========================================================================
;                           Declaration of functions
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
extern IMG_Init:near
extern IMG_Load:near
extern SDL_SetHint:near
extern SDL_CreateRenderer:near
extern SDL_SetRenderDrawColor:near
extern SDL_CreateTextureFromSurface:near
extern SDL_RenderClear:near
extern SDL_RenderCopy:near
extern SDL_RenderPresent:near
extern IMG_Quit:near
extern SDL_DestroyTexture:near
extern TTF_Init:near
extern TTF_OpenFont:near
extern TTF_RenderText_Solid:near
extern SDL_RenderCopyEx:near
;==========================================================================
;                           Declaration of Static
;..........................................................................
SDL_WINDOW_SHOWN        equ 4h
SDL_WINDOWPOS_UNDEFINED equ 1fff0000h
SDL_INIT_VIDEO          equ 20h
SDL_KEYDOWN             equ 300h
SDL_QUIT                equ 100h
SDLK_RIGHT              equ 4000004fh
SDLK_LEFT               equ 40000050h
SDLK_DOWN               equ 40000051h
SDLK_UP                 equ 40000052h
IMG_INIT_PNG            equ 2h
SDL_FLIP_NONE           equ 0
SDL_RENDERER_ACCELERATED        equ 2h    
SDL_RENDERER_PRESENTVSYNC       equ 4h

;==========================================================================
;                           Declaration of Struct for SDL
;..........................................................................
SDL_Color Struct
    R       BYTE ?
    G       BYTE ?  
    B       BYTE ?
    unused  BYTE ?
SDL_Color ENDS

Texture Struct
    mTexture    DWORD ?
    mWidth      DWORD ?
    mHeight     DWORD ?
Texture ENDS

SDL_Rect Struct
    X   DWORD  ?
    Y   DWORD  ?
    W   DWORD  ?
    H   DWORD  ?
SDL_Rect ENDS

SDL_Point Struct
    X   DWORD ?
    Y   DWORD ?
SDL_Point ENDS

;==========================================================================
;                  Declaration of Struct for emulating class
;..........................................................................

Entity  Struct
    X       DWORD ?
    Y       DWORD ?
    texture DWORD ?
    
Entity  ENDS