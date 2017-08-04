# Substitute compendia

introduction...

## Create substitution

### Request

`POST /api/v1/..`

!!! note "Required user level"

    The user creating a new substitution must have the required [user level](../user.md#user-levels).

### Response

```json
200 OK

{
}
```

### URL parameters for substititions

- `base` ?
- `overlay` ?

### Error responses

```json
404 Not Found

{"error":"base erc not found"}
```
