# Public share

Upload a research compendium by submitting a link to a cloud resource using an HTTP `POST` request using `multipart/form-data`.

Currently, the following repositories are supported:

- Sciebo (https://sciebo.de)
- Zenodo or Zenodo Sandbox (https://zenodo.org or https://sandbox.zenodo.org)

The upload is only allowed for logged in users.
To run the upload from the command line, login on the website and open you browser cookies.
Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Copy the contents of the cookie into the request example below.

Upon successful download from the public share, the `id` for the new compendium is returned.

!!! note "Required user level"

    The user creating a new compendium must have the required [user level](../user.md#user-levels).

```bash
curl -F "content_type=compendium_v1" \
    -F "share_url=https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA"  \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium
```

```json
200 OK

{"id":"b9Faz"}
```

Both use the same API endpoint `http://…/api/v1/compendium` but with different required/optional parameters:

## Sciebo 

### File selection

Depending on the file structure, the public share contents are treated differently:

1. If a file named `bagit.txt` is found, the directory will be treated as a research compendium
2. If a single zip file is found, the file will be extracted and treated as a research compendium
3. If a single subdirectory is found, the loader will look for subdirectories and analyze their contents _(NOT_IMPLEMENTED)_
4. If multiple files or subdirectories are found, the public share contents are treated as a workspace _(NOT IMPLEMENTED)_

### Body parameters for creating compendium from public share

- `share_url` - The sciebo link to the public share (required)
- `content_type` - Form of archive. One of the following (required):
    - `compendium_v1` compendium in Bagtainer format
    - `workspace` - _[NOT IMPLEMENTED]_ - formless workspace
- `path` - Path to a subdirectory in the public share (optional)
    - default is `/`

### Examples

```bash
curl -F "content_type=compendium_v1" \
    -F "share_url=https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA"  \
    -F "path=/metatainer" \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium
```

### Error responses for creating compendium from public share

```json
401 Unauthorized

{"error":"unauthorized: user level does not allow compendium creation"}
```

```json
403 Forbidden

{"error":"public share host is not allowed"}
```

```json
422 Unprocessable Entity

{"error":"files with unsupported encoding detected: [{'file':'/tmp/o2r/compendium/ejpmi/data/test.txt','encoding':'Shift_JIS'}]"}
```

### Example data

For testing purposes you can use the following public share. It contains a few ready-to-use compendia found in the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project:

`https://uni-muenster.sciebo.de/index.php/s/7EoWgjLSFVV89AO`

## Zenodo

### Body parameters for creating compendium from a Zenodo record

- `share_url` - The link to the zenodo record (optional). May be a link to https://zenodo.org or https://doi.org
- `doi` - A [DOI](https://doi.org) resolving to the zenodo record (optional)
- `zenodo_record_id` - The ID of the zenodo record (optional)
- `content_type` - Form of archive. One of the following (required):
    - `compendium_v1` compendium in Bagtainer format
    - `workspace` - _[NOT IMPLEMENTED]_ - formless workspace
- `filename` - Filename of your compendium. For now, only zip-files are supported. (optional)
    - if no `filename` is provided the first zip file is selected
    - multiple files are currently not supported

There must at least one url parameter that resolves to a zenodo record. I.e. one of the following:

- `share_url`
- `doi`
- `zenodo_record_id`

### Examples

1. Zenodo Record URL (with optional filename parameter)

```bash
curl -F "content_type=compendium_v1" \
    -F "zenodo_url=https://sandbox.zenodo.org/record/69114"  \
    -F "filename=metatainer.zip" \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium
```

2. DOI

```bash
curl -F "content_type=compendium_v1" \
    -F "doi=10.5072/zenodo.69114"  \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium
```

3. Zenodo Record ID

```bash
curl -F "content_type=compendium_v1" \
    -F "zenodo_record_id=69114"  \
    --cookie "connect.sid=<code string here>" \
     http://…/api/v1/compendium
```
If the Zenodo record id is supplied through the `doi` or `zenodo_record_id` parameter, or if the `share_url` parameter is a `doi.org` URL, a default base URL for the file download is used as selected by the API maintainer. This may be:

- `https://zenodo.org` or
- `https://sandbox.zenodo.org`

### Error responses for creating compendium from a Zenodo record

```json
401 Unauthorized

{"error":"unauthorized: user level does not allow compendium creation"}
```

```json
403 Forbidden

{"error":"host is not allowed"}
```

```json
422 Unprocessable Entity

{"error":"public share URL is invalid"}
```

```json
422 Unprocessable Entity

{"error":"DOI is invalid"}
```

```json
422 Unprocessable Entity

{"error":"files with unsupported encoding detected: [{'file':'/tmp/o2r/compendium/ejpmi/data/test.txt','encoding':'Shift_JIS'}]"}
```

### Example data

For testing purposes you can use the following public shares. These contain the _metatainer_ compendium found in the [o2r-bagtainers](https://github.com/o2r-project/o2r-bagtainers) project:

- Sciebo: `https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA`
- Zenodo: `https://sandbox.zenodo.org/record/69114`



