#include <stdio.h>

int max0(int a, int b) {
  if (a>b) return 1;
  if (a<b) return -1;
  return 0;
}
  
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

int value0(int *arr, int r, int c) {
  return *(arr + N0*r + c);
}

int value1(int *arr, pair_t p) {
  // printf("p.r %d; p.c %d; %d\n", p.r, p.c, *(a0 + N0*p.r + p.c));
  return value0(arr, p.r, p.c);
}

pair_t toleft(int r, int c) {
  if ((c-1) < 0)
    return fail0;

  pair_t p;
  p.r = r;
  p.c = c-1;
  return p;
}

pair_t toabove(int r, int c) {
  if ((r-1) < 0)
    return fail0;

  pair_t p;
  p.r = r-1;
  p.c = c;
  return p;
}

int left0(int *arr, pair_t p) {
  pair_t r0 = toleft(p.r, p.c);

  if (r0.r >= 0)
    if (value1(arr, r0) < value1(arr, p)) return 1;

  return 0;
}

int above0(int *arr, pair_t p) {
  pair_t r0 = toabove(p.r, p.c);

  if (r0.r >= 0)
    if (value1(arr, r0) < value1(arr, p)) return 1;

  return 0;
}

/*

Need a (recursive) back-tracking algorithm.

try(here) {

if hasright(here) && value(right) > value(here)
then cand1 = right

if hasbelow(here) && value(below) > value(here)
then cand2 = below

count1 = try(right)
count2 = try(below)

return max0(count1, count2)

}

*/

int try(pair_t p, int count) {

  
  return max0(count1, count2);
}

void write1(int *arr) {
  int i, j;
  
  for(i=0; i<=N0-1; i++) {
    for(j=0;j<=M0-1;j++) {
      printf("%d ", value0(arr, i, j));
    }
    printf("\n");
  }
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

  write0(toleft(0, 0));

  /* output the array */
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      printf("%d ", a[i][j]);
    }
    printf("\n");
  }

  write1(a0);

  int left[N][M];
  
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      pair_t p = { i, j };
      left[i][j] = left0(a0, p);
    }
  }

  write1((int *)left);
 
  int above[N][M];
  
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      pair_t p = { i, j };
      above[i][j] = above0(a0, p);
    }
  }
 
  write1((int *)above);

  return(0); 
} 
