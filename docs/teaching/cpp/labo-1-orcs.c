#include <stdio.h>	// print/in/out
#include <stdlib.h> // rand() in gcc
#include <string.h>	// malloc
#include <time.h>	// rand() in clang

struct Orc {
	int aanval;
	int levens;
};

typedef struct Orc Orc;

Orc vecht(Orc aanvaller, Orc verdediger) {
	verdediger.levens -= aanvaller.aanval;
	return verdediger.levens > 0 ? verdediger : aanvaller;
}

Orc* generate_orcs(int aantal) {
	Orc* leger = malloc(sizeof(Orc) * aantal);
	for(int i = 0; i < aantal; i++) {
		Orc beest;
		beest.aanval = rand() % 21;
		beest.levens = rand() % 21;
		leger[i] = beest;
	}

	return leger;
}

char* omnom(char zin[]) {
	char* response = malloc(sizeof(char) * strlen(zin));
	strcpy(response, zin);

	for(int i = 0; i < strlen(response); i++) {
		char c = response[i];
		if(c == 'a' || c == 'i' || c == 'e' || c == 'o' || c == 'u') {
			response[i] = 'X';
		} 
	}

	return response;
}

int main() {
	// genereer een nieuwe seed voor de random waarde
	srand(time(NULL));

	printf("oorlog! woaah\n");
	printf("Zeg rap iets (100chars) --> ");

	char zin[100];
	fgets(zin, 100, stdin);

	printf("Orcs zeggen %s terug\n", omnom(zin));

	printf("Hoeveel orcs? ");
	int aantal;
	scanf("%d", &aantal);

	printf("%d dus, oké, komt-ie:\n", aantal);
	Orc* leger = generate_orcs(aantal);

	for(int i = 0; i < aantal; i++) {
		Orc beest = leger[i];
		printf("Orc #%d: aanval %d, levens %d\n", i + 1, beest.aanval, beest.levens);
	}

	printf("ze gaan elkaar opfretten...\n");
	Orc winnaar = leger[0];
	for(int j = 1; j < aantal; j++) {
		Orc beest = leger[j];

		printf("  -- VS: (%d,%d) tegen (%d,%d) ", winnaar.aanval, winnaar.levens, beest.aanval, beest.levens);
		winnaar = vecht(winnaar, beest);

		printf(" --- Orc met %d aanval wint\n", winnaar.aanval);
	}

	printf("Orc met %d aanval is last man standing!\n", winnaar.aanval);

	return 0;
}
