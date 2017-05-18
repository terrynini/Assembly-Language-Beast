#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "C_lib.h"

#define MAX_ROOMS 100
#define MAP_BLOCKS_X 100
#define MAP_BLOCKS_Y 100


int8_t  Map_dup[MAP_BLOCKS_Y][MAP_BLOCKS_X];
const int8_t  dx[4] = {1, -1, 0, 0}, dy[4] = {0, 0, 1, -1};
void FloodFill(int y, int x){
    int8_t dir;
    if(y == 0 || x == 0 || y == MAP_BLOCKS_Y-1 || x == MAP_BLOCKS_X-1 || Map_dup[y][x] )
        return;

    if(Map_dup[y-1][x] + Map_dup[y+1][x] + Map_dup[y][x-1] + Map_dup[y][x+1] < 2){
        Map_dup[y][x] = 1;
        dir = rand()%4;
        for(int i = 0 ; i < 4 ; i++)
            FloodFill(y + dy[(dir+i)%4], x + dx[(dir+i)%4]);
    }
    return;
}
int BFS(int y, int x ){
    if( Map_dup[y][x] != 1)
        return 0;
    int count = 1;

    Map_dup[y][x] = 2;

    for(int i = 0; i < 4 ; i++){
        count += BFS(y+dy[i], x+dx[i]);
    }
    return count;
}
int C_FloodFill(){
    for(int i = 0 ; i < MAP_BLOCKS_X ; i++){
        for(int j = 0 ; j < MAP_BLOCKS_Y ; j++){
            Map_dup[j][i] = Map_arr[j][i];
        }
    }
    int x, y;
    for(int i = 1 ; i < MAP_BLOCKS_X-1 ; i++){
        for(int j = 1 ; j < MAP_BLOCKS_Y-1 ; j++){
            if(Map_dup[j][i] == 0){
                x = i;
                y = j;
                j = i = 99;
            }
        }
    }
    FloodFill(y, x);
    //cut the roads which are not so important
    for(int k = 0 ; k < 5 ; k++){
        for(int i = 1 ; i < MAP_BLOCKS_Y-1 ; i++){
            for(int j = 1 ; j < MAP_BLOCKS_X-1 ; j++){
                    if(Map_dup[i-1][j] + Map_dup[i+1][j] + Map_dup[i][j-1] + Map_dup[i][j+1] == 1){
                        Map_dup[i][j] = 0;
                    }
            }
        }
    }
    //destroy the wall which surrounded by road cannot be draw in tile
    //also  break the wall of rooms
     for(int i = 2 ; i < MAP_BLOCKS_Y-1 ; i++){
            for(int j = 1 ; j < MAP_BLOCKS_X-1 ; j++){
                    if(!Map_dup[i][j] && (Map_dup[i-1][j] + Map_dup[i+1][j]) > 1)
                        Map_dup[i][j] = 1;
            }
    }
    
    for(int i = 1 ; i < MAP_BLOCKS_Y-1 ; i++)
            for(int j = 1 ; j < MAP_BLOCKS_X-1 ; j++)
                    if(Map_dup[i][j] == 1){
                        BFS(i, j);
                        i = j = 10000;
                    }

    FILE *pFile;
    pFile = fopen( "write.txt","w" );
    
    int deletecounter = 0;
    for(int i = 1 ; i < MAP_BLOCKS_Y-1 ; i++)
            for(int j = 1 ; j < MAP_BLOCKS_X-1 ; j++)
                    if(Map_dup[i][j] == 1){
                       Map_dup[i][j] = 0;
                       deletecounter += 1;
                    }


    
    if(deletecounter > MAP_BLOCKS_X *MAP_BLOCKS_Y)
        return 0;
    else{
        for(int j = 0 ; j < MAP_BLOCKS_Y ; j++){
            for(int i = 0 ; i < MAP_BLOCKS_X ; i++){
                if(Map_dup[j][i] > 0)
                    Map_arr[j][i] = 1;
                else if(j == MAP_BLOCKS_Y -1 || (Map_dup[j+1][i] == 0))
                    Map_arr[j][i] = 2;
                else
                    Map_arr[j][i] = Map_dup[j][i];
            }
        }
    }
    for(int i = 0 ; i < MAP_BLOCKS_X ; i++){
        for(int j = 0 ; j < MAP_BLOCKS_Y ; j++){
            fprintf(pFile,"%d ",Map_arr[i][j]);
        }
        fprintf(pFile, "\n");
       
    }
    fclose(pFile);
    return 1;
}