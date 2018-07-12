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

#include <fstream>

#include "include/def.hpp"
#include "include/helper.hpp"
#include "include/histogram.hpp"
#include "graphchi_basic_includes.hpp"
#include "logger/logger.hpp"
#include "wl.hpp"

using namespace graphchi;

graphchi_dynamicgraph_engine<VertexDataType, EdgeDataType> * dyngraph_engine;
std::string stream_file;

/*!
 * @brief A separate thread execute this function to stream graph from a file.
 */
void * dynamic_graph_reader(void * info) {
	logstream(LOG_DEBUG) << "Waiting to start streaming the graph..." << std::endl;
	usleep(100000);
	logstream(LOG_DEBUG) << "Streaming begins from file: " << stream_file << std::endl;

	/* Open the file for streaming. */
	FILE * f = fopen(stream_file.c_str(), "r");
	if (f == NULL) {
		logstream(LOG_ERROR) << "Unable to open the file for streaming: " << stream_file << ". Error code: " << strerror(errno) << std::endl;
	}
	assert(f != NULL);

	/* Reading the file. */
	vid_t from;
	vid_t to;
	EdgeDataType el;
	char s[1024];

	while(fgets(s, 1024, f) != NULL) {
		FIXLINE(s);
		/* Read next line. */
		char delims[] = ":\t ";
		unsigned char *t;
		char *k;

		k = strtok(s, delims);
		if (k == NULL)
			logstream(LOG_ERROR) << "Source ID does not exist." << std::endl;
		assert(k != NULL);
		from = atoi(k);

		k = strtok(NULL, delims);
		if (k == NULL)
			logstream(LOG_ERROR) << "Detination ID does not exist." << std::endl;
		assert(k != NULL);
		to = atoi(k);

		t = (unsigned char *)strtok(NULL, delims);
		if (t == NULL)
			logstream(LOG_ERROR) << "Source label does not exist." << std::endl;
		assert(t != NULL);
		el.prev = hash(t);
	    
		t = (unsigned char *)strtok(NULL, delims);
		if (t == NULL)
			logstream(LOG_ERROR) << "Destination label does not exist." << std::endl;
		assert (t != NULL);
		el.curr = hash(t);

		t = (unsigned char *)strtok(NULL, delims);
		if (t == NULL)
			logstream(LOG_ERROR) << "Edge label does not exist." << std::endl;
		assert (t != NULL);
		el.edge = hash(t);

		k = strtok(NULL, delims);
		if (k == NULL)
			logstream(LOG_ERROR) << "Time label does not exist." << std::endl;
		assert (k != NULL);
		el.orig_time = atoi(k);
		el.prev_time = el.orig_time;
		el.curr_time = el.orig_time;

#ifdef DEBUG
		k = strtok(NULL, delims);
		if (k != NULL)
			logstream(LOG_DEBUG) << "Extra info will be ignored." << std::endl;
#endif
		if (from == to) {
#ifdef DEBUG
			logstream(LOG_DEBUG) << "Ignoring edge because a self-loop is detected during streaming: " << from << "<->" << to <<std::endl;
#endif
			continue;
		}
		/* Add the new edge to the graph. */
		bool success = false;
		while (!success) {
			success = dyngraph_engine->add_edge(from, to, el);
		}
		/* Schedule the new nodes to be computed. */
		dyngraph_engine->add_task(from);
		dyngraph_engine->add_task(to);
#ifdef DEBUG
		logstream(LOG_DEBUG) << "Schedule new nodes: " << from << " and " << to << std::endl;
		logstream(LOG_DEBUG) << "Total number of nodes: " << dyngraph_engine->num_vertices() << std::endl;
#endif
	}

	fclose(f);
	/* After the file is closed, the engine will stop 4 iterations after the current iteration in which the addition is finished. */
	dyngraph_engine->finish_after_iters(4);

	return NULL;
}

int main(int argc, const char ** argv) {
	/* GraphChi initialization will read the command line arguments and the configuration file. */
	graphchi_init(argc, argv);

	/* Metrics object for keeping track of performance counters and other information. 
	 * Currently required. */
	metrics m("Streaming Extractor");
	global_logger().set_log_level(LOG_DEBUG);

	/* Parameters from command line. */
	std::string filename = get_option_string("file");
	int niters = get_option_int("niters", 20);
	bool scheduler = true;
	stream_file = get_option_string("stream_file");

	/* Process input file - if not already preprocessed */
	int nshards = convert_if_notexists<EdgeDataType>(filename, get_option_string("nshards", "auto"));

	/* Create the engine object. */
	dyngraph_engine = new graphchi_dynamicgraph_engine<VertexDataType, EdgeDataType>(filename, nshards, scheduler, m); 

	/* Start streaming thread */
	pthread_t strthread;
	int ret = pthread_create(&strthread, NULL, dynamic_graph_reader, NULL);
	assert(ret >= 0);

	/* Run the engine */
	WeisfeilerLehman program;
	dyngraph_engine->run(program, niters);

	// metrics_report(m);
	return 0;
}