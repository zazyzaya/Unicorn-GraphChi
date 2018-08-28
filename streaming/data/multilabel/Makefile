wget_train:
	mkdir -p wget_data_multilabel
	cd wget_data_multilabel && mkdir -p train
	number=0 ; while [ $$number -le 99 ] ; do \
		python preprocess-w3c.py ../../../../prov-ips/streamspot/experiment/wget/data/wget-normal-$$number.log wget-normal-preprocess-$$number.txt ; \
		python parse-w3c.py wget-normal-preprocess-$$number.txt wget_data_multilabel/train/base-wget-$$number.txt wget_data_multilabel/train/stream-wget-$$number.txt ; \
		rm error.log ; \
		rm wget-normal-preprocess-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

wget_test:
	mkdir -p wget_data_multilabel
	cd wget_data_multilabel && mkdir -p test
	number=0 ; while [ $$number -le 1 ] ; do \
		python preprocess-w3c.py ../../../../prov-ips/streamspot/experiment/wget/data/wget-attack-$$number.log wget-attack-preprocess-$$number.txt ; \
		python parse-w3c.py wget-attack-preprocess-$$number.txt wget_data_multilabel/test/base-wget-attack-$$number.txt wget_data_multilabel/test/stream-wget-attack-$$number.txt ; \
		rm error.log ; \
		rm wget-attack-preprocess-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done
