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

sdebug: CPPFLAGS += -DSKETCH_SIZE=2000 -DK_HOPS=3 -DDEBUG -g
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

run_toy:
	cd ../../data && mkdir -p train_toy
	number=0 ; while [ $$number -le 99 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/toy_data/base_train/base-toy-$$number.txt niters 10000 stream_file ../../data/toy_data/stream_train/stream-toy-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_toy/sketch-toy-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/toy_data/base_train/base-toy-$$number.txt.* ; \
		rm -rf ../../data/toy_data/base_train/base-toy-$$number.txt_* ; \
		number=`expr $$number + 4` ; \
	done
	cd ../../data && mkdir -p test_toy
	number=300 ; while [ $$number -le 399 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/toy_data/base_test/base-attack-$$number.txt niters 10000 stream_file ../../data/toy_data/stream_test/stream-attack-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/test_toy/sketch-attack-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/toy_data/base_test/base-attack-$$number.txt.* ; \
		rm -rf ../../data/toy_data/base_test/base-attack-$$number.txt_* ; \
		number=`expr $$number + 16` ; \
	done
	mv ../../data/train_toy/sketch-toy-20.txt ../../data/test_toy/
	mv ../../data/train_toy/sketch-toy-80.txt ../../data/test_toy/

run_youtube:
	cd ../../data && mkdir -p train_streamspot
	number=0 ; while [ $$number -le 99 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/youtube_data/base_train/base-youtube-$$number.txt niters 10000 stream_file ../../data/youtube_data/stream_train/stream-youtube-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_streamspot/sketch-youtube-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/youtube_data/base_train/base-youtube-$$number.txt.* ; \
		rm -rf ../../data/youtube_data/base_train/base-youtube-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_gmail:
	cd ../../data && mkdir -p train_streamspot
	number=100 ; while [ $$number -le 199 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/gmail_data/base_train/base-gmail-$$number.txt niters 10000 stream_file ../../data/gmail_data/stream_train/stream-gmail-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_streamspot/sketch-gmail-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/gmail_data/base_train/base-gmail-$$number.txt.* ; \
		rm -rf ../../data/gmail_data/base_train/base-gmail-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_vgame:
	cd ../../data && mkdir -p train_streamspot
	number=200 ; while [ $$number -le 299 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/vgame_data/base_train/base-vgame-$$number.txt niters 10000 stream_file ../../data/vgame_data/stream_train/stream-vgame-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_streamspot/sketch-vgame-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/vgame_data/base_train/base-vgame-$$number.txt.* ; \
		rm -rf ../../data/vgame_data/base_train/base-vgame-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_download:
	cd ../../data && mkdir -p train_streamspot
	number=400 ; while [ $$number -le 499 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/download_data/base_train/base-download-$$number.txt niters 10000 stream_file ../../data/download_data/stream_train/stream-download-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_streamspot/sketch-download-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/download_data/base_train/base-download-$$number.txt.* ; \
		rm -rf ../../data/download_data/base_train/base-download-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_cnn:
	cd ../../data && mkdir -p train_streamspot
	number=500 ; while [ $$number -le 599 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/cnn_data/base_train/base-cnn-$$number.txt niters 10000 stream_file ../../data/cnn_data/stream_train/stream-cnn-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/train_streamspot/sketch-cnn-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/cnn_data/base_train/base-cnn-$$number.txt.* ; \
		rm -rf ../../data/cnn_data/base_train/base-cnn-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_attack:
	cd ../../data && mkdir -p test_streamspot
	number=300 ; while [ $$number -le 399 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/attack_data/base_train/base-attack-$$number.txt niters 10000 stream_file ./../data/attack_data/stream_train/stream-attack-$$number.txt decay 500 lambda 0.02 interval 500 sketch_file ../../data/test_streamspot/sketch-attack-$$number.txt chunkify 1 chunk_size 50 ; \
		rm -rf ../../data/attack_data/base_train/base-attack-$$number.txt.* ; \
		rm -rf ../../data/attack_data/base_train/base-attack-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done
	mv ../../data/train_streamspot/sketch-youtube-2.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-8.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-13.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-16.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-20.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-23.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-29.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-35.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-38.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-40.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-43.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-48.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-51.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-56.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-59.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-64.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-67.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-70.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-75.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-79.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-84.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-86.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-89.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-92.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-youtube-97.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-101.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-106.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-109.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-112.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-114.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-117.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-124.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-127.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-129.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-136.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-139.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-142.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-144.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-148.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-153.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-158.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-161.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-165.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-169.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-171.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-177.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-180.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-186.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-195.txt ../../data/test_streamspot/
	mv ../../data/train_streamspot/sketch-gmail-198.txt ../../data/test_streamspot/



run_wget:
	cd ../../data && mkdir -p train_wget
	number=0 ; while [ $$number -le 109 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/benign/base/base-wget-$$number.txt niters 10000 stream_file ./../data/benign/stream/stream-wget-$$number.txt decay 100 lambda 0.02 interval 200 sketch_file ../../data/train_wget/sketch-wget-$$number.txt chunkify 1 chunk_size 5 ; \
		rm -rf ../../data/benign/base/base-wget-$$number.txt.* ; \
		rm -rf ../../data/benign/base/base-wget-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done

run_wget_baseline_attack:
	cd ../../data && mkdir -p test_wget_baseline
	number=0 ; while [ $$number -le 24 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/attack_baseline/base/base-wget-attack-baseline-$$number.txt niters 10000 stream_file ./../data/attack_baseline/stream/stream-wget-attack-baseline-$$number.txt decay 100 lambda 0.02 interval 200 sketch_file ../../data/test_wget_baseline/sketch-wget-attack-baseline-$$number.txt chunkify 1 chunk_size 5 ; \
		rm -rf ../../data/attack_baseline/base/base-wget-attack-baseline-$$number.txt.* ; \
		rm -rf ../../data/attack_baseline/base/base-wget-attack-baseline-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done
	cp ../../data/train_wget/sketch-wget-6.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-13.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-23.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-46.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-53.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-68.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-79.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-84.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-92.txt ../../data/test_wget_baseline
	cp ../../data/train_wget/sketch-wget-105.txt ../../data/test_wget_baseline

run_wget_interval_attack:
	cd ../../data && mkdir -p test_wget_interval
	number=0 ; while [ $$number -le 24 ] ; do \
		bin/streaming/main filetype edgelist file ../../data/attack_interval/base/base-wget-attack-interval-$$number.txt niters 10000 stream_file ./../data/attack_interval/stream/stream-wget-attack-interval-$$number.txt decay 100 lambda 0.02 interval 200 sketch_file ../../data/test_wget_interval/sketch-wget-attack-interval-$$number.txt chunkify 1 chunk_size 5 ; \
		rm -rf ../../data/attack_interval/base/base-wget-attack-interval-$$number.txt.* ; \
		rm -rf ../../data/attack_interval/base/base-wget-attack-interval-$$number.txt_* ; \
		number=`expr $$number + 1` ; \
	done
	mv ../../data/train_wget/sketch-wget-6.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-13.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-23.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-46.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-53.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-68.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-79.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-84.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-92.txt ../../data/test_wget_interval
	mv ../../data/train_wget/sketch-wget-105.txt ../../data/test_wget_interval
