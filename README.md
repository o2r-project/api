# o2r Web API

Project description: [https://o2r.info](https://o2r.info)

## Basics

We're a research project, so _everything in this API and its documentation is subject to change_.
The "working" state should always be in the `master` branch, which is published online at [https://o2r.info/api](https://o2r.info/api), and [open pull requests](https://github.com/o2r-project/api/pulls) reflect features under development.

## API docs

This specification follows the [Open API 3.0.3 specification](https://en.wikipedia.org/wiki/OpenAPI_Specification).
It is written in [YAML](https://yaml.org/) and deployed automatically using ReDoc.
See the [ReDoc documentation](https://github.com/Redocly/redoc) for details.

### View

The docs are build dynamically based on `openapi.yml` when `index.html` is opened in a browser.
You can do this locally by starting a web browser in the `/docs` directory:

```bash
docker run --rm -it -v $(pwd)/docs:/usr/share/nginx/html:ro nginx
```

Then open http://localhost/index.html.

### Build

You can render the `openapi.yml` in this repository with [redoc-cli](https://github.com/Redocly/redoc/blob/master/cli/README.md) tool.
The output is a a zero-dependency static HTML file in your current directory.

```bash
#npm i -g redoc-cli

redoc-cli bundle docs/openapi.yml
```

:warning: This will not include our style changes!

Our combination of the `openapi.yml` and ReDoc's `redoc.standalone.js` will render a html which is then deployed via the `/docs` folder. Our script `redoc_theme.js` contains the actual ReDoc initialization command and makes a few style changes through  callback functions to correspond to our project.
The css rules which expand the core ReDoc style are in the `openapi_style.css` file.

### Web pages build

The pages at [https://o2r.info/api/](https://o2r.info/api/) are rendered client side (API docs) or are built locally by developers on relevant changes (load test docs).
The website is served from the directory `/docs`, which must be configured in the repository settings.

### Develop locally

You can serve the HTML page (without style changes!) and automatically re-rendering on changes with

```bash
redoc-cli serve --watch docs/openapi.yml
```
### PDF Generation

Note that for every commit on the `master` branch a new PDF document will be generated. This can quickly lead to many commits. 
So it is best to develop new features on other branches. 

## Load testing

This repository contains a collection of [R Markdown](https://rmarkdown.rstudio.com/) documents that can be used to evaluate the performance of the o2r reproducibility service.
See the directory `docs/evaluation` for R code and documentation for running load tests on the API and the user interface.

## License

The o2r Web API specification is licensed under [Creative Commons CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/), see file `LICENSE`.
To the extent possible under law, the people who associated CC0 with this work have waived all copyright and related or neighboring rights to this work.
This work is published from: Germany.
