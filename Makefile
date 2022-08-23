api_serve:
	redoc-cli serve --watch docs/openapi.yaml
.PHONY: api_serve

api_serve_docker:
	docker run --rm -it -p 80:80 -v $(pwd)/docs:/usr/share/nginx/html:ro nginx
.PHONY: api_serve_docker

api_build:
	redoc-cli bundle docs/openapi.yaml
	
loadtest_build:
	cd docs/evaluation && R -e 'renv::status(); rmarkdown::render("load_test.Rmd")'
	