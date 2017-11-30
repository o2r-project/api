# Download compendium

Download compendium files as an archive.

!!! Warning
    This download feature does _not_ provide access to complete and valid compendia, because it does not comprise an update of the [packaging](../shipment.md#packaging), while it does include [brokered metadata files](metadata.md#update-metadata).
    To download a valid compendium, create a [shipment](../shipment.md) with the appropriate recipient.

Supported formats are as follows:

- `zip`
- `tar`
- `tar.gz`

## Requests

`GET /api/v1/compendium/$ID.zip`

```bash
GET /api/v1/compendium/:id.zip
GET /api/v1/compendium/:id.tar
GET /api/v1/compendium/:id.tar.gz
GET /api/v1/compendium/:id.tar?gzip
GET /api/v1/compendium/:id.zip?image=false
```

### URL parameters for compendium download

- `:id` - the compendiums id
- `?gzip` - _only for .tar endpoint_ - compress tarball with gzip
- `?image=true` or `?image=false` - include tarball of Docker image in the archive, default is `true`

## Response

The response is a file attachment. The suggested file name is available in the HTTP header `content-disposition` using the respective file extension for a file named with the compendium identifier (e.g. `wdpV9.zip`, `Uh1o0.tar`, or `LBIt1.tar.gz`).

The `content-type` header also reflects the respective format, which can take the following values:

- `application/zip` for ZIP archive
- `application/x-tar` for TAR archive
- `application/octet-stream` for gzipped TAR

```txt
200 OK
Content-Type: application/zip
Transfer-Encoding: chunked
Content-Disposition: attachment; filename="$ID.zip"
X-Response-Time: 13.556ms
```

The zip file contains a comment with the original URL.

```bash
$ unzip -z CXE1c.zip
Archive:  CXE1c.zip
Created by o2r [https://…/api/v1/compendium/CXE1c.zip]
```

### Error responses for compendium download

```json
404 Not Found

{"error":"no compendium with this id"}
```

```json
400 Bad Request

{"error":"no job found for this compendium, run a job before downloading with image"}
```