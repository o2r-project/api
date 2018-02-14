# o2r web API documentation

[![Opening Reproducible Research](logo.png)](http://o2r.info)

**Current version of the API**: `v1`

## About

The o2r web API acts as the interface between the [o2r](https://o2r.info) [microservices](http://o2r.info/architecture/) and the [web interface](https://github.com/o2r-project/o2r-platform).

The API provides services around the executable research compendium (ERC), or "compendium" for short, which is documented **[in the ERC spec](http://o2r.info/erc-spec)**.

## General notes

The API is implemented as a [REST](https://en.wikipedia.org/wiki/Representational_state_transfer)ful API. The entrypoint for the current version is `/api/v1`.

Unless specified otherwise, responses are always in JSON format.
Body parameters in `POST` requests are expected in `multipart/form-data` format.
Requests to the API should always be made with a secure connection using `HTTPS`.
Some requests require [authentication](user.md#authentication) with a specific [user level](user.md#user-levels).

We also provide a [simple Postman collection](https://raw.githubusercontent.com/o2r-project/o2r-web-api/master/muncher.postman_collection.json) ([getpostman.com](https://www.getpostman.com/)), so that you can comfortably explore the API.

## License

![CC-0 Button](https://licensebuttons.net/p/zero/1.0/88x31.png)

The o2r Executable Research Compendium specification is licensed under [Creative Commons CC0 1.0 Universal License](https://creativecommons.org/publicdomain/zero/1.0/), see file `LICENSE`.
To the extent possible under law, the people who associated CC0 with this work have waived all copyright and related or neighboring rights to this work.
This work is published from: Germany.