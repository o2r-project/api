# Public share - WORK IN PROGRESS

Upload an unvalidated research compendium by submitting a link to a cloud resource. Currently, only sciebo (https://www.sciebo.de/en/) is supported.

The upload is only allowed for logged in users. To run the upload from the command line, login on the website and open you browser cookies. Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`. Copy the contents of the cookie into the request example below.

Upon successful download from the public share, the `id` for the new compendium is returned.

```bash
curl -d "content_type=compendium_v1" \
    -d "share_url=http://uni-muenster.sciebo.de/index.php/s/7EoWgjLSFVV89AO"  \
    -d "path=/sleeptainer" \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/public-share
```

```json
200 OK

{"id":"b9Faz"}
```

## File selection

Depending on the file structure, the public share contents are treated differently:

1. If a file named `bagit.txt` is found, the directory will be treated as a research compendium
2. If a single zip file is found, the file will be extracted and treated as a research compendium
3. If a single subdirectory is found, the loader will look for subdirectories and analyze their contents _(NOT_IMPLEMENTED)_
4. If multiple files or subdirectories are found, the public share contents are treated as a workspace _(NOT IMPLEMENTED)_

## Body parameters for creating compendium from public share

- `share_url` - The sciebo link to the public share (required)
- `content_type` - Form of archive. One of the following (required):
  - `compendium_v1` compendium in Bagtainer format
  - `workspace` - _[NOT IMPLEMENTED]_ - formless workspace
- `path` - Path to a subdirectory in the public share (optional)
  - default is `/`


## Error responses for creating compendium from public share

```json
401 Unauthorized

{"error":"unauthorized: user level does not allow compendium creation"}
```

```json
403 Forbidden

{"error":"public share host is not allowed"}
```

## Example data

For testing purposes you can use the following public share. It contains a few ready-to-use compendia found in the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project:

`https://uni-muenster.sciebo.de/index.php/s/7EoWgjLSFVV89AO`

For more configuration details, see the project's README file.