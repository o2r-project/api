# o2r web API documentation

[![Opening Reproducible Research](logo.png)](http://o2r.info)

**Current version of the API**: `v1` (subject to change)

The o2r web API acts as the interface between the [o2r](https://o2r.info) [microservices](http://o2r.info/architecture/) and the [web interface](https://github.com/o2r-project/o2r-platform).

The API provides services around the executable research compendium (ERC), or "compendium" for short, which is documented **[in the ERC spec](http://o2r.info/erc-spec)**.

It is implemented as a RESTful API. The entrypoint for the current version is `/api/v1`.

Unless specified otherwise, responses are always in JSON format.
Body parameters in `POST` requests are expected in `multipart/form-data` format.
Requests to the API should always be made with a secure connection using `HTTPS`.

We also provide a [simple Postman collection](https://raw.githubusercontent.com/o2r-project/o2r-web-api/master/muncher.postman_collection.json) ([getpostman.com](https://www.getpostman.com/)), so that you can comfortably explore the API.