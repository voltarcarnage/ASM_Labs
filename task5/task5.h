#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#include <fcntl.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"

#pragma once

void resize_Asm(unsigned char*,unsigned char*, int, int, int, int, int);
void resize(unsigned char*, unsigned char*, int, int, int, int, int);
void timing();
