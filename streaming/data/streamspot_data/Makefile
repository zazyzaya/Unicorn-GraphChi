youtube:
	number=0 ; while [ $$number -le 99 ] ; do \
		sed '1,300p;301q' youtube_data_v2/stream_train/stream-youtube-v2-$$number.txt >> youtube_data_v2/base_train/base-youtube-v2-$$number.txt ; \
		sed -i '1,300d' youtube_data_v2/stream_train/stream-youtube-v2-$$number.txt ; \
		number=`expr $$number + 1` ; \
	done
