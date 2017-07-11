#include <stdio.h>

static int* a0;
static int N0;
static int M0;

typedef struct pair {
  int r;
  int c;
} pair_t;

static pair_t fail0 = { -1, -1 };

void write0(pair_t p) {
  printf("row: %d; col: %d\n", p.r, p.c);
}

int value0(int r, int c) {
  return *(a0 + N0*r + c);
}

int value1(pair_t p) {
  // printf("p.r %d; p.c %d; %d\n", p.r, p.c, *(a0 + N0*p.r + p.c));
  return *(a0 + N0*p.r + p.c);
}

/*

Need a (recursive) back-tracking algorithm.

Or some other method.

*/

pair_t toright(int r, int c) {
  if ((c+1) >= M0)
    return fail0;

  pair_t p;
  p.r = r;
  p.c = c+1;
  return p;
}

pair_t todown(int r, int c) {
  if ((r+1) >= N0)
    return fail0;

  pair_t p;
  p.r = r+1;
  p.c = c;
  return p;
}

int right0(pair_t p) {
  pair_t r0 = toright(p.r, p.c);

  if (r0.r >= 0)
    if (value1(r0) > value1(p)) return 1;

  return 0;
}

int down0(pair_t p) {
  pair_t r0 = todown(p.r, p.c);

  if (r0.r >= 0)
    if (value1(r0) > value1(p)) return 1;

  return 0;
}

int main () 
{ 
  int N = 0;
  int M = 0;
  /* get the array dimensions: N rows, M columns */
  scanf("%d %d", &N, &M);
  if (!(N >= 2 && N<=20)) return(1);
  if (!(M>=2 && M<=20)) return (2);

  int a[N][M];
  a0 = (int *)a;

  N0 = N;
  M0 = M;

  int i, j;

  /* read in the array */
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) 
      scanf("%d", &a[i][j]);
  }

  write0(toright(0, 0));

  /* output the array */
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      printf("%d - ", a[i][j]);
      printf("value0 %d ; ", value0(i,j));
      printf("toright %d ; ", toright(i,j).c);
      printf("todown %d ; ", todown(i,j).r);
    }
    printf("\n");
  }

  printf("\n");
  
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      pair_t p = { i, j };
      printf("%d ", right0(p));
    }
    printf("\n");
  }
 
  /* go down */
  printf("\n");
  
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      pair_t p = { i, j };
      printf("%d ", down0(p));
    }
    printf("\n");
  }
 
  return(0); 
} 
