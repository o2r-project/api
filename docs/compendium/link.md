# Public links

For inspection by others, it is possible to create a **read-only public link to a compendium candidate**.
This link can, e.g., be used in peer review.

!!! Important
    Every person with the link can view the compendium and start jobs for it.
    The jobs are _not_ access controlled beyond the random identifier.
    Jobs for private links are _not listed_ in the generic job list, but they can be accessed when [retrieving jobs for a compendium](view.md#list-related-execution-jobs) using the public link for the candidate compendium.

!!! note "Required user level for link creation"
    The user managing public links must have the required [user level](../user.md#user-levels) - authors cannot do this by themselves so no private data is shared by mistake.

## Create link

### Request

The following request creates a link for the _candidate_ compendium with the identifier `12345`.

```bash
curl -X PUT https://…/api/v1/compendium/12345/link \
    --cookie "connect.sid=<code string here>"
```

### Response

The response has an HTTP status of `200` if the public link was created.
The response body provides the public link `id`, which can be used for subsequent requests to:

- view the candidate compendium
- download candidate compendium files
- start jobs for the candidate compendium

Only **1 public link** is created per candidate compendium.
_Subsequent requests will return the same link._

```json
200 OK

{
    "id":"lSaOCqxmNEO8Og42a0ONVRYUVoDWeBLr",
    "compendium":"xkjzY",
    "user":"0000-0002-1701-2564"
}
```

## List links

### Request

```bash
curl -X GET http://localhost/api/v1/link
    --cookie "connect.sid=s%3AVU61x4E<rest of cookie>"
```

### Reponse

```json
HTTP 200

{
  "results": [
    {
      "id": "b56Cy5EG7oiCBPCZMjXIPXoSyPVxiGVA",
      "compendium": "eENFZ",
      "user": "0000-0002-1701-2564"
    },
    {
      "id": "p6s3GGn6EaDoZXM8jOWuNd5E1lHKPVRt",
      "compendium": "xkjzY",
      "user": "0000-0002-1701-2564"
    }
  ]
}
```

## Delete link

### Request

The following request deletes a link for the compendium with the identifier `12345`.

```bash
curl -X DELETE https://…/api/v1/compendium/12345/link \
    --cookie "connect.sid=<code string here>"
```

### Response

The response has an HTTP status of `204` and an empty body for successful deletion.

```bash
204 No Content
```

## Error responses for public link management

The following errors can occur on all management operations (create, list, delete).

```json
401 Unauthorized

{"error":"not authorized"}
```

```json
403 Forbidden

{"error":"user level not sufficient to delete compendium"}
```

```json
404 Not Found

{"error":"compendium not found"}
```
