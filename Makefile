serve:
	mkdocs serve

build:
	mkdocs build --clean

pdf: build
	wkhtmltopdf --version;
	# fix protocol relative URLs, see https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2713
	find site/ -type f -name '*.html' | xargs sed -i 's|href="//|href="https://|g'
	find site/ -type f -name '*.html' | xargs sed -i 's|src="//|src="https://|g'
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
	file://$(shell pwd)/site/compendium/link/index.html \
	file://$(shell pwd)/site/job/index.html \
	file://$(shell pwd)/site/search/index.html \
	file://$(shell pwd)/site/shipment/index.html \
	file://$(shell pwd)/site/user/index.html \
	o2r-web-api.pdf