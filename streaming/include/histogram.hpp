/*
 *
 * Author: Xueyuan Han <hanx@g.harvard.edu>
 *
 * Copyright (C) 2018-2020 Harvard University
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2, as
 * published by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version.
 *
 */
#ifndef __HISTOGRAM_HPP__
#define __HISTOGRAM_HPP__

#include <iostream>
#include <map>
#include <vector>
#include <thread>
#include <mutex>
#include <math.h>
/* GraphChi header file. */
#include "logger/logger.hpp"
/* Unicorn header file. */
#include "def.hpp"

/* We use singleton design to create a single instance of a histogram.
 * This is not thread-safe. A proper locking mechanism is needed.
 * Current implementation uses an ordered Map as the histogram. */
class Histogram {
public:
    static Histogram* get_instance();
    ~Histogram();
    struct hist_elem construct_hist_elem(unsigned long label);
    void decay(FILE* fp);
    void update(unsigned long label, bool base);
    void create_sketch();
    void record_sketch(FILE* fp);
    unsigned long* get_sketch();
#ifdef DEBUG
    void comp(unsigned long label, struct hist_elem a, struct hist_elem b);
    void print_histogram();
#endif

private:
    static Histogram* histogram;

    Histogram() {
        this->t = 0;
        this->w = 0;
	this->c = 0;
        this->powerful = pow(M_E, -LAMBDA);
    }

    std::map<unsigned long, double> histogram_map; /* histogram_map maps a label to its value. */
    unsigned long sketch[SKETCH_SIZE];
    double hash[SKETCH_SIZE];
    double powerful;
   
    /* PREGEN is a compilation constant defined using -D flag.
     * It is the number of random variables we sampled ahead of time. */
    double gamma_param[PREGEN][SKETCH_SIZE];
    double r_beta_param[PREGEN][SKETCH_SIZE];
    double power_r[PREGEN][SKETCH_SIZE];

    int t; /* If t reaches DECAY, we decay the values in the histogram and hashed value by e^(-lambda). */
    int w; /* If WINDOW is used, when we reach WINDOW, we record the sketch.
	    * We may also use BATCH as the frequency to record the sketches.
	    * In that case, w is not used. */
    

    /* The lock needed to update histogram map. */
    std::mutex histogram_map_lock;
    /* The lock needed to construct new histogram parameters. */
    std::mutex histo_param_lock;

};

#include "histogram.cpp"

#endif /* __HISTOGRAM_HPP__ */
