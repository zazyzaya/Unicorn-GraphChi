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

struct edge_label {
	unsigned long prev;
	unsigned long curr;
	unsigned long edge;
	int time;
};

typedef unsigned long VertexDataType; /* VertexDataType stores only the original label of the vertex. */

/* edge_label sttuct serves multiple purposes.
 * 1. "prev":
 * 		- Initalizes source vertex label at the beginning.
 * 		- Stores the label of the previous iteration of source vertex (so destination vertex can use the label to compute its new label) 
 * 2. "curr":
 * 		- Initalizes destination vertex label at the beginning.
 * 		- Stores the label for the current iteration of source vertex (so we can swap "prev" and "curr" in the next iteration)
 * 3. "edge" stores the original edge label of an edge. This value does not changes with iterations.
 * 4. "time" stores the timestamp of the edge.
 * "prev" and "curr" are needed because we simulate synchronous execution on asynchronous GraphChi graph processing system.
 */
typedef edge_label EdgeDataType;

struct {
	bool operator()(struct edge_label a, struct edge_label b) {
		return a.time < b.time;
	}
} compareEdges;


#endif