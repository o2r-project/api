# o2r Web API

Project description: [http://o2r.info](http://o2r.info)

## Basics

We're a research project, so _everything in this API and its documentation is subject to change. We try to use "WORK IN PROGRESS" or "TBD" to signal things that are not working fully yet. However, we try to have a "working" state online at [http://o2r.info/o2r-web-api](http://o2r.info/o2r-web-api) and use open pull requests for things that are under development.

## Build

This specification is written in [Markdown](https://daringfireball.net/projects/markdown/) and deployed automatically using Travis CI.
You can use `mkdocs` to render it locally, or view the latest master-branch on <http://o2r.info/o2r-web-api/>. See the [MkDocs documentation](http://www.mkdocs.org/) for details.

```bash
# pip install mkdocs
# mkdocs --version
mkdocs serve

mkdocs build
```

### Automated Builds

[![Build Status](https://travis-ci.org/o2r-project/o2r-web-api.svg?branch=master)](https://travis-ci.org/o2r-project/o2r-web-api)

The current master branch is automatically built on Travis CI and deployed to the GitHub Page at <http://o2r.info/o2r-web-api/>. Our combination of the `.travis.yml` and `.deploy.sh` will run the `mkdocs` command on every direct commit or merge on the master branch and deploy the rendered HTML documents to the `gh-pages` branch in this repository.

Travis authenticates its push to the `gh-pages` branch using a [personal access token](https://github.com/settings/tokens) of the user [@o2r-user](https://github.com/o2r-user). The access token is encrypted in the `.travis.yml` [using Travis CLI](https://docs.travis-ci.com/user/encryption-keys/) _for the repository o2r-project/o2r-web-api_:

```bash
travis encrypt GH_TOKEN=<token here>
```

The variable `GH_TOKEN` is used in the deploy script. The token generated on the GitHub website should not be stored anywhere, simply generate a new one if needed.

This has some security risks, as described [here](https://gist.github.com/domenic/ec8b0fc8ab45f39403dd#sign-up-for-travis-and-add-your-project). To mitigate these risks, we have disabled the option "Build pull requests" is on the [Travis configuration page for this repo](https://travis-ci.org/o2r-project/o2r-web-api/settings), so that malicious changes to the Travis configuration file will be noticed by the repository maintainer before merging a pull request.


## License

The o2r Web API specification is licensed under Creative Commons CC-BY-4.0 License, see file `LICENSE`.

Copyright (C) 2017 - o2r project.
