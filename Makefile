api_serve:
	redoc-cli serve --watch docs/openapi.yaml

api_build:
	redoc-cli bundle docs/openapi.yaml
	
loadtest_build:
	# ...TODO