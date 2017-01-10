# Upload via API

Upload a unvalidated research compendium as a compressed `.zip` archive.

The upload is only allowed for logged in users. To run the upload from the command line, login on the website and open you browser cookies. Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`. Copy the contents of the cookie into the request example below.

Upon successful extraction of archive, the `id` for the new compendium is returned.

```bash
curl -F "compendium=@compendium.zip;type=application/zip" \
    -F content_type=compendium_v1 http://…/api/v1/compendium \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium 
```

```json
200 OK

{"id":"a4Ndl"}
```

## Body parameters for compendium upload

- `compendium` - The archive file
- `content_type` - Form of archive. One of the following:
  - `compendium_v1` - _default_ - compendium in Bagtainer format
  - `workspace` - _WORK IN PROGRESS_ - formless workspace

## Error responses for compendium upload

```json
401 Unauthorized

{"error":"missing or wrong api key"}
```

## Example data

For local testing you can quickly upload some of the example compendia using a Docker image that is part of the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project.
The following command executes the container and uploads 7 empty examples and two selected bagtainers to a server running at the Docker host IP.

```bash
docker run --rm o2rproject/examplecompendia -c <my cookie> -e 7 -b 0003 -b 0004 -b 0005
```

For more configuration details, see the project's README file.
