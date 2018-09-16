youtube:
	number=0 ; while [ $$number -le 99 ] ; do \
		sed -n '1,300p;301q' youtube_data_v2/stream_train/stream-youtube-v2-$$number.txt >> youtube_data_v2/base_train/base-youtube-v2-$$number.txt ; \
		sed -i '1,300d' youtube_data_v2/stream_train/stream-youtube-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

gmail:
	number=100 ; while [ $$number -le 199 ] ; do \
		sed -n '1,300p;301q' gmail_data_v2/stream_train/stream-gmail-v2-$$number.txt >> gmail_data_v2/base_train/base-gmail-v2-$$number.txt ; \
		sed -i '1,300d' gmail_data_v2/stream_train/stream-gmail-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

vgame:
	number=200 ; while [ $$number -le 299 ] ; do \
		sed -n '1,300p;301q' vgame_data_v2/stream_train/stream-vgame-v2-$$number.txt >> vgame_data_v2/base_train/base-vgame-v2-$$number.txt ; \
		sed -i '1,300d' vgame_data_v2/stream_train/stream-vgame-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

attack:
	number=300 ; while [ $$number -le 399 ] ; do \
		sed -n '1,300p;301q' attack_data_v2/stream_train/stream-attack-v2-$$number.txt >> attack_data_v2/base_train/base-attack-v2-$$number.txt ; \
		sed -i '1,300d' attack_data_v2/stream_train/stream-attack-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

download:
	number=400 ; while [ $$number -le 499 ] ; do \
		sed -n '1,300p;301q' download_data_v2/stream_train/stream-download-v2-$$number.txt >> download_data_v2/base_train/base-download-v2-$$number.txt ; \
		sed -i '1,300d' download_data_v2/stream_train/stream-download-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done

cnn:
	number=500 ; while [ $$number -le 599 ] ; do \
		sed -n '1,300p;301q' cnn_data_v2/stream_train/stream-cnn-v2-$$number.txt >> cnn_data_v2/base_train/base-cnn-v2-$$number.txt ; \
		sed -i '1,300d' cnn_data_v2/stream_train/stream-cnn-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done
