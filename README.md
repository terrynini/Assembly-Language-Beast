# Assembly-Language-Beast
This is  my final project, it's a RPG.<br>
It's is very  similar to my java final project<br>
But I tried to link .obj files generated by C/C++ and masm<br>
I used gcc, masm, makefile, SDL to create this game

## Play
You can download from here:
https://drive.google.com/file/d/0B2uWL5j2yU39TDQtVk1aekJ1QlE/view?usp=sharing

Space: attack<br>
B:     backpack??<br>

Map will be randomly generate every time

# Call C function in Assembly

## generate a *.o file
> $gcc -c test.c -o test.o

or add pragma to tell IDE not to link
>  #pragma src </br>


## generate a *.a file

>ar rcs libtst.a test.o


## Gcc tips
add this directive to notify gas using Intel syntax
>.intel_syntax noprefix
