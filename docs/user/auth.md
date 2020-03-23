# Authentication

User authentication is done via authenticated sessions, which are referenced with a cookie called `connect.sid`. For every endpoint that needs user authentication, a cookie with an authenticated session is required.

## Client authentication

To execute restricted operations of the API, such as [compendium upload]() or [job execution](), a client must provide an authentication token via a cookie.

A client must first login on the website to access a browser cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Provide the content of the cookie when making requests to the API as shown in the request example below.

## Access authentication information for direct API access

To run commands which require authentication from the command line, a user must login on the website first.
Then open you browser cookies and find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Use the the contents of the cookie for your requests, for example as shown below when using curl.

```bash
curl [...] --cookie "connect.sid=<code string here>" \
     https://…/api/v1/endpoint
```

## Authentication within microservices

**Attention:** The authentication process _requires_ a secured connection, i.e. `HTTPS`.

### Authentication provider

Session authentication is done using the OAuth 2.0 protocol.
Currently [ORCID](https://www.orcid.org) is the only available authentication provider, therefore users need to be registered with ORCID. Because of its nature, the authentication workflow is not a RESTful service.
Users must follow the redirection to the login endpoint with their web browser and grant access to the o2r reproducibility service for their ORCID account.
They are then sent back to our authentication service, which verifies the authentication request and enriches the user session with the verified ORCID for this user.

### Start OAuth login

Navigate the web browser (e.g. via a HTML `<a>` link) to `/api/v1/auth/login`, which then redirects the user and request access to your ORCID profile. After granting access, ORCID redirects the user back to the `/api/v1/auth/login` endpoint with a unique `code` param that is used to verify the request.

If the verification was successful, the endpoint returns a session cookie named `connect.sid`, which is tied to a authenticated session. The server answers with a `301 redirect`, which redirects the user back to `/`, the start page of the o2r website.

If the login is unsuccessful, the user is not redirected back to the site and no further redirects are configured.

### Request authentication status

As the cookie is present in both authenticated and unauthenticated sessions, clients (e.g. web browser user interfaces) must know if their session is authenticated, and if so, as which ORCID user. For this, send a `GET` request to the `/api/v1/auth/whoami` endpoint, including your session cookie.

`curl https://…/api/v1/auth/whoami --cookie "connect.sid=…`

`GET /api/v1/auth/whoami`

```json
200 OK

{
  "orcid": "0000-0002-1825-0097",
  "name": "o2r"
}
```

### Error response for requests requiring authentication

When no session cookie was included, or the included session cookie does not belong to a authenticated session, the service responds with a `401 Unauthorized` message.

```json
401 Unauthorized

{
  "error": "not authenticated"
}
```
