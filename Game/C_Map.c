#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "C_lib.h"

#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100
#define DEBUG
extern int8_t  dx[4], dy[4];

int Map_Walkable(SDL_Point* Position){
    return (Map_arr[Position->Y/48][Position->X/48] == 1)?1:0;
}


void C_Move(int XSpeed, int YSpeed){
    SDL_Point   Corner[4]; // LU RU LD RD
    Player* monster = &Player_Main;

    #ifdef DEBUG
        Player_Main.Father.Position.X += 2*XSpeed;
        Player_Main.Father.Position.Y += 2*YSpeed;
        return;
    #endif
    for(int i = 0 ; i < 4 ; i++){
        Corner[i].X = monster->Father.Position.X + monster->Father.BoundBox.X;
        Corner[i].Y = monster->Father.Position.Y + monster->Father.BoundBox.Y;
    }
 
    Corner[1].X += monster->Father.BoundBox.W;
    Corner[3].X += monster->Father.BoundBox.W;

    Corner[2].Y += monster->Father.BoundBox.H;
    Corner[3].Y += monster->Father.BoundBox.H;

    for(int i = 0 ; i < 4 ; i++)
        Corner[i].X += XSpeed;
    for(int i = 0 ; i < 4 ; i++){
        if (!Map_Walkable(&Corner[i]))
            break;
        else if (i == 3){
            monster->Father.Position.X += XSpeed;
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
            monster->Father.Position.Y += YSpeed;
        }
    }
    return;
}

void Map_StartPoint(SDL_Point *Start){
    int i , j;
    while(1){
            i = rand()%(MAP_BLOCKS_X-2) + 1;
            j = rand()%(MAP_BLOCKS_Y-2) + 1;
            if(Map_arr[i][j] != 1)
                continue;
            Start->X = j*48;
            Start->Y = i*48;

            return;
    }
        

    return;
}

 