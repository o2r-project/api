# Upload

## Compendium

Upload a unvalidated research compendium as a compressed archive, either `.zip` or `.tar.gz`. Upon successful extraction of archive, a `id` for the new compendium is returned.

```
curl -F "compendium=@compendium.zip;type=application/zip" \
     -F content_type=compendium_v1 \ 
     -H "X-API-Key: CHANGE_ME" \
     https://…/api/v1/compendium
```

```
POST /api/v1/compendium#

X-API-Key: api_key
```

```json
200 OK

{"id":"a4Ndl"}
```

**Additional Headers:**

- `X-API-Key` - valid API key for POSTing to /compendium

**Body parameters:**

- `compendium` - The archive file
- `content_type` - Form of archive. One of the following:

  - `compendium_v1` - _default_ - compendium in Bagtainer format
  - `workspace` - formless workspace

**Implemented:** Partially (`content_type` must be `compendium_v1`)

**Stability:** 0 - subject to changes

### Error Responses

```json
401 Unauthorized

{"error":"missing or wrong api key"}
```
