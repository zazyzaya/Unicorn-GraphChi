define preprocess
	mkdir -p $(5)_data
	python preprocess-ss.py $(1) $(2) $(3) $(4) all.tsv base-$(5)-$(1).txt stream-$(5)-$(1).txt
	mv base-$(5)-$(1).txt $(5)_data
	mv stream-$(5)-$(1).txt $(5)_data
endef

youtube:
	mkdir -p youtube_data
	number=0 ; while [[ $$number -le 96 ]] ; do \
		python preprocess-ss.py $$number $$number $$(( $(number) + 1 )) $$(( $(number) + 3 )) all.tsv base-youtube-$$number.txt stream-youtube-$$number.txt ; \
		mv base-youtube-$$number.txt youtube_data ; \
		mv stream-$youtube-$$number.txt youtube_data ; \
		((number = number + 4)) ; \
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