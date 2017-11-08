# Public share

Load a research compendium by submitting a link to a cloud resource using an HTTP `POST` request using `multipart/form-data`.

Currently, the following repositories are supported:

- [Sciebo](https://sciebo.de)
- [Zenodo](https://zenodo.org)
- [Zenodo Sandbox](https://sandbox.zenodo.org)

## Common

All repositories use the same API endpoint `https://…/api/v1/compendium`, but with different required/optional parameters.

The upload is only allowed for logged in users.
To run the upload from the command line, login on the website and open you browser cookies.
Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Copy the contents of the cookie into the request example below.

!!! note "Required user level"
    The user creating a new compendium must have the required [user level](../user.md#user-levels).

To run the load from the command line, login on the website and open you browser cookies.
Find a cookie issued by `o2r.uni-muenster.de` with the name `connect.sid`.
Copy the contents of the cookie into the request example below.

Upon successful download from the public share, the `id` for the new compendium is returned.

```bash
curl -F "content_type=compendium" \
    -F "share_url=https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA"  \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium
```

```json
200 OK

{"id":"b9Faz"}
```

!!! Warning "Important"
    After successful load from a public share, the **[candidate process](upload.md#candidate-process)** applies.

## Sciebo

[Sciebo](http://www.sciebo.de/en/about/index.html) is a cloud storage service at North Rhine-Westphalian universities.
Although it builds on ownCloud and the implementation might be able to handle any ownCloud link, only Sciebo's publish shares are supported by this API. 

### File selection

Depending on the public share contents different processes are triggered:

1. If a file named `bagit.txt` is found, the directory will checked for Bagit validity
2. If a single zip file is found, the file will be extracted, if multiple zip files are found, an error is returned.
3. If a single subdirectory is found, the loader will use that subdirectory
4. Depending on the value of `content_type` (see below), the public share contents are treated as a complete compendium or as a  workspace

### Body parameters for creating compendium from public share

- `share_url` - The Sciebo link to the public share (required)
- `content_type` - Form of archive. One of the following (required):
    - `compendium` - complete compendium
    - `workspace` - formless workspace
- `path` - Path to a subdirectory in the public share (optional)
    - default is `/`

### Examples

```bash
curl -F "content_type=compendium" \
    -F "share_url=https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA"  \
    -F "path=/metatainer" \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium
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

For testing purposes you can use the following public share, which contains a few ready-to-use compendia:

[`https://uni-muenster.sciebo.de/index.php/s/7EoWgjLSFVV89AO`](https://uni-muenster.sciebo.de/index.php/s/7EoWgjLSFVV89AO)

## Zenodo

### Body parameters for creating a compendium from a Zenodo record

- Identification of the Zenodo record, one of the folloing is required:
    - `share_url` - The link to the zenodo record (optional). May be a link to https://zenodo.org or https://doi.org
    - `doi` - A [DOI](https://doi.org) resolving to the zenodo record (optional)
    - `zenodo_record_id` - The ID of the zenodo record (optional)
- `content_type` - Form of archive. One of the following (required):
    - `compendium` - complete compendium for _inspection_
    - `workspace` - formless workspace for _creation_
- `filename` - Filename of your compendium. For now, only zip-files are supported. (optional)
    - if no `filename` is provided the first zip file is selected
    - multiple files are currently not supported

There must at least one url parameter that resolves to a zenodo record. I.e. one of the following:

### Examples

1. Zenodo Record URL (with optional filename parameter)

```bash
curl -F "content_type=compendium" \
    -F "zenodo_url=https://sandbox.zenodo.org/record/69114"  \
    -F "filename=metatainer.zip" \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium
```

2. DOI

```bash
curl -F "content_type=compendium" \
    -F "doi=10.5072/zenodo.69114"  \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium
```

3. Zenodo Record ID

```bash
curl -F "content_type=compendium" \
    -F "zenodo_record_id=69114"  \
    --cookie "connect.sid=<code string here>" \
     https://…/api/v1/compendium
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

For testing purposes you can use the following public shares.
They contain the a compendium with metadata.

- Sciebo: [`https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA`](https://uni-muenster.sciebo.de/index.php/s/G8vxQ1h50V4HpuA)
- Zenodo: [`https://sandbox.zenodo.org/record/69114`](https://sandbox.zenodo.org/record/69114)
