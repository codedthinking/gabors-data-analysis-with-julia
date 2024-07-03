
data: download.zip
	unzip -o $<
download.zip:
	curl -Lo $@ https://osf.io/download/9gw4a/