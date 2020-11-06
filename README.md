# o2r Web API

Project description: [https://o2r.info](https://o2r.info)

## Basics

We're a research project, so _everything in this API and its documentation is subject to change_.
The "working" state should always be in the `master` branch, which is published online at [https://o2r.info/api](https://o2r.info/api), and [open pull requests](https://github.com/o2r-project/api/pulls) reflect features under development.

## Build

This specification is written in [YAML](https://yaml.org/) and deployed automatically using ReDoc. There is also a [JSON version](https://www.json.org/json-en.html) available but it is not used to render the docs.
See the [ReDoc documentation](https://github.com/Redocly/redoc) for details.

You can download the `openapi.yaml` and install the [redoc-cli](https://github.com/Redocly/redoc/blob/master/cli/README.md) so that you can render a zero-dependency static HTML file of our docs locally.

```
npm i -g redoc-cli

redoc-cli bundle [path to your yaml/json openapi file]

```

The command will create the HTML file in your current directory. :warning: This will not include our style changes!

### Github pages build

[![Build Status](https://travis-ci.org/o2r-project/api.svg?branch=master)](https://travis-ci.org/o2r-project/api)

The current master branch is automatically built on ReDoc and deployed to the GitHub Page at <https://o2r.info/api/>.
Our combination of the `openapi.yaml` and ReDoc's `redoc.standalone.js` will render a html which is then deployed through gh-pages. Our script `redoc_theme.js` contains the actual ReDoc initialization command and makes a few style changes through  callback functions to correspond to our project.

The css rules which expand the core ReDoc style are in the `openapi_style.css` file.  



## License

The o2r Web API specification is licensed under [Creative Commons CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/), see file `LICENSE`.
To the extent possible under law, the people who associated CC0 with this work have waived all copyright and related or neighboring rights to this work.
This work is published from: Germany.
