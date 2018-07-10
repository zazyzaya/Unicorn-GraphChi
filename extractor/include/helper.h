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
#ifndef helper_h
#define helper_h

#include <string>
#include <cassert>

#include "logger/logger.hpp"
#include "def.h"

namespace graphchi {

	/*!
	 * @brief Customized parse funtion to parse edge values from edgelist-formatted file.
	 *
	 */
	void parse(edge_labels &x, const char * s) {
	    char * ss = (char *) s;
	    char delims[] = ":";
	    char * t;
	    
	    t = strtok(ss, delims);
	    if (t == NULL)
	        logstream(LOG_FATAL) << "Source label does not exist." << std::endl;
	    assert(t != NULL);
	    x.prev = std::string(t);
	    
	    t = strtok(NULL, delims);
	    if (t == NULL)
	        logstream(LOG_FATAL) << "Destination label does not exist." << std::endl;
	    assert (t != NULL);
	    x.curr = atoi(t);

	    t = strtok(NULL, delims);
	    if (t == NULL)
	        logstream(LOG_FATAL) << "Edge label does not exist." << std::endl;
	    assert (t != NULL);
	    x.edge = atoi(t);

	    t = strtok(NULL, delims);
	    if (t != NULL)
	        logstream(LOG_FATAL) << "Extra info will be ignored." << std::endl;
	    
	    return;
	}

}

#endif