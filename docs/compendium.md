# compendium

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

**Implemented:** Yes

**Stability:** 0 - subject to changes

### URL Parameters

- `job_id` - Comma-separated list of related job ids to filter by.
- `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
- `limit` - Specify maximum amount of results per page. Defaults to 100.

### Error Responses

```json
404 Not Found

{"error":"no compendium found"}
```

## View single compendium

This includes the complete metadata set, related job ids and a tree representation of the included [files](files.md). The `created` timestamp refers to the upload of the compendium. It is formated as ISO8601.

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

```
200 OK

{
  "id":"comid",
  "metadata": … ,
  "created": 2016-08-01T13:57:40.760Z",
  "files": …
 }
```

**Implemented:** Yes

**Stability:** 0 - subject to changes

### URL Parameters

- `:id` - the compendiums id

### Error Responses

```
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

### URL Parameters

- `:id` - compendium id that the results should be related to

### Error Response

```
404 Not Found

{"error":"no job found"}
```
