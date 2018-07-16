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
#ifndef helper_hpp
#define helper_hpp

#include <cassert>
#include <cmath>
#include <cstdlib>
#include <string>
#include <unistd.h>

#include "logger/logger.hpp"
#include "def.hpp"

namespace graphchi {
	/*!
	 * @brief Deterministically hash character strings to a unique unsigned long integer.
	 *
	 */
	unsigned long hash(unsigned char *str) {
		unsigned long hash = 5381;
		int c;

		while (c = *str++)
			hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
		return hash;
	}

	/*!
	 * @brief Customized parse funtion to parse edge values from edgelist-formatted file.
	 *
	 */
	void parse(edge_label &x, const char *s) {
		char *ss = (char *) s;
		char delims[] = ":";
		unsigned char *t;
		char *k;

		x.itr = 0; /* At the beginning, itr count is always 0. */
		/* For base nodes, we will deal with them separately first, so we do not need to mark them new. */
		x.new_src = false;
		x.new_dst = false;
	
		t = (unsigned char *)strtok(ss, delims);
		if (t == NULL)
			logstream(LOG_FATAL) << "Source label does not exist." << std::endl;
		assert(t != NULL);
		x.src[0] = hash(t);
	
		t = (unsigned char *)strtok(NULL, delims);
		if (t == NULL)
			logstream(LOG_FATAL) << "Destination label does not exist." << std::endl;
		assert (t != NULL);
		x.dst = hash(t);

		t = (unsigned char *)strtok(NULL, delims);
		if (t == NULL)
			logstream(LOG_FATAL) << "Edge label does not exist." << std::endl;
		assert (t != NULL);
		x.edg = hash(t);

		k = strtok(NULL, delims);
		if (k == NULL)
			logstream(LOG_FATAL) << "Time label does not exist." << std::endl;
		assert (k != NULL);
		x.tme[0] = std::stoi(k);

		k = strtok(NULL, delims);
		if (k != NULL)
			logstream(LOG_FATAL) << "Extra info, if any, will be ignored." << std::endl;

		return;
	}

	bool compareEdges(struct edge_label a, struct edge_label b, int pos) {
		return a.tme[pos] < b.tme[pos];
	}
	/*!
	 * @brief This class is used to sort edge_label structs based on its "tme" value at position n.
	 */
	class EdgeSorter{
		int pos;
		
		public:
			EdgeSorter(int pos) {
				this->pos = pos;
			}
		bool operator()(struct edge_label a, struct edge_label b) const {
			return compareEdges(a, b, pos);
		}
	};

}

#endif