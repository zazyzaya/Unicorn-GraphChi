#ifndef EXTERN_HPP
#define EXTERN_HPP

#include <pthread.h>

namespace std {
	extern pthread_barrier_t graph_barrier;
    extern int stop;
}

#endif