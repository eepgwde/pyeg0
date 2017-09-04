#include <stdio.h>

int max0(int a, int b) {
  if (a>b) return a;
  if (a<b) return b;
  return a;
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

pair_t toright(int r, int c) {
  pair_t p;
  p.r = r;
  p.c = c+1;
  return p;
}

pair_t todown(int r, int c) {
  pair_t p;
  p.r = r+1;
  p.c = c;
  return p;
}

int last_row(pair_t p) {
  return p.r >= N0-1;
}

int last_col(pair_t p) {
  return p.c >= M0-1;
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

static int last0 = 0;

int try(pair_t here, int count) {
  pair_t r = toright(here.r, here.c);
  pair_t d = todown(here.r, here.c);

  // Can we go right? Or down?
  int r0, r1, d0, d1;
  r0 = !last_col(here);
  r1 = r0 && value1(a0, r) > value1(a0, here) ;

  d0 = !last_row(here);
  d1 = d0 && value1(a0, d) > value1(a0, here) ;

  pair_t cands[2] = { 0, 0 };
  int counts[2] = { count, count };

  int idx = 0;

  last0 = max0(last0, count);

  if (r1) {
    counts[idx] = counts[idx] + 1;
    cands[idx] = r;
    idx++;
  }

  if (d1) {
    counts[idx] = counts[idx] + 1;
    cands[idx] = d;
    idx++;
  }

  // back-track
  if (!r1 && !d1) {
    return count;
  }

  while (--idx >= 0) {
    counts[idx] = try(cands[idx], counts[idx]);
  }

  int i=0;
  int maxcount = -1;
  for (i=0; i<2; i++)
    maxcount = max0(maxcount, counts[i]);

  return maxcount;
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

  /* output the array */
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      // printf("%d ", a[i][j]);
      pair_t p = { i, j};
    }
  }

  /* output the array */
  for(i=0; i<=N-1; i++) {
    for(j=0;j<=M-1;j++) {
      pair_t p = { i, j};
      int count = 0;
      try(p, count);
    }
  }

  if (last0 > 0) last0++;

  printf("%d\n", last0);

  return(0); 
} 
