# Upload via API

Upload a research compendium as a compressed `.zip` archive with an HTTP `POST` request using `multipart/form-data`.

The upload is only allowed for logged in users.
To run the upload from the command line, you must login on the website and inspect your browser's cookies.
Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Provide the content of the cookie when making requests to the API as shown in the request example below.

Upon successful extraction of archive and processing of the contents, the `id` for the new compendium is returned.

!!! note "Required user level"

    The user creating a new compendium must have the required [user level](../user.md#user-levels).

```bash
curl -F "compendium=@compendium.zip;type=application/zip" \
    -F content_type=compendium https://…/api/v1/compendium \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium 
```

```json
200 OK

{"id":"a4Ndl"}
```

!!! Warning "Important"
    After successful load from a public share, the **[candidate process](upload.md#candidate-process)** applies.

## Body parameters for compendium upload

- `compendium` - The archive file
- `content_type` - Form of archive. One of the following:
  - `compendium` - _default_ - compendium in Bagtainer format
  - `workspace` - _WORK IN PROGRESS_ - formless workspace

## Error responses for compendium upload

```json
401 Unauthorized

{"error":"missing or wrong api key"}
```

```json
422 Unprocessable Entity

{"error":"files with unsupported encoding detected: [{'file':'/tmp/o2r/compendium/ejpmi/data/test.txt','encoding':'Shift_JIS'}]"}
```

## Example data

For local testing you can quickly upload some of the example compendia using a Docker image that is part of the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project.
The following command executes the container and uploads 7 empty examples and two selected bagtainers to a server running at the Docker host IP.

```bash
docker run --rm o2rproject/examplecompendia -c <my cookie> -e 7 -b 0003 -b 0004 -b 0005
```

For more configuration details, see the project's README file.
