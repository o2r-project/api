# o2r web API documentation

[![Opening Reproducible Research](logo.png)](https://o2r.info)

**Current version of the API**: `v1`

## About

The o2r web API acts as the interface between the [o2r](https://o2r.info) [microservices](https://o2r.info/architecture/) and the [web interface](https://github.com/o2r-project/o2r-platform).

The API provides services around the executable research compendium (ERC), or "compendium" for short, which is documented **[in the ERC spec](https://o2r.info/erc-spec)**.

**A good starting point for understanding the different parts of the API is the [compendium life-cycle](compendium/overview.md).**

------

## Citation

To cite this specification please use

> _Nüst, Daniel, 2018. Reproducibility Service for Executable Research Compendia: Technical Specifications and Reference Implementation. Zenodo. doi:[10.5281/zenodo.2203844](http://doi.org/10.5281/zenodo.2203844)_

For a complete list of publications, posters, presentations, and software projects from th2 o2r project please visit [https://o2r.info/results/](https://o2r.info/results/).

------

## General notes

The API is implemented as a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer)ful API. The entrypoint for the current version is `/api/v1`.

Unless specified otherwise, responses are always in JSON format.
Body parameters in `POST` requests are expected in `multipart/form-data` format.
Requests to the API should always be made with a secure connection using `HTTPS`.
Some requests require [authentication](user/auth.md) with a specific [user level](user/levels.md).

------

## License

![CC-0 Button](https://licensebuttons.net/p/zero/1.0/88x31.png)

The o2r Executable Research Compendium specification is licensed under [Creative Commons CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/), see file [`LICENSE`](https://github.com/o2r-project/api/tree/master/LICENSE).
To the extent possible under law, the people who associated CC0 with this work have waived all copyright and related or neighboring rights to this work.
This work is published from: Germany.