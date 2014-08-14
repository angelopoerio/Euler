/* 
	 Solution for http://projecteuler.net/problem=15
	 A better solution is here -> http://zacharydenton.com/project-euler-solutions/15/
	 This program uses a bruteforce approach to find all the routes, this is not the optimal way
	 but it is interesting to deal with graphs.
	 It takes 6 hours to run on my laptop :)
	 Author: Angelo Poerio <angelo.poerio@gmail.com>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MATRIX_SIZE 20 + 1 

struct Node {
	int x,y,adjs_len;
	struct Node **adjs;
};

typedef struct Node Node;
static long long int routesCnt = 0;

Node ***build_matrix(void) { /* build the graph that represents the grid 20x20 */
	Node ***matrix = malloc(sizeof(Node **) * MATRIX_SIZE);
	int i,j;

	for(i = 0;i < MATRIX_SIZE;i++) {
		matrix[i] = malloc(sizeof(Node *) * MATRIX_SIZE);
	}

	for(i = 0;i < MATRIX_SIZE;i++) { /* initialize */
		for(j = 0;j < MATRIX_SIZE;j++) {
			matrix[i][j] = malloc(sizeof(Node));
			matrix[i][j]->x = i + 1;
			matrix[i][j]->y = j + 1;
			matrix[i][j]->adjs_len = 0;
		}
	}

	for(i = 0;i < MATRIX_SIZE;i++) { /* connect the vertexes */
		for(j = 0;j < MATRIX_SIZE;j++) {
			Node *current_node = matrix[i][j];
			current_node->adjs = malloc(sizeof(Node *) * 4);
			
			if((j + 1) < MATRIX_SIZE) {
				current_node->adjs[current_node->adjs_len] = matrix[i][j+1];
				current_node->adjs_len += 1;
			}

			if((j - 1) >= 0) {
				current_node->adjs[current_node->adjs_len] = matrix[i][j-1];
				current_node->adjs_len += 1;
			}

			if((i + 1) < MATRIX_SIZE) {
				current_node->adjs[current_node->adjs_len] = matrix[i+1][j];
				current_node->adjs_len += 1;
			}

			if((i - 1) >= 0) {
				current_node->adjs[current_node->adjs_len] = matrix[i-1][j];
				current_node->adjs_len += 1;
			}
		}
	}

	return matrix;
}

void getRoutesCnt(Node *starting_node) { /* traverse the graph */
	int i;
	if(starting_node != NULL) {
		if(starting_node->x == MATRIX_SIZE && starting_node->y == MATRIX_SIZE) {
			routesCnt += 1; /* destination reached -> increment the counter */
		}

		for(i = 0;i < starting_node->adjs_len;i++) {
			Node *adj = starting_node->adjs[i];

			if(adj->x == starting_node->x && adj->y > starting_node->y)
			{
				getRoutesCnt(starting_node->adjs[i]);
			}

			if(adj->y == starting_node->y && adj->x > starting_node->x)
			{
				getRoutesCnt(starting_node->adjs[i]);
			}
		}
	}
}

int main(int argc, char *argv[]) {
	Node ***matrix = build_matrix();
	printf("It can take a while ...\n");
	getRoutesCnt(matrix[0][0]);
	printf("Answer is %lld\n", routesCnt); /* 137846528820 */
	/* we should free the memory but who cares ;) */
}
