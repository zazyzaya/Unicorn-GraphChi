#include <iostream>
#include <random>


std::gamma_distribution<double> gamma_dist(2.0, 1.0);

void update(unsigned long label) {
	std::default_random_engine generator(label);
	std::default_random_engine generator2(label + 5);
	for (int i = 0; i < 5; i++) {
		std::cout << gamma_dist(generator) << std::endl;
	}
	std::cout << "***************" << std::endl;
	for (int i = 0; i < 5; i++) {
		std::cout << gamma_dist(generator2) << std::endl;
	}
	std::cout << "+++++++++++++++" << std::endl;
}

int main()
{
	update(10);
	std::cout << "^^^^^^^^^^^^^^^^" << std::endl;
	update(25);
	std::cout << "^^^^^^^^^^^^^^^^" << std::endl;
	update(10);
	std::cout << "^^^^^^^^^^^^^^^^" << std::endl;
	update(25);
	
	return 0;
}
