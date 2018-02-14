serve:
	sudo mkdocs serve

build:
	mkdocs build --clean

pdf: build
	wkhtmltopdf --margin-top 20mm --no-background --javascript-delay 5000 \
	file://$(shell pwd)/site/index.html \
	file://$(shell pwd)/site/compendium/view/index.html \
	file://$(shell pwd)/site/compendium/candidate/index.html \
	file://$(shell pwd)/site/compendium/files/index.html \
	file://$(shell pwd)/site/compendium/delete/index.html \
	file://$(shell pwd)/site/compendium/upload/index.html \
	file://$(shell pwd)/site/compendium/public_share/index.html \
	file://$(shell pwd)/site/compendium/download/index.html \
	file://$(shell pwd)/site/compendium/metadata/index.html \
	file://$(shell pwd)/site/compendium/substitute/index.html \
	file://$(shell pwd)/site/job/index.html \
	file://$(shell pwd)/site/search/index.html \
	file://$(shell pwd)/site/shipment/index.html \
	file://$(shell pwd)/site/user/index.html \
	o2r-web-api.pdf