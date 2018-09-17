#include <iostream>
#include <random>

int main()
{
	std::default_random_engine generator;
	generator.seed(24);
	std::default_random_engine generator2;
	generator2.seed(24);
 	std::gamma_distribution<double> d1(2.0,2.0);
 	std::gamma_distribution<double> d2(d1.param());

 	std::uniform_real_distribution<double> ud1(0.0, 1.0);
 	std::uniform_real_distribution<double> ud2(ud1.param());

	// print two independent values:
	for (int i = 0; i < 15; i++) {
		std::cout << d1(generator) << std::endl;
	}
	std::cout << "------------" << std::endl;
	for (int i = 0; i < 15; i++) {
		std::cout << d2(generator2) << std::endl;
	}
	std::cout << "*************" << std::endl;
	for (int i = 0; i < 15; i++) {
		std::cout << ud1(generator) << std::endl;
	}
	std::cout << "------------" << std::endl;
	for (int i = 0; i < 15; i++) {
		std::cout << ud2(generator2) << std::endl;
	}

	return 0;
}