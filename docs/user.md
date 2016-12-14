# User

## List users

__Stability:__ 1 - unlikely to change

Return a list of user ids. [Pagination (including defaults) as described for compendia](compendium.md) is available for users.

`curl https://…/api/v1/user`

`GET /api/v1/user`

```json
200 OK

{
    "results": [
        "0000-0002-0024-5046",
        "0000-0001-6021-1617"
    ]
}
```

## View single user

__Stability:__ 0 - subject to changes

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

### URL parameters

- `:id` - the user id

### Error responses

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
     http://…/api/v1/endpoint
```

### Authentication within microservices

**Attention:** The authentication process _requires_ a secured connection, i.e. HTTPS.

#### Authentication provider

Session authentication is done using the OAuth 2.0 protocol. Currently [ORCID](https://www.orcid.org) is the only available authentication provider, therefore users need to be registered with ORCID. Because of its nature, the authentication workflow is not a RESTful service. Users will need to navigate to the login endpoint with their webbrowser and grant access to the o2r platform for their ORCID account. They will then be sent back to our authentication service, which verifies the authentification request and enriches the user session with the verified ORCID for this user.

#### Start OAuth login

**Stability:** 1 - The endpoint location and error response might change.

Navigate the webbrowser (e.g. via a HTML `<a>` link) to `/api/v1/auth/login`, which will then redirect the user and request access to your ORCID profile. After granting access, ORCID will redirect the user back to the `/api/v1/auth/login` endpoint with a unique `code` param that is used to verify the request.

If the verification was successful, the endpoint returns a session cookie named `connect.sid`, which is tied to a authenticated session. The server answers with a `301 redirect`, which redirects the user back to `/`, where the o2r platform webinterface resides.

If the login is unsuccessful, the user is not redirected back to the site and no further redirects are configured.

#### Request authentication status

As the cookie is present in both authenticated and unauthenticated sessions, clients (e.g. webbrowsers) will need to know if their session is authenticated, and if so, as which ORCID user. For this, send a `GET` request to the `/api/v1/auth/whoami` endpoint, including your session cookie.

**Implemented:** Yes

**Stability:** 2 - will not likely change.

`curl https://…/api/v1/auth/whoami --cookie "connect.sid=…`

`GET /api/v1/auth/whoami`

```json
200 OK

{
  "orcid": "0000-0001-6021-1617",
  "name": "o2r"
}
```

#### Error response

When no session cookie was included, or the included session cookie does not belong to a authenticated session, the service will respond with a `401 Unauthorized` message.

```json
401 Unauthorized

{
  "error": "not authenticated"
}
```

## Edit user

You can update information of an existing user using the `HTTP` operation `PATCH`.

### Change level

The request must be made by an authenticated user with an appropriate level. The new level is passed to the API via a query parameter, i.e. `..?level=<new level value>`.
The value must be an `int`.
The response is the full user document with the updated value.

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

### Error responses

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