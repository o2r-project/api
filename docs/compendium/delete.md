# Delete compendium

To delete a compendium **candidate**, an HTTP `DELETE` request can be send to the compendium endpoint.

!!! Important
    Once a compendium is not a candidate anymore, it **cannot** be deleted via the API.

!!! note "Required user level"

    The user deleting a candidate must be the author or have the required [user level](../user.md#user-levels).

## Request

The following request deletes the compendium with the identifier `12345`, including metadata and files.

```bash
curl -X DELETE https://…/api/v1/compendium/12345 \
    --cookie "connect.sid=<code string here>"
```

## Response

The response has an HTTP status of `204` and an empty body for successful deletion.

```bash
204 OK
```

## Error responses for compendium delete

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