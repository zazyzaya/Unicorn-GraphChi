define preprocess
	mkdir -p $(5)_data
	python preprocess-ss.py $(1) $(2) $(3) $(4) all.tsv base-$(5)-$(1).txt stream-$(5)-$(1).txt
	mv base-$(5)-$(1).txt $(5)_data
	mv stream-$(5)-$(1).txt $(5)_data
endef

youtube:
	$(call preprocess,0,1,2,3,youtube)
	$(call preprocess,4,5,6,7,youtube)
	$(call preprocess,8,9,10,11,youtube)
	$(call preprocess,12,13,14,15,youtube)
	$(call preprocess,16,17,18,19,youtube)
	$(call preprocess,20,21,22,23,youtube)

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