#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int strcmp_own(char *s, char *t) {
	while(*s == *t) {
		s++;
		t++;
		if(*s == '\0') return 0;
	}
	return *s - *t;
}

typedef void(*biblio)(char**, int);

void brave_bibliothecaris(char **boeken, int aantal) {
	int i;
	for(i = 1; i < aantal; i++) {
		char* boek = boeken[i];
		int j;

		for(j = i - 1; j >= 0; j--) {
			char* ander = boeken[j];

			if(strcmp_own(ander, boek) < 0) {
				break;
			}
			boeken[j + 1] = ander;
		}

		boeken[j + 1] = boek;
	}
}

void reverse(char **boeken, int aantal) {
	int i = aantal - 1;
	int j = 0;
	while(i > j) {
		char *temp = boeken[i];
		boeken[i] = boeken[j];
		boeken[j] = temp;
		i--;
		j++;
	}
}

void stoute_bibliothecaris(char **boeken, int aantal) {
	brave_bibliothecaris(boeken, aantal);
	reverse(boeken, aantal);
}

void test_strcmp() {
	printf("verschil tussen sul en sup: %d\n", strcmp_own("sul", "sup"));
	printf("verschil tussen sup en sul: %d\n", strcmp_own("sup", "sul"));
	printf("verschil tussen sup en sup: %d\n", strcmp_own("sup", "sup"));
	printf("verschil tussen sup en su: %d\n", strcmp_own("sup", "su"));	
}

int main() {
	biblio biblio_fn = brave_bibliothecaris;
	char *stout = malloc(sizeof(char) * 128);
	printf("stout geweest? (stout/braaf) ");
	scanf("%s", stout);
	getchar();

	if(strcmp_own(stout, "stout") == 0) {
		printf(" ja dus, oei? ");
		biblio_fn = stoute_bibliothecaris;
	} else {
		printf(" braaf zo. ");
	}

	printf("input graag: ");
	char zin[100];
	fgets(zin, 100, stdin);

	int i;
	char *boeken[10];
	char *split = strtok(zin, " ");

	while(split != NULL) {
		boeken[i++] = split;
		split = strtok(NULL, " ");
	}

	biblio_fn(boeken, i);

	printf("gesorteerde boekenlijst: \n");
	for(int j = 0; j < i; j++) {
		printf("%s\n", boeken[j]);
	}

	return 0;
}