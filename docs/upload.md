#Upload

## Compendium

Upload a unvalidated research compendium as a compressed archive, either `.zip` or `.tar.gz`. Upon successful extraction of archive, a `id` for the new compendium is returned.

`curl -F "compendium=@compendium.zip;type=application/zip" -F content_type=compendium_v1 http://…/api/v1/compendium `

`POST /api/v1/compendium`

```json
200 OK

{"id":"a4Ndl"}
```

__Body parameters:__

* `compendium` - The archive file
* `content_type` - Form of archive. One of the following:
    * `compendium_v1` - _default_ - compendium in Bagtainer format
    * `workspace` - formless workspace

__Implemented:__ No

__Stability:__ 0 - subject to changes

### Error Responses

```json
401 Unauthorized

{"error":"user not logged in"}
```
