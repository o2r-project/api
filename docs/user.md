# User

## List users

Return a list of user ids. [Pagination (including defaults) as described for compendia](compendium/view.md) is available for users.

`curl https://…/api/v1/user`

`GET /api/v1/user`

```json
200 OK

{
    "results": [
        "0000-0002-1825-0097",
        "0000-0001-6021-1617"
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
    "id": "0000-0001-6021-1617",
    "name": "o2r"
}
```

The content of the response depends on the state and level of the user that requests the resource. The above response only contains the id and the publicly visible name. The following response contains more details and requires a certain user level of the authenticated user making the request:

`curl --cookie "connect.sid=<session cookie here>" https://…/api/v1/user/0000-0001-6021-1617`

```json
200 OK

{
    "id": "0000-0001-6021-1617",
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

## Authentication

User authentication is done via authenticated sessions, which are referenced with a cookie called `connect.sid`. For every endpoint that needs user authentication, a cookie with an authenticated session is required.

### Access authentication information for direct API access

To run commands which require authentication from the command line, a user must login on the website first. Then open you browser cookies and find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`. Use the the contents of the cookie for your requests, for example as shown below when using curl.

```bash
curl [...] --cookie "connect.sid=<code string here>" \
     https://…/api/v1/endpoint
```

### Authentication within microservices

**Attention:** The authentication process _requires_ a secured connection, i.e. `HTTPS`.

#### Authentication provider

Session authentication is done using the OAuth 2.0 protocol.
Currently [ORCID](https://www.orcid.org) is the only available authentication provider, therefore users need to be registered with ORCID. Because of its nature, the authentication workflow is not a RESTful service.
Users must follow the redirection to the login endpoint with their web browser and grant access to the o2r platform for their ORCID account.
They are then sent back to our authentication service, which verifies the authentification request and enriches the user session with the verified ORCID for this user.

#### Start OAuth login

Navigate the webbrowser (e.g. via a HTML `<a>` link) to `/api/v1/auth/login`, which then redirects the user and request access to your ORCID profile. After granting access, ORCID redirects the user back to the `/api/v1/auth/login` endpoint with a unique `code` param that is used to verify the request.

If the verification was successful, the endpoint returns a session cookie named `connect.sid`, which is tied to a authenticated session. The server answers with a `301 redirect`, which redirects the user back to `/`, where the o2r platform webinterface resides.

If the login is unsuccessful, the user is not redirected back to the site and no further redirects are configured.

#### Request authentication status

As the cookie is present in both authenticated and unauthenticated sessions, clients (e.g. web browser user interfaces) must know if their session is authenticated, and if so, as which ORCID user. For this, send a `GET` request to the `/api/v1/auth/whoami` endpoint, including your session cookie.

`curl https://…/api/v1/auth/whoami --cookie "connect.sid=…`

`GET /api/v1/auth/whoami`

```json
200 OK

{
  "orcid": "0000-0001-6021-1617",
  "name": "o2r"
}
```

#### Error response for requests requiring authentication

When no session cookie was included, or the included session cookie does not belong to a authenticated session, the service responds with a `401 Unauthorized` message.

```json
401 Unauthorized

{
  "error": "not authenticated"
}
```

## User levels

Users are authenticated via OAuth and the actions on the website are limited by the `level` associated with an account.
On registration, each account is assigned a level `0`.
Only admin users and the user herself can read the level of a user.

The following is a list of actions and the corresponding required _minimum_ user level.

- `0` _Users_ (everybody)
    - Create new jobs
    - View compendia, jobs, user details
- `100` _Known users_
    - Create new compendium
    - Create shipments
    - Create substitutions
    - Delete own candidates
- `500` _Editors_
    - Edit user levels
    - Edit metadata of other user's compendia
    - View other user's candidates
- `1000` _Admins_
    - Delete candidates
    - View status pages of microservices

## Edit user

You can update information of an existing user using the `HTTP` operation `PATCH`.

### Change user level request

The user level can be changed with an `HTTP` `PATCH` request.
The new level is passed to the API via a query parameter, i.e. `..?level=<new level value>`.
The value must be an `int` (integer).
The response is the full user document with the updated value.

!!! note "Required user level"

    The user sending the request to change the level must have the required [user level](user.md#user-levels).

```bash
curl --request PATCH --cookie "connect.sid=<session cookie here>" \
  https://…/api/v1/user/0000-0001-6021-1617?level=42`
```

```json
200 OK

{
    "id": "0000-0001-6021-1617",
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
401 Unauthorized

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