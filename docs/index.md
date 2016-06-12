![Opening Reproducible Research](logo.png)

__Current version of the API: v1__

The o2r web API acts as the interface between the [o2r](https://o2r.info) backend services and the [webinterface](https://github.com/o2r-project/o2r-platform). It includes functionality to [upload](upload.md) and examine [executable research compendia](compendium.md) and run and examine [execution jobs](job.md).

It is implemented as a RESTful API. The entrypoint for the current version is `/api/v1`.
Unless specified otherwise, responses will always be in JSON format, body parameters are expected in `multipart/form-data` format.
