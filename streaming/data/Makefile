youtube_v2:
	mkdir -p youtube_data_v2
	number=0 ; while [ $$number -le 99 ] ; do \
		python preprocess-ss-v2.py $$number all.tsv base-youtube-v2-$$number.txt stream-youtube-v2-$$number.txt ; \
		mv base-youtube-v2-$$number.txt youtube_data_v2 ; \
		mv stream-youtube-v2-$$number.txt youtube_data_v2 ; \
		number=`expr $$number + 1` ; \
	done

attack_v2:
	mkdir -p attack_data_v2
	number=300 ; while [ $$number -le 304 ] ; do \
		python preprocess-ss-v2.py $$number all.tsv base-attack-v2-$$number.txt stream-attack-v2-$$number.txt ; \
		mv base-attack-v2-$$number.txt attack_data_v2 ; \
		mv stream-attack-v2-$$number.txt attack_data_v2 ; \
		number=`expr $$number + 1` ; \
	done

wget:
	mkdir -p wget_data
	cd wget_data && mkdir -p train
	number=0 ; while [ $$number -le 99 ] ; do \
		python preprocess-camflow.py $$number train_edges_wget.txt wget_data/train/base-wget-$$number.txt wget_data/train/stream-wget-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

wget_attack:
	mkdir -p wget_data
	cd wget_data && mkdir -p test
	python preprocess-camflow.py 0 attack_edges_wget.txt wget_data/test/base-wget-attack.txt wget_data/test/stream-wget-attack.txt







