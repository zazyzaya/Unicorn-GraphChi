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

#include <iostream>

#include "include/def.hpp"
#include "include/helper.hpp"
#include "include/histogram.hpp"
#include "graphchi_basic_includes.hpp"
#include "logger/logger.hpp"
#include "wl.hpp"

using namespace graphchi;

int main(int argc, const char ** argv) {
	/* GraphChi initialization will read the command line
     arguments and the configuration file. */
    graphchi_init(argc, argv);

    /* Metrics object for keeping track of performance counters
     and other information. Currently required. */
    metrics m("Extractor");
    return 0;
}