# User authentication

User authentication is done via authenticated sessions, which are referenced with a cookie called `connect.sid`. For every endpoint that needs user authentication, a cookie with an authenticated session is required.

**Attention:** The authentication process _requires_ a secured connection, i.e. HTTPS.

## Authentication provider

Session authentication is done using the OAuth 2.0 protocol. Currently [ORCID](https://www.orcid.org) is the only available authentication provider, therefore users need to be registered with ORCID. Because of its nature, the authentication workflow is not a RESTful service. Users will need to navigate to the login endpoint with their webbrowser and grant access to the o2r platform for their ORCID account. They will then be sent back to our authentication service, which verifies the authentification request and enriches the user session with the verified ORCID for this user.

## Start OAuth login

Navigate the webbrowser (e.g. via a HTML `<a>` link) to `/api/v1/auth/login`, which will then redirect the user and request access to your ORCID profile. After granting access, ORCID will redirect the user back to the `/api/v1/auth/login` endpoint with a unique `code` param that is used to verify the request.

If the verification was successful, the endpoint returns a session cookie named `connect.sid`, which is tied to a authenticated session. The server answers with a `301 redirect`, which redirects the user back to `/`, where the o2r platform webinterface resides.

**Implemented:** Yes.

**Stability:** 1 - The endpoint location and error response might change.

### Error response

**TODO** This needs to be properly implemented, but will very likely redirect you to the login endpoint, which will in turn start the authentication process over.

## Request authentication status

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

### Error Response

When no session cookie was included, or the included session cookie does not belong to a authenticated session, the service will respond with a `401 Unauthorized` message.

```json
401 Unauthorized

{
  "error": "not authenticated"
}
```
