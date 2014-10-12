default: cedar cedar-14

cedar: dist/cedar/gdal-1.11.1-1.tar.gz dist/cedar/proj-4.8.0-1.tar.gz

cedar-14: dist/cedar-14/gdal-1.11.1-1.tar.gz dist/cedar-14/proj-4.8.0-1.tar.gz

dist/cedar/gdal-1.11.1-1.tar.gz: gdal-cedar
	docker cp $<:/tmp/gdal-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv gdal-cedar.tar.gz $@

dist/cedar/proj-4.8.0-1.tar.gz: gdal-cedar
	docker cp $<:/tmp/proj-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv proj-cedar.tar.gz $@

dist/cedar-14/gdal-1.11.1-1.tar.gz: gdal-cedar-14
	docker cp $<:/tmp/gdal-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv gdal-cedar-14.tar.gz $@

dist/cedar-14/proj-4.8.0-1.tar.gz: gdal-cedar-14
	docker cp $<:/tmp/proj-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv proj-cedar-14.tar.gz $@

clean:
	rm -rf src/ cedar*/*.sh dist/ gdal-cedar*/*.tar.gz
	-docker rm gdal-cedar
	-docker rm gdal-cedar-14

src/gdal.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://download.osgeo.org/gdal/1.11.1/gdal-1.11.1.tar.gz -o $@

src/proj-datumgrid.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz -o $@

src/proj.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://download.osgeo.org/proj/proj-4.8.0.tar.gz -o $@

.PHONY: cedar-stack

cedar-stack: cedar-stack/cedar.sh
	@(docker images -q mojodna/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t mojodna/$@ $@

cedar-stack/cedar.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar.sh -o $@

.PHONY: cedar-14-stack

cedar-14-stack: cedar-14-stack/cedar-14.sh
	@(docker images -q mojodna/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t mojodna/$@ $@

cedar-14-stack/cedar-14.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar-14.sh -o $@

.PHONY: gdal-cedar

gdal-cedar: cedar-stack gdal-cedar/gdal.tar.gz gdal-cedar/proj-datumgrid.tar.gz gdal-cedar/proj.tar.gz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

gdal-cedar/gdal.tar.gz: src/gdal.tar.gz
	ln -f $< $@

gdal-cedar/proj-datumgrid.tar.gz: src/proj-datumgrid.tar.gz
	ln -f $< $@

gdal-cedar/proj.tar.gz: src/proj.tar.gz
	ln -f $< $@

.PHONY: gdal-cedar-14

gdal-cedar-14: cedar-14-stack gdal-cedar-14/gdal.tar.gz gdal-cedar-14/proj-datumgrid.tar.gz gdal-cedar-14/proj.tar.gz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

gdal-cedar-14/gdal.tar.gz: src/gdal.tar.gz
	ln -f $< $@

gdal-cedar-14/proj-datumgrid.tar.gz: src/proj-datumgrid.tar.gz
	ln -f $< $@

gdal-cedar-14/proj.tar.gz: src/proj.tar.gz
	ln -f $< $@
