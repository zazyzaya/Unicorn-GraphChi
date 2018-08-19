INCFLAGS = -I/usr/local/include/ -I./src/

CPP = g++-4.9
CPPFLAGS = -std=c++11 -g -O3 $(INCFLAGS)  -fopenmp -Wall -Wno-strict-aliasing -lpthread
LINKERFLAGS = -lz
DEBUGFLAGS = -g -ggdb $(INCFLAGS)
HEADERS=$(shell find . -name '*.hpp')


all: apps tests 
apps: example_apps/connectedcomponents example_apps/pagerank example_apps/pagerank_functional example_apps/communitydetection example_apps/unionfind_connectedcomps example_apps/stronglyconnectedcomponents example_apps/trianglecounting example_apps/randomwalks example_apps/minimumspanningforest
als: example_apps/matrix_factorization/als_edgefactors  example_apps/matrix_factorization/als_vertices_inmem
tests: tests/basic_smoketest tests/bulksync_functional_test tests/dynamicdata_smoketest tests/test_dynamicedata_loader

echo:
	echo $(HEADERS)
clean:
	@rm -rf bin/*
	cd toolkits/collaborative_filtering/; make clean; cd ../../
	cd toolkits/parsers/; make clean; cd ../../
	cd toolkits/graph_analytics/; make clean; cd ../../

blocksplitter: src/preprocessing/blocksplitter.cpp $(HEADERS)
	$(CPP) $(CPPFLAGS) src/preprocessing/blocksplitter.cpp -o bin/blocksplitter $(LINKERFLAGS)

sharder_basic: src/preprocessing/sharder_basic.cpp $(HEADERS)
	@mkdir -p bin
	$(CPP) $(CPPFLAGS) src/preprocessing/sharder_basic.cpp -o bin/sharder_basic $(LINKERFLAGS)

example_apps/% : example_apps/%.cpp $(HEADERS)
	@mkdir -p bin/$(@D)
	$(CPP) $(CPPFLAGS) -Iexample_apps/ $@.cpp -o bin/$@ $(LINKERFLAGS) 

extractor/% : extractor/%.cpp $(HEADERS)
	@mkdir -p bin/$(@D)
	$(CPP) $(CPPFLAGS) -Iextractor/ $@.cpp -o bin/$@ $(LINKERFLAGS)

edebug: CPPFLAGS += -DDEBUG -g
edebug: extractor/main

streaming/% : streaming/%.cpp $(HEADERS)
	@mkdir -p bin/$(@D)
	$(CPP) $(CPPFLAGS) -Istreaming/ $@.cpp -o bin/$@ $(LINKERFLAGS)

sdebug: CPPFLAGS += -DDEBUG -g
sdebug: streaming/main


myapps/% : myapps/%.cpp $(HEADERS)
	@mkdir -p bin/$(@D)
	$(CPP) $(CPPFLAGS) -Imyapps/ $@.cpp -o bin/$@ $(LINKERFLAGS)

tests/%: src/tests/%.cpp $(HEADERS)
	@mkdir -p bin/$(@D)
	$(CPP) $(CPPFLAGS) src/$@.cpp -o bin/$@	$(LINKERFLAGS)


graphlab_als: example_apps/matrix_factorization/graphlab_gas/als_graphlab.cpp
	$(CPP) $(CPPFLAGS) example_apps/matrix_factorization/graphlab_gas/als_graphlab.cpp -o bin/graphlab_als $(LINKERFLAGS)

cf:
	cd toolkits/collaborative_filtering/; bash ./test_eigen.sh; 
	if [ $$? -ne 0 ]; then exit 1; fi
	cd toolkits/collaborative_filtering/; make 
cf_test:
	cd toolkits/collaborative_filtering/; make test; 
cfd:
	cd toolkits/collaborative_filtering/; make -f Makefile.debug

parsers:
	cd toolkits/parsers/; make
parsersd:
	cd toolkits/parsers/; make -f Makefile.debug
ga:
	cd toolkits/graph_analytics/; make
ta:
	cd toolkits/text_analysis/; make

docs: */**
	doxygen conf/doxygen/doxygen.config

run_youtube:
	number=92 ; while [ $$number -le 96 ] ; do \
		bin/streaming/main filetype edgelist file streaming/data/youtube_data/base-youtube-$$number.txt niters 10000 stream_file streaming/data/youtube_data/stream-youtube-$$number.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/train-data/sketch-youtube-$$number.txt chunkify 1 chunk_size 20 ; \
		rm -rf streaming/data/youtube_data/base-youtube-$$number.txt.* ; \
		rm -rf streaming/data/youtube_data/base-youtube-$$number.txt_* ; \
		number=`expr $$number + 4` ; \
	done
	
run_gmail:
	bin/streaming/main filetype edgelist file streaming/data/gmail_data/base-gmail-100.txt niters 10000 stream_file streaming/data/gmail_data/stream-gmail-100.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/train-data/sketch-gmail-100.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/gmail_data/base-gmail-100.txt.*
	rm -rf streaming/data/gmail_data/base-gmail-100.txt_*

run_vgame:
	bin/streaming/main filetype edgelist file streaming/data/vgame_data/base-vgame-200.txt niters 10000 stream_file streaming/data/vgame_data/stream-vgame-200.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/train-data/sketch-vgame-200.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/vgame_data/base-vgame-200.txt.*
	rm -rf streaming/data/vgame_data/base-vgame-200.txt_*

run_download:
	bin/streaming/main filetype edgelist file streaming/data/download_data/base-download-400.txt niters 10000 stream_file streaming/data/download_data/stream-download-400.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/train-data/sketch-download-400.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/download_data/base-download-400.txt.*
	rm -rf streaming/data/download_data/base-download-400.txt_*

run_cnn:
	bin/streaming/main filetype edgelist file streaming/data/cnn_data/base-cnn-500.txt niters 10000 stream_file streaming/data/cnn_data/stream-cnn-500.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/train-data/sketch-cnn-500.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/cnn_data/base-cnn-500.txt.*
	rm -rf streaming/data/cnn_data/base-cnn-500.txt_*

run_attack:
	bin/streaming/main filetype edgelist file streaming/data/attack_data/base-attack-300.txt niters 10000 stream_file streaming/data/attack_data/stream-attack-300.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/test-data/sketch-attack-300.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/attack_data/base-attack-300.txt.*
	rm -rf streaming/data/attack_data/base-attack-300.txt_*

run_validate:
	bin/streaming/main filetype edgelist file streaming/data/youtube_data/base-youtube-88.txt niters 10000 stream_file streaming/data/youtube_data/stream-youtube-88.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/test-data/sketch-youtube-88.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/youtube_data/base-youtube-88.txt.*
	rm -rf streaming/data/youtube_data/base-youtube-88.txt_*
	bin/streaming/main filetype edgelist file streaming/data/youtube_data/base-youtube-96.txt niters 10000 stream_file streaming/data/youtube_data/stream-youtube-96.txt decay 100 lambda 0.02 interval 5000 sketch_file streaming/analyze/test-data/sketch-youtube-96.txt chunkify 1 chunk_size 20
	rm -rf streaming/data/youtube_data/base-youtube-96.txt.*
	rm -rf streaming/data/youtube_data/base-youtube-96.txt_*

run_all: run_youtube run_gmail run_vgame run_download run_cnn run_attack run_validate


	

	
