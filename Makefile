.PHONY: help all local deploy install clean build test sync post-test

SITENAME=juancanham.com
TARGET=/var/www/html/simpler-dash/
linkchecker=linkchecker --check-extern
ICON=favicon.jpg

help:
	@echo 'all: local deploy'
	@echo 'local: install clean build'
	@echo 'deploy: test sync post-test'

all: local deploy
local: install build 
deploy: test sync post-test

install:
	pip install -r requirements.txt

clean:
	rm -r dist/* || true

build: clean
	cp -v index.html background.jpg dist/
	cp -rv css/ webfonts/ dist/
	for file in ToS Privacy; do markdown_py $${file}.md > dist/$${file} ; done
	convert $(ICON) -define icon:auto-resize=64,48,32,16 dist/favicon.ico

test:
	$(linkchecker) dist/index.html

sync:
	rsync -vr --delete --exclude=".*" dist/ $(TARGET)

post-test:
	$(linkchecker) https://$(SITENAME)
	wget http://${SITENAME} -O /dev/null



