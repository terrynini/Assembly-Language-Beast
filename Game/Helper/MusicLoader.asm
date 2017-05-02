.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data
rb               BYTE "rb", 0

.code

MusicLoader PROC  AudioPtr:ptr DWORD, FilePtr:ptr BYTE, LoadType:BYTE
    .IF LoadType == AUDIO_MUSIC
        push    FilePtr
        call    Mix_LoadMUS
    .ELSE
        push    offset rb
        push    FilePtr
        call    SDL_RWFromFile
        push    1
        push    eax
        call    Mix_LoadWAV_RW
    .ENDIF
    mov    esi, [AudioPtr]
    mov    [esi], eax
    ret
MusicLoader ENDP
end
