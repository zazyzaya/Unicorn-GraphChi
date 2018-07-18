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
#ifndef def_hpp
#define def_hpp

#define _USE_MATH_DEFINES

#include <random>
#include <cmath>
/* This is the size of the sketch. */
#define SKETCH_SIZE 100

/* The value of "cnt" element in the histogram will decay every DECAY updates. */
#define DECAY 10

/* The rate of the decay. */
#define LAMBDA 0.02

/* Determines how many new edges we see before we record the hashed streaming histogram. */
#define INTERVAL 100


/* In a truly streaming setting, GraphChi does not allow dynamic vertex/edge type.
 * We therefore must fixed the neighborhood we are exploring.
 * Currently we implement 3-hop neighborhood.
 * Therefore, The array "src" holds 4 elemenst:
 * 		- The label of the source node, which we can initialize from the file.
 * 		- The relabel of the first-hop neighborhood.
 *		- The relabel of the second-hop neighborhood.
 * 		- The relabel of the third-hop neighborhood.
 * The array "tme" is corresponding timestamps. The first element is the timestamep of the edge.
 * The following elements are the corresponding timestamps of the relabeled node at each hop.
 * "dst" is the label of the destination node.
 * "itr" is the number of times the destination node has access the edge for computation.
 * "edg" is the edge label.
 * For streaming new edges:
 * 		- "new_src": whether the source node is a new node, never-before-seen.
 * 		- "new_dst": whether the destination node is a new node, never-before-seen.
 */
struct edge_label {
	//TODO: We hard-coded the value 4 because dymanic edge type is not allowed in the streaming setting.
	unsigned long src[4];
	unsigned long dst;
	unsigned long edg;
	int tme[4];
	int itr;
	bool new_src;
	bool new_dst;
};

typedef edge_label EdgeDataType;

/* Node itself remembers all its most-updated labels "lb" and times "tm".
 * "is_leaf": whether the node is a leaf node. (no incoming edges)
 */
struct node_label {
	unsigned long lb[4];
	int tm[4];
	bool is_leaf;
};

typedef node_label VertexDataType;

/* Each histogram element is now associated with the following information. 
 * 1. cnt: the count of that element in the streaming graph.
 * 2. r, beta, c: parameters to create hash values. r ~ Gamma(2, 1), c ~ Gamma(2, 1), beta ~ Uniform(0, 1)
 */
struct hist_elem {
	int cnt;
	double r[SKETCH_SIZE];
	double beta[SKETCH_SIZE];
	double c[SKETCH_SIZE]; 
};

std::default_random_engine r_generator;
std::default_random_engine c_generator;
std::default_random_engine beta_generator;
std::gamma_distribution<double> gamma_dist(2.0, 1.0);
std::uniform_real_distribution<double> uniform_dist(0.0, 1.0);

#endif