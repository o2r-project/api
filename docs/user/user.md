# User management

## List users

Return a list of user ids. [Pagination (including defaults) as described for compendia](../compendium/view.md) is available for users.

`curl https://…/api/v1/user`

`GET /api/v1/user`

```json
200 OK

{
    "results": [
        "0000-0002-1825-0097",
        "0000-0002-1825-0097"
    ]
}
```

If there are no users, the returned list is empty:

```json
200 OK
{
  "results": [ ]
}
```

Pagination is supported using the query parameters `start` and `limit`.

- `limit` is the number of results in the response, defaults to `10`. It numeric and larger than `0`.
- `start` is the index of the first list item in the response, defaults to `1`. It must be numeric and larger than `0`.

`GET /api/v1/user?start=5&limit=10`

### Error responses for user list

```json
400 Bad Request

{"error":"limit must be larger than 0"}
```

## View single user

Show the details of a user.

`curl https://…/api/v1/user/$ID`

`GET /api/v1/user/:id`

```json
200 OK

{
    "id": "0000-0002-1825-0097",
    "name": "o2r"
}
```

The content of the response depends on the state and level of the user that requests the resource. The above response only contains the id and the publicly visible name. The following response contains more details and requires a certain user level of the authenticated user making the request:

`curl --cookie "connect.sid=<session cookie here>" https://…/api/v1/user/0000-0002-1825-0097`

```json
200 OK

{
    "id": "0000-0002-1825-0097",
    "name": "o2r",
    "level": 0,
    "lastseen": "2016-08-15T12:32:23.972Z"
}
```

### URL parameters for single user view

- `:id` - the user id

### Error responses for single user view

```json
404 Not Found

{"error":"no user with this id"}
```

## Edit user

You can update information of an existing user using the `HTTP` operation `PATCH`.

### Change user level request

The user level can be changed with an `HTTP` `PATCH` request.
The new level is passed to the API via a query parameter, i.e. `..?level=<new level value>`.
The value must be an `int` (integer).
The response is the full user document with the updated value.

!!! note "Required user level"

    The user sending the request to change the level must have the required [user level](levels.md).

```bash
curl --request PATCH --cookie "connect.sid=<session cookie here>" \
  https://…/api/v1/user/0000-0002-1825-0097?level=42`
```

```json
200 OK

{
    "id": "0000-0002-1825-0097",
    "name": "o2r",
    "level": 42,
    "lastseen": "2016-08-15T12:32:23.972Z"
}
```

### Error responses for user level change

```json
401 Unauthorized

{
  "error": "user is not authenticated"
}
```

```json
403 Forbidden

{
  "error": "user level does not allow edit"
}
```

```json
400 Bad Request

{
  "error": "parameter 'level' could not be parsed as an integer"
}
```