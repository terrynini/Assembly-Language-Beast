#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "C_lib.h"

#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100

extern int8_t  dx[4], dy[4];
void C_Move(int XSpeed, int YSpeed){
    SDL_Point   Corner[4]; // LU RU LD RD

    for(int i = 0 ; i < 4 ; i++){
        Corner[i].X = Player_Main.Father.Position.X + Player_Main.Father.BoundBox.X;
        Corner[i].Y = Player_Main.Father.Position.Y + Player_Main.Father.BoundBox.Y;
    }
 
    Corner[1].X += Player_Main.Father.BoundBox.W;
    Corner[3].X += Player_Main.Father.BoundBox.W;

    Corner[2].Y += Player_Main.Father.BoundBox.H;
    Corner[3].Y += Player_Main.Father.BoundBox.H;

    for(int i = 0 ; i < 4 ; i++)
        Corner[i].X += XSpeed;
    for(int i = 0 ; i < 4 ; i++){
        if (!Map_Walkable(&Corner[i]))
            break;
        else if (i == 3){
            Player_Main.Father.Position.X += XSpeed;
        }
    }

    
    for(int i = 0 ; i < 4 ; i++){
        Corner[i].X -= XSpeed;
        Corner[i].Y += YSpeed;
    }
        for(int i = 0 ; i < 4 ; i++){
        if (!Map_Walkable(&Corner[i]))
            break;
        else if (i == 3){
            Player_Main.Father.Position.Y += YSpeed;
        }
    }
    return;
}
int Map_Walkable(SDL_Point* Position){
    return (Map_arr[Position->Y/48][Position->X/48] == 1)?1:0;
}

void Map_StartPoint(SDL_Point *Start){

    for(int i = 1 ; i < MAP_BLOCKS_Y - 1; i++){
        for(int j = 1 ; j < MAP_BLOCKS_X - 1 ; j++){
            if(Map_arr[i][j] != 1)
                continue;
            Start->X = j*48;
            Start->Y = i*48;

            return;
        }
        
    }

    return;
}