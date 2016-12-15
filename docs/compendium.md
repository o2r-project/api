# Compendium

## List compendia

__Stability:__ 0 - subject to changes

Will return up to 100 results by default. For pagination purposes, URLs for previous and next results are provided if applicable.

`curl https://…/api/v1/compendium?limit=100&start=2`

`GET /api/v1/compendium?limit=100&start=2`

```json
200 OK

{
  "results":[
    "nkm4b",
    "asdis",
    "nb2sm",
    …
  ],
  "next":"/api/v1/compendium?limit=100&start=3",
  "previous":"/api/v1/compendium?limit=100&start=1"
}
```

You can also get only the compendia uploaded by a specific user. A user filter can be combined with pagination.

`curl http://…/api/v1/compendium?user=0000-0001-6021-1617`

`GET /api/v1/compendium?user=0000-0001-6021-1617`

```json
200 OK

{
  "results":[
    "nkm4b",
    "nb2sm"
  ]
}
```

### URL parameters

- `job_id` - Comma-separated list of related job ids to filter by.
- `user` - Public user identifier to filter by.
- `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
- `limit` - Specify maximum amount of results per page. Defaults to 100.

### Error responses

```json
404 Not Found

{"error":"no compendium found"}
```

## View single compendium

__Stability:__ 0 - subject to changes

This includes the complete metadata set, related job ids and a tree representation of the included [files](files.md). The `created` timestamp refers to the upload of the compendium. It is formated as ISO8601.

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

```json
200 OK

{
  "id":"comid",
  "metadata": … ,
  "created": "2016-08-01T13:57:40.760Z",
  "files": …
 }
```

### URL parameters

- `:id` - the compendiums id

### Error responses

```json
404 Not Found

{"error":"no compendium with this id"}
```

## Download compendium

__Stability:__ 0 - subject to changes

Download the complete compendium as an archive. Supported formats are as follows:

- `zip`
- `tar`
- `tar.gz` (gzipped tarball)

### Requests

`curl https://…/api/v1/compendium/$ID.zip`

`wget https://…/api/v1/compendium/$ID.zip`

```bash
GET /api/v1/compendium/:id.zip
GET /api/v1/compendium/:id.tar
GET /api/v1/compendium/:id.tar.gz
GET /api/v1/compendium/:id.tar?gzip
GET /api/v1/compendium/:id.zip?image=false
```

### Response

The response is a file attachment. The suggested file name is available in the HTTP header `content-disposition` using the respective file extension (i.e. `.zip`, `.tar`, and `.tar.gz`).

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

### URL parameters

- `:id` - the compendiums id

### URL query parameters

- `gzip` - _only for .tar endpoint_ - compress tarball with gzip
- `image=true` or `image=false` - include tarball of Docker image in the archive, default is `true`

### Error responses

```bash
404 Not Found

{"error":"no compendium with this id"}
```

## List related execution jobs

`curl https://…/api/v1/compendium/$ID/jobs`

`GET /api/v1/compendium/:id/jobs`

```json
200 OK
{
  "results":[
    "nkm4L",
    "asdi5",
    "nb2sg",
    …
  ],
  "next":"/api/v1/compendium/:id/jobs?limit=100&start=3",
  "previous":"/api/v1/compendium/:id/job?limit=100&start=1"
}
```

**Implemented:** Yes

**Stability:** 0 - subject to changes

### URL parameters

- `:id` - compendium id that the results should be related to

### Error response

```json
404 Not Found

{"error":"no job found"}
```
