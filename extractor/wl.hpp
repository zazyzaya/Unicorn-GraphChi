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
#include <thread>
#include <mutex>
#include <vector>

#include "graphchi_basic_includes.hpp"
#include "logger/logger.hpp"
#include "include/def.hpp"
#include "include/helper.hpp"

namespace graphchi {

	/**
	  * GraphChi programs need to subclass GraphChiProgram<vertex-type, edge-type> 
	  * class. The main logic is usually in the update function.
	  */
	struct WeisfeilerLehman : public GraphChiProgram<VertexDataType, EdgeDataType> {
		/* Get the singleton of histogram map. */
		Histogram* hist = Histogram::get_instance();

		/* Locks needed for updating histogram map. */
		std::mutex histogram_map_lock;

		/**
		 *  Vertex update function.
		 */
		void update(graphchi_vertex<VertexDataType, EdgeDataType> &vertex, graphchi_context &gcontext) {
			/* Detected isolated vertex in the graph.
			 * The following code runs only in debugging mode to discover dirty data.
			 */
#ifdef DEBUG
			if (vertex.num_edges() <= 0) {
				logstream(LOG_DEBUG) << "Isolated vertex #"<<  vertex.id() <<" detected." << std::endl;
				return;
			}
#endif
			/* Since we require synchronous updates, we define:
			 * 1. Odd-numbered iterations: swap values between "curr" and "prev" on edges.
			 * 2. Even-numbered iterations: update "curr" from "prev". 
			 */
			if (gcontext.iteration == 0) {
				/* On first iteration, initialize vertex label.
				 * This vertex label is its original label and should not be overwritten by later iterations.
				 */
				/* The "orig" of the node_label can be obtained from any outedge (from "prev") or inedge (from "curr") */
				struct node_label nl;
				nl.time = 0;

				graphchi_edge<EdgeDataType> * edge = vertex.random_outedge();
				if (edge == NULL) {
					/* If a vertex does not have any outedge, it can get its original label from any of its inedge, which it must have at least one inedge. */
					edge = vertex.inedge(0); /* Use the first inedge to get its original label. */
					nl.orig = edge->get_data().curr;
				} else
					nl.orig = edge->get_data().prev;
				vertex.set_data(nl);

				/* Populate histogram map. */
				histogram_map_lock.lock();
				hist->insert_label(nl.orig);
				histogram_map_lock.unlock();
#ifdef DEBUG
				logstream(LOG_DEBUG) << "The original label of vertex #" << vertex.id() << " is: " << nl.orig << std::endl;
#endif
			} else if (gcontext.iteration == 1) {
				/* During this iteration, we include edge labels when relabeling. */
				
			}
		}
		
		/**
		 * Called before an iteration starts.
		 */
		void before_iteration(int iteration, graphchi_context &gcontext) {
		}
	    
		/**
		 * Called after an iteration has finished.
		 */
		void after_iteration(int iteration, graphchi_context &gcontext) {
		}
		
		/**
		 * Called before an execution interval is started.
		 */
		void before_exec_interval(vid_t window_st, vid_t window_en, graphchi_context &gcontext) {        
		}
		
		/**
		 * Called after an execution interval has finished.
		 */
		void after_exec_interval(vid_t window_st, vid_t window_en, graphchi_context &gcontext) {        
		}
		
	};

}