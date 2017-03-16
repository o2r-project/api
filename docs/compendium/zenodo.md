# Zenodo - WORK IN PROGRESS

Upload an unvalidated research compendium by submitting a link to a Zenodo record (https://www.zenodo.org).

The upload is only allowed for logged in users. To run the upload from the command line, login on the website and open you browser cookies. Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`. Copy the contents of the cookie into the request example below.

Upon successful download from the zenodo record, the `id` for the new compendium is returned.

```bash
curl -d "content_type=compendium_v1" \
    -d "zenodo_url=https://sandbox.zenodo.org/record/69114"  \
    -d "filename=metatainer.zip" \
    --cookie "connect.sid=<code string here>" \
     http://…:8088/api/v2/compendium
```

```json
200 OK

{"id":"a5je3"}
```

## Body parameters for creating compendium from a Zenodo record

- `zenodo_url` - The link to the zenodo record (required)
- `content_type` - Form of archive. One of the following (required):
  - `compendium_v1` compendium in Bagtainer format
  - `workspace` - _[NOT IMPLEMENTED]_ - formless workspace
- `filename` - Filename of your compendium. For now, only zip-files are supported. (required)

## Error responses for creating compendium from public share

```json
401 Unauthorized

{"error":"unauthorized: user level does not allow compendium creation"}
```

```json
403 Forbidden

{"error":"host is not allowed"}
```

## Example data

For testing purposes you can use the following zenodo record in the zenodo sandbox. It contains the _metatainer_ compendium found in the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project:

`https://sandbox.zenodo.org/record/69114`

For more configuration details, see the project's README file.
