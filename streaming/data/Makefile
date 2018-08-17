define preprocess
	mkdir -p $(5)_data
	python preprocess-ss.py $(1) $(2) $(3) $(4) all.tsv base-$(5)-$(1).txt stream-$(5)-$(1).txt
	mv base-$(5)-$(1).txt $(5)_data
	mv stream-$(5)-$(1).txt $(5)_data
endef

youtube:
	mkdir -p youtube_data
	NUMBER=0 ; while [ "$NUMBER" -le "96" ] ; do \
		START=`expr $NUMBER + 1` ; \
		END=`expr $NUMBER + 3` ; \
		python preprocess-ss.py $NUMBER $NUMBER $START $END all.tsv base-youtube-$NUMBER.txt stream-youtube-$NUMBER.txt ; \
		mv base-youtube-$NUMBER.txt youtube_data ; \
		mv stream-$youtube-$NUMBER.txt youtube_data ; \
		NUMBER=`expr $NUMBER + 4` ; \
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