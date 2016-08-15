![Opening Reproducible Research](logo.png)

**Current version of the API: v1**

The o2r web API acts as the interface between the [o2r](https://o2r.info) [microservices](https://github.com/o2r-project) and the [web interface](https://github.com/o2r-project/o2r-platform). It includes functionality to [upload](upload.md) and examine [executable research compendia](compendium.md) and run and examine [execution jobs](job.md).

It is implemented as a RESTful API. The entrypoint for the current version is `/api/v1`.

Unless specified otherwise, responses will always be in JSON format.
Body parameters in `POST` requests are expected in `multipart/form-data` format.
Requests to the API should always be made with a secure connection, i.e. HTTPS.

We also provide a [simple Postman collection](https://raw.githubusercontent.com/o2r-project/o2r-web-api/master/muncher.postman_collection.json)([getpostman.com](https://www.getpostman.com/)), so that you can comfortably explore the API.