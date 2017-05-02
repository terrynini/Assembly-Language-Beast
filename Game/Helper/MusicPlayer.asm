.386
.model flat, stdcall
option casemap:none

include .\include\GameSdk.inc

.data

.code
MusicPlayer PROC AudioPtr:DWORD, PlayType:BYTE
    .IF PlayType == AUDIO_MUSIC    
        push    -1
        push    AudioPtr
        call    Mix_PlayMusic
    .ELSE
        push    -1
        push    0
        push    AudioPtr
        push    -1
        call    Mix_PlayChannelTimed
    .ENDIF
    ret
MusicPlayer ENDP
end