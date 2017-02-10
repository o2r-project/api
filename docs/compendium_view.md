# View compendium

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
