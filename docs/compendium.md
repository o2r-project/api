# Compendium

## List compendia

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

### URL parameters for compendium lists

- `job_id` - Comma-separated list of related job ids to filter by.
- `user` - Public user identifier to filter by.
- `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
- `limit` - Specify maximum amount of results per page. Defaults to 100.

### Error responses for compendium lists

```json
404 Not Found

{"error":"no compendium found"}
```

## View single compendium

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

### URL parameters for single compendium view

- `:id` - the compendiums id

### Error responses for single compendium view

```json
404 Not Found

{"error":"no compendium with this id"}
```

## Download compendium

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

### URL parameters for compendium download

- `:id` - the compendiums id
- `?gzip` - _only for .tar endpoint_ - compress tarball with gzip
- `?image=true` or `?image=false` - include tarball of Docker image in the archive, default is `true`

### Error responses for compendium download

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

### URL parameters for related execution jobs

- `:id` - compendium id that the results should be related to

### Error response for related execution jobs

```json
404 Not Found

{"error":"no job found"}
```

## Metadata

### Basics

Metadata in a compendium is stored in a directory `.erc`. This directory contains the normative metadata documents using a file naming scheme `<metadata_model>.<format>`, sometimes preprended with `metadata_` for clarity, e.g. `metadata_raw.json`, `metadata_o2r.json`, `zenodo.json`, or `datacite.xml`.

A copy of the files in this directory is kept in database for easier access, so every compendium returned by the API can contain different sub-properties in the metadata property. _This API always returns the database copy of the metadata elements._ You can download the respective files to access the normative metadata documents.

Both the files and the sub-properties are only available _on-demand_, so for example after a shipment to Zenodo is initiated. After creation the metadata is persisted to file and database.

The sub-properties and their features are

- `raw` contains raw metadata extracted automatically
- `o2r` holds the **main information for display** and is modelled according the the o2r metadata model. This metadata is first an automatic transformation of raw metadata and should then be checked by the uploading user during the upload process.
- `datacite` (TBD) holds DataCite XML
- `zenodo` holds [Zenodo](https://zenodo.org/) metadata for shipments made to Zenodo

**Note:** The information in each sub-property are subject to independent workflows and may differ from one another.

Future sub-properties might expose `enriched` or `harvested` metadata.

### URL parameters for metadata

- `:id` - compendium id

### GET metadata - example request and response

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "raw": {
      "title": "Programming with Data. Springer, New York, 1998. ISBN 978-0-387-98503-9.",
      "author": "John M. Chambers.   "
    },
    "o2r": {
      "title": "Programming with Data",
      "creator": "John M. Chambers",
      "year": 1998
    }, {
      …
    }
  },
  "created": …,
  "files": …
}
```

### Update metadata - WORK IN PROGRESS

The following endpoint can be used to update the `o2r` metadata elements.
Only authors of a compendium can update the metadata.
All other metadata sub-properties are only updated by the platform itself.

#### Metadata update request

```bash
curl -H 'Content-Type: application/json' \
  -X PUT \
  --cookie "connect.sid=<code string here>" \
  -d '{ "o2r": { "title": "Blue Book" } }' \
  /api/v1/compendium/:id/metadata
```

The request will _overwrite_ the existing metadata properties, so the full o2r metadata must be put with a JSON object called `o2r` at the root, even if only specific fields are changed.

#### Metadata update response

The response contains an excerpt of a compendium with only the o2r metadata property.

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "o2r": {
      "title": "Blue Book"
    }
  }
}
```

This response is also available at `GET /api/v1/compendium/:id/metadata`.

### Metadata update error responses

```json
401 Unauthorized

{"error":"not authorized"}
```

```txt
400 Bad Request

"SyntaxError [...]"
```

```json
422 Unprocessable Entity

{"error":"JSON with root element 'o2r' required"}
```
