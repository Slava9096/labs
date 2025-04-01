#include <stdio.h>

unsigned int calculateRoot(unsigned int number){
	unsigned int result = 0;
	unsigned int remainder = number;
	for (int i = sizeof(number) * 4 - 1; i >= 0; i--) {
		unsigned int bit = 1 << i;
		unsigned int tmp = result | bit;
		// delta = tmp^2 - result^2 = (result + bit)^2 - result^2 = 2result*bit + bit^2
		unsigned int delta = (result << (i + 1)) + (1 << (i << 1));
		if (delta <= remainder){
			result = tmp;
			remainder -= delta;
		}
	}
	return result;
}

int main(){
	unsigned int number;
	printf("Введите число: ");
	scanf("%u", &number);
	unsigned int result = calculateRoot(number);
	printf("%u\n", result);
	return 0;
}
