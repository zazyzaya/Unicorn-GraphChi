define preprocess
	mkdir -p $(5)_data
	python preprocess-ss.py $(1) $(2) $(3) $(4) all.tsv base-$(5)-$(1).txt stream-$(5)-$(1).txt
	mv base-$(5)-$(1).txt $(5)_data
	mv stream-$(5)-$(1).txt $(5)_data
endef

youtube:
	mkdir -p youtube_data
	number=0 ; while [ $$number -le 96 ] ; do \
		start=`expr $$number + 1` ; \
		end=`expr $$number + 3` ; \
		python preprocess-ss.py $$number $$number $$start $$end all.tsv base-youtube-$$number.txt stream-youtube-$$number.txt ; \
		mv base-youtube-$$number.txt youtube_data ; \
		mv stream-youtube-$$number.txt youtube_data ; \
		number=`expr $$number + 4` ; \
	done

youtube_v2:
	mkdir -p youtube_data_v2
	number=0 ; while [ $$number -le 99 ] ; do \
		python preprocess-ss-v2.py $$number all.tsv base-youtube-v2-$$number.txt stream-youtube-v2-$$number.txt ; \
		mv base-youtube-v2-$$number.txt youtube_data_v2 ; \
		mv stream-youtube-v2-$$number.txt youtube_data_v2 ; \
		number=`expr $$number + 1` ; \
	done

gmail:
	$(call preprocess,100,101,102,103,gmail)

vgame:
	$(call preprocess,200,201,202,203,vgame)

attack:
	$(call preprocess,300,301,302,303,attack)

download:
	$(call preprocess,400,401,402,403,download)

cnn:
	$(call preprocess,500,501,502,503,cnn)

all: youtube gmail vgame attack download cnn

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
	python preprocess-camflow.py 0 attack_edges_wget_1.txt wget_data/test/base-wget-attack.txt wget_data/test/stream-wget-attack.txt







