# Upload via API

Upload a research workspace or full compendium as a compressed `.zip` archive with an HTTP `POST` request using `multipart/form-data`.

The upload is only allowed for logged in users.
Upon successful extraction of archive and processing of the contents, the `id` for the new compendium is returned.

!!! note "Required user level and authentication"

    The user creating a new compendium must have the required [user level](../user.md#user-levels).
    Requests must be authenticated with a cookie `connect.sid`, see [user authentication](../user.md#client-authentication).

```bash
curl -F "compendium=@compendium.zip;type=application/zip" \
    -F content_type=compendium \
    --cookie "connect.sid=<cookie string here>" \
     https://…/api/v1/compendium 
```

```bash
curl -F "compendium=@path/to/workspace.zip;type=application/zip" \
    -F content_type=workspace \
    --cookie "connect.sid=<cookie string here>" \
     https://…/api/v1/compendium 
```

```json
200 OK

{"id":"a4Ndl"}
```

!!! Warning "Important"
    After successful upload the **[candidate process](upload.md#candidate-process)** must be completed for workspaces.

## Body parameters for compendium upload

- `compendium` - The archive file
- `content_type` - Form of archive. One of the following:
    - `compendium` - compendium, which is expected to be complete and valid, for _examination_ of a compendium
    - `workspace` - formless workspace, for _creation_ of a compendium

!!! warning
    If a complete ERC is submitted as a workspace, it may result in an error, or the contained metadata and other files may be overwritten by the creation process.

## Error responses for compendium upload

```json
400 Bad Request

{"error":"provided content_type not implemented"}
```

```json
401 Unauthorized

{"error":"user is not authenticated"}
```

```json
403 Forbidden

{"error":"user level does not allow compendium creation"}
```

```json
422 Unprocessable Entity
```

For local testing you can quickly upload some of the example compendia and workspaces from the [erc-examples](https://github.com/o2r-project/erc-examples) project.
