/*
 *
 * Author: Xueyuan Han <hanx@g.harvard.edu>
 *
 * Copyright (C) 2018 Harvard University
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2, as
 * published by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version.
 *
 */
#include "include/histogram.hpp"

Histogram* Histogram::histogram;

Histogram* Histogram::get_instance() {
	if (!histogram) 
		histogram = new Histogram();
	return histogram;
}

Histogram::~Histogram(){
	this->size = 0;
	delete histogram;
}

/*!
 * @brief Insert @label to the histogram_map if it does not exist; otherwise, update the mapped value.
 *
 */
void Histogram::insert_label(unsigned long label) {
	std::pair<std::map<unsigned long, struct hist_elem>::iterator, bool> rst;
	struct hist_elem new_elem;
	new_elem.cnt = 1;
	for (int i = 0; i < SKETCH_SIZE; i++) {
		new_elem.r[i] = gamma_dist(r_generator);
		new_elem.beta[i] = uniform_dist(beta_generator);
		new_elem.c[i] = gamma_dist(c_generator);
	}
	rst = this->histogram_map.insert(std::pair<unsigned long, struct hist_elem>(label, new_elem));
	if (rst.second == false) {
#ifdef DEBUG
		logstream(LOG_DEBUG) << "The label " << label << " is already in the map. Updating the value only." << std::endl;
#endif
		//TODO: UPDATE HIST_ELEM CODE GOES HERE.
		// rst.first->second++;
	} else {
		this->size++;
	}

	return;
}

/*!
 * @brief Remove @label from the histogram_map.
 *
 */
// void Histogram::remove_label(unsigned long label) {
// 	std::map<unsigned long, int>::iterator it;
// 	it = this->histogram_map.find(label);
// 	if (it != this->histogram_map.end()) {
// 		it->second--;
// 		if (it->second == 0){
// 			this->size--;
// 		}
// 	}
// #ifdef DEBUG
// 	else {
// 		logstream(LOG_ERROR) << "Decrement histogram element count failed! The label " << label << " should have been in the histogram, but it is not." << std::endl;		
// 	}
// #endif

// 	return;
// }

/*!
 * @brief Print the histogram map for debugging.
 *
 */
void Histogram::print_histogram() {
	//TODO: PRINT HISTOGRAM CODE GOES HERE.
	// std::map<unsigned long, int>::iterator it;
	logstream(LOG_DEBUG) << "Printing histogram map to the console..." << std::endl;
	// for (it = this->histogram_map.begin(); it != this->histogram_map.end(); it++)
		// logstream(LOG_DEBUG) << "[" << it->first << "]->" << it->second << "  ";
	return;
}