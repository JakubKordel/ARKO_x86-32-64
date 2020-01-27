// graf_io.c : Defines the entry point for the console application.
//

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include "shaderect.h"

typedef struct
{
	int width, height;
	unsigned char* pImg;
	int imgSize;
} imgInfo;

typedef struct
{
	unsigned short bfType; 
	unsigned long  bfSize; 
	unsigned short bfReserved1; 
	unsigned short bfReserved2; 
	unsigned long  bfOffBits; 
	unsigned long  biSize; 
	long  biWidth; 
	long  biHeight; 
	short biPlanes; 
	short biBitCount; 
	unsigned long  biCompression; 
	unsigned long  biSizeImage; 
	long biXPelsPerMeter; 
	long biYPelsPerMeter; 
	unsigned long  biClrUsed; 
	unsigned long  biClrImportant;
} bmpHdr;

void* freeResources(FILE* pFile, void* pFirst, void* pSnd)
{
	if (pFile != 0)
		fclose(pFile);
	if (pFirst != 0)
		free(pFirst);
	if (pSnd !=0)
		free(pSnd);
	return 0;
}

imgInfo* InitImage (int w, int h)
{
	imgInfo *pImg;
	if ( (pImg = (imgInfo *) malloc(sizeof(imgInfo))) == 0)
		return 0;
	pImg->height = h;
	pImg->width = w;
	pImg->pImg = (unsigned char*) malloc((((w * 3 + 3) >> 2) << 2) * h);
	if (pImg->pImg == 0)
	{
		free(pImg);
		return 0;
	}
	memset(pImg->pImg, 0, (((w * 3 + 3) >> 2) << 2) * h);
	return pImg;
}

imgInfo * copyImage(const imgInfo* pImg)
{
	imgInfo *pNew = InitImage(pImg->width, pImg->height);
	if (pNew != 0)
		memcpy(pNew->pImg, pImg->pImg, pNew->imgSize);
	return pNew;
}

void FreeImage(imgInfo* pInfo)
{
	if (pInfo && pInfo->pImg)
		free(pInfo->pImg);
	if (pInfo)
		free(pInfo);
}


imgInfo* readBMP(const char* fname)
{
	imgInfo* pInfo = 0;
	FILE* fbmp = 0;
	bmpHdr bmpHead;
	int lineBytes, y;
	unsigned char* ptr;

	pInfo = 0;
	fbmp = fopen(fname, "rb");
	if (fbmp == 0)
		return 0;

	fread((void *) &bmpHead, sizeof(bmpHead), 1, fbmp);
	// parę sprawdzeń
	if (bmpHead.bfType != 0x4D42 || bmpHead.biPlanes != 1 ||
		bmpHead.biBitCount != 24 || 
		(pInfo = (imgInfo *) malloc(sizeof(imgInfo))) == 0)
		return (imgInfo*) freeResources(fbmp, pInfo ? pInfo->pImg : 0, pInfo);

	pInfo->width = bmpHead.biWidth;
	pInfo->height = bmpHead.biHeight;
	if ((pInfo->pImg = (unsigned char*) malloc(bmpHead.biSizeImage)) == 0)
		return (imgInfo*) freeResources(fbmp, pInfo->pImg, pInfo);

	// porzšdki z wysokociš (może być ujemna)
	ptr = pInfo->pImg;
	lineBytes = ((pInfo->width * 3 + 3) >> 2) << 2; // rozmiar linii w bajtach
	if (pInfo->height > 0)
	{
		// "do góry nogami", na poczštku dół obrazu
		ptr += lineBytes * (pInfo->height - 1);
		lineBytes = -lineBytes;
	}
	else
		pInfo->height = -pInfo->height;

	// sekwencja odczytu obrazu 
	// przesunięcie na stosownš pozycję w pliku
	if (fseek(fbmp, bmpHead.bfOffBits, SEEK_SET) != 0)
		return (imgInfo*) freeResources(fbmp, pInfo->pImg, pInfo);

	for (y=0; y<pInfo->height; ++y)
	{
		fread(ptr, 1, abs(lineBytes), fbmp);
		ptr += lineBytes;
	}
	fclose(fbmp);
	return pInfo;
}

int saveBMP(const imgInfo* pInfo, const char* fname)
{
	int lineBytes = ((pInfo->width * 3 + 3) >> 2)<<2;
	bmpHdr bmpHead = 
	{
	0x4D42,				// unsigned short bfType; 
	sizeof(bmpHdr),		// unsigned long  bfSize; 
	0, 0,				// unsigned short bfReserved1, bfReserved2; 
	sizeof(bmpHdr),		// unsigned long  bfOffBits; 
	40,					// unsigned long  biSize; 
	pInfo->width,		// long  biWidth; 
	pInfo->height,		// long  biHeight; 
	1,					// short biPlanes; 
	24,					// short biBitCount; 
	0,					// unsigned long  biCompression; 
	lineBytes * pInfo->height,	// unsigned long  biSizeImage; 
	11811,				// long biXPelsPerMeter; = 300 dpi
	11811,				// long biYPelsPerMeter; 
	2,					// unsigned long  biClrUsed; 
	0,					// unsigned long  biClrImportant;
	};

	FILE * fbmp;
	unsigned char *ptr;
	int y;

	if ((fbmp = fopen(fname, "wb")) == 0)
		return -1;
	if (fwrite(&bmpHead, sizeof(bmpHdr), 1, fbmp) != 1)
	{
		fclose(fbmp);
		return -2;
	}

	ptr = pInfo->pImg + lineBytes * (pInfo->height - 1);
	for (y=pInfo->height; y > 0; --y, ptr -= lineBytes)
		if (fwrite(ptr, sizeof(unsigned char), lineBytes, fbmp) != lineBytes)
		{
			fclose(fbmp);
			return -3;
		}
	fclose(fbmp);
	return 0;
}

int getPixel(const imgInfo *pInfo, int x, int y)
{
	int lineBytes = ((pInfo->width * 3 + 3) >> 2) << 2;
	unsigned char *pAddr = pInfo->pImg + y * lineBytes + x * 3;
	return *pAddr | (*(pAddr+1) << 8) | (*(pAddr+2) << 16); 
}

void putPixel(imgInfo *pInfo, int x, int y, int RGB, unsigned char *rgbBuf)
{
	int lineBytes = ((pInfo->width * 3 + 3) >> 2) << 2;
	unsigned char *pAddr = rgbBuf + y * lineBytes + x * 3;
	*pAddr = RGB & 0xFF;
	*(pAddr+1) = (RGB >> 8) & 0xFF;
	*(pAddr+2) = (RGB >> 16) & 0xFF;
}

/*
Funkcja wykonuje filtr splotowy obrazu
IN:	pInfo - wskazanie na deskryptor obrazu ródłowego
	msize - rozmiar maski (dodatni i nieparzysty!)
	mask - wskazanie na tablicę współczynników maski
	dstimg - wskazanie na zaalokowany bufor obrazu wynikowego
RET: dstimg
*/
unsigned char* ConvFilter(imgInfo *pInfo, int msize, int* mask, unsigned char* dstimg)
{
	int x, y, xx, yy;
	int srcRGB, red, green, blue, norm;
	int *cfptr;

	for (y = 0; y < pInfo->height; ++y)
		for (x = 0; x < pInfo->width; ++x)
		{
			if (x < msize / 2 || x >= pInfo->width - msize / 2 ||
				y < msize / 2 || y >= pInfo->width - msize / 2)
			{
				srcRGB = getPixel(pInfo, x, y);
				putPixel(pInfo, x, y, srcRGB, dstimg);
			}
			else
			{
				red = green = blue = norm = 0;
				cfptr = mask;
				for (yy = - msize / 2; yy <= msize / 2; ++yy)
					for (xx = - msize / 2; xx <= msize / 2; ++xx)
					{
						srcRGB = getPixel(pInfo, x + xx, y + yy);
						blue += (srcRGB & 0xFF) * *cfptr;
						green += ((srcRGB >> 8) & 0xFF) * *cfptr;
						red += ((srcRGB >> 16) & 0xFF) * *cfptr;
						norm += *cfptr;
						++cfptr;
					}
				srcRGB = (blue / norm) | ((green / norm) << 8) | ((red / norm) << 16);
				putPixel(pInfo, x, y, srcRGB, dstimg);
			}
		}

	return dstimg;
}

/* na galerze kompiluję i konsoliduję:

	gcc -m32 -fpack-struct=1 graf_io.c

*/

int main(int argc, char* argv[])
{
	imgInfo *pCmp;
	int maskSize = 5;
	int maskTb[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, };

	if (sizeof(bmpHdr) != 54)
	{
		printf("Trzeba zmienić opcje kompilacji, tak by rozmiar struktury bmpHdr wynosił 54 bajty.\n");
		return 1;
	}

	

	if(argc<7){
		printf("Arg.missing\n");
		return 0;
	}

	unsigned int color[4];
	char * pEnd = NULL;
	for (int i = 0; i < 4; ++i )
		color[i] = strtol(argv[3 + i], &pEnd, 0);
	
	int width = atoi(argv[2]);
	int height = atoi(argv[1]);
	if ( width >= 2 && height >= 2 ){
		pCmp = InitImage(width, height);
		shaderect( pCmp->pImg, height, width, color );
		if (saveBMP(pCmp, "shadedrect.bmp") != 0)
		{
			printf("Bład zapisu pliku wynikowego.\n");
			return 3;
		}
		FreeImage(pCmp);
	}
	else 
		printf("Height and width must be greater than 1");
	return 0;
}
