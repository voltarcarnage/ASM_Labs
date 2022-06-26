#include "task5.h"

int main(int argc, char** argv)
{
  if(argc != 5)
  {
		fprintf(stderr, "Usage: %s <input> <output> <width_new> <height_new>\n", argv[0]);
		exit(-1);
	}

  if(!atoi(argv[3]) || !atoi(argv[4]))
  {
    fprintf(stderr, "Width and height of new image must be > 0\n");
    exit(-1);
  }

  char *input = 0, *output = 0;
  int width, height, channels;
  int fd = 0;
  clock_t t;
  float time;
  int width_new = atoi(argv[3]);
  int height_new = atoi(argv[4]);

  input = argv[1];
  output = argv[2];

  if(access(input, F_OK) != 0){
		fprintf(stderr, "Input file does not exist\n");
		exit(1);
	}

	if ((fd = open(output, O_CREAT | O_WRONLY | O_TRUNC, 0644)) == -1){
		fprintf(stderr, "Can't open output for writing\n");
		exit(1);
	}

  close(fd);

  unsigned char* inputData = stbi_load(input, &width, &height, &channels, 0);

  if(!inputData)
  {
    fprintf(stderr, "Couldn't load the image\n");
		exit(1);
  }

  printf("Input image: %s\nOutput image: %s\n", input, output);


  printf("----Image----\n");
  unsigned char *temp = (unsigned char*)malloc(width_new * height_new * channels);
  t = clock();
  resize_Asm(inputData, temp, width, height, width_new, height_new, channels);
  t = clock() - t;
  time = ((float)t) / CLOCKS_PER_SEC;
  printf("Asm: %f\n", time);
  stbi_write_png(output, width_new, height_new, channels, temp, width_new * channels);
  t = clock();
  resize(inputData, temp, width, height, width_new, height_new, channels);
  t = clock() - t;
  time = ((float)t) / CLOCKS_PER_SEC;
  printf("C:   %f\n", time);
  //stbi_write_png(output, width_new, height_new, channels, temp, width_new * channels);
  stbi_image_free(inputData);
  free(temp);
  printf("-------------\n");

  return 0;
}

void resize(unsigned char* inputData, unsigned char * temp, int w1, int h1, int w2, int h2, int channels)
  {
    int x_ratio = (int)((w1 << 16) / w2) + 1;
    int y_ratio = (int)((h1 << 16) / h2) + 1;

    int px, py;

    for(int i = 0; i < h2; i++)
    {
      for(int j = 0; j < w2; j++)
      {
        for(int k = 0; k < channels; k++)
        {
          px = ((j * x_ratio) >> 16);
          py = ((i * y_ratio) >> 16);
          temp[(i * channels * w2) + j * channels + k] = inputData[(py * channels * w1) + px * channels + k];
        }
      }
    }
  }

/*void resize(unsigned char* inputData, unsigned char * temp, int w1, int h1, int w2, int h2, int channels)
{
   float x_ratio = w1/(float)w2;
   float y_ratio = h1/(float)h2;

   float px, py;

   for(int i = 0; i < h2; i++)
   {
     for(int j = 0; j < w2; j++)
     {
       for(int k = 0; k < channels; k++)
       {
         px = trunc(j  * x_ratio);
         py = trunc(i  * y_ratio);
         temp[(i * channels * w2) + j * channels + k] = inputData[(int)((py * channels * w1) + px * channels + k)];
       }
     }
   }
 }*/
