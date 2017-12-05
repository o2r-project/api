# View compendium

## List compendia

Returns up to 100 results by default.

`curl https://…/api/v1/compendium?limit=100&start=2`

`GET /api/v1/compendium?limit=100&start=2`

```json
200 OK

{
  "results": [
    "nkm4b",
    "asdis",
    "nb2sm",
    …
  ]
}
```

You can also filter the results.

- Filter by `user`:
    - `curl https://…/api/v1/compendium?user=0000-0002-1825-0097`
    - `GET /api/v1/compendium?user=0000-0002-1825-0097`
- Filter by `doi`:
    - `curl https://…/api/v1/compendium?doi=10.9999%2Ftest`
    - `GET /api/v1/compendium?doi=10.9999%2Ftest`

```json
200 OK

{
  "results": [
    "nkm4b",
    "nb2sm"
  ]
}
```

If there is no compendium found, the service returns an empty list.

`GET /api/v1/compendium?doi=not_a_doi`

```json
200 OK

{
  "results": []
}
```

### URL parameters for compendium lists

- `job_id` - Comma-separated list of related job ids to filter by.
- `user` - Public user identifier to filter by.
- `doi` - A [DOI](https://doi.org) to filter by.
- `start` - Starting point of the result list. `start - 1` results are skipped. Defaults to `1`.
- `limit` - Limits the number of results in the response. Defaults to `100`.

## View single compendium

This includes the complete metadata set, related job ids and a tree representation of the included [files](compendium/files.md). The `created` timestamp refers to the upload of the compendium. It is formated as ISO8601.

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

## List related execution jobs

`curl https://…/api/v1/compendium/$ID/jobs`

`GET /api/v1/compendium/:id/jobs`

```json
200 OK
{
  "results": [
    "nkm4L",
    "asdi5",
    "nb2sg",
    …
  ]
}
```

If a compendium does not have any jobs yet, the returned list is empty.

```json
200 OK
{
  "results": [ ]
}
```

### URL parameters for related execution jobs

- `:id` - compendium id that the results should be related to
