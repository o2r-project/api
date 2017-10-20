# Substitute two compendia

Substitution is the combination of an base ERC and an overlay ERC.
A user can choose files from the overlay ERC that will replace files of the base ERC, or add new files to the substitution.

## Create substitution

Creating a substitution produces a new ERC with its own metadata and files.
A substitution is created with an HTTP `POST` request using `multipart/form-data` and content-type `JSON`.
Required fields are the identifiers of base ERC and overlay ERC and at least one pair of substitution files, consisting of one base file and one overlay file.

### Created metadata and files

The substitution creation includes an update of the compendium metadata in the file **`erc.yml`**, which implements the actual substitution.
After creation, subsequent [jobs](http://o2r.info/o2r-web-api/job/) consider these settings.

The **files** of a substituted ERC comprise all base ERC files and the overlay files.
In case of a file naming conflict, the overlay file is preprended with `overlay_`.

### Request

`POST /api/v1/substitution`

**Example** request body:

```json
{
  "base": "G92NL",
  "overlay": "9fCTR",
  "substitutionFiles": [
    {
      "base": "climate-timeseries.csv",
      "overlay": "mytimeseries_data.csv"
    }
  ]
}
```

**Example** request body with embedded file upload:

```json
{
  "base": "G92NL",
  "overlay": "9fCTR",
  "substitutionFiles": [
    {
      "base": "climate-timeseries.csv",
      "overlay": {
        "filetype": "text/csv",
        "filename": "my-data.csv",
        "base64": "aWQsZGF0ZSx0ZW1wZXJhdHVyZVxuMSwyMDE3LTAxLTAxLDE3XG4yLDIwMTctMDEtMDIsNDIK"
      }
    }
  ]
}
```

The above example was created as follows:

```bash
$ echo "id,date,temperature\n1,2017-01-01,17\n2,2017-01-02,42" >> my-data.csv
$ base64 -w 0 my-data.csv
aWQsZGF0ZSx0ZW1wZXJhdHVyZVxuMSwyMDE3LTAxLTAxLDE3XG4yLDIwMTctMDEtMDIsNDIK
$ echo aWQsZGF0ZSx0ZW1wZXJhdHVyZVxuMSwyMDE3LTAxLTAxLDE3XG4yLDIwMTctMDEtMDIsNDIK | base64 -d
id,date,temperature\n1,2017-01-01,17\n2,2017-01-02,42
$ mimetype my-data.csv
my-data.csv: text/csv
```

### Request body properties

- `base` - id of the base ERC
- `overlay` - id of the overlay ERC
- `substitutionFiles` - array of file substitutions specified each by one `base` and one `overlay` property
  - `base` - filename of a file from the base ERC
  - `overlay` - either a reference to a file in the overlay ERC, or embedded file upload
    - _overlay file_: filename of a file in the overlay ERC, which is exchanged for the file from the base ERC
    - _file upload_: JSON object with metadata and content of the file in the properties `filetype`, `filename` and `base64`, the latter being a [Base64](https://en.wikipedia.org/wiki/Base64) encoding of the file.

!!! note "Required user level"

    The user creating a new substitution must have the required [user level](../user.md#user-levels).

### Response

```json
201 CREATED

{
  "id": "oMMFn"
}
```

### Error responses

```json
401 Unauthorized

{"error":"not authenticated"}
```

```json
401 Unauthorized

{"error":"not allowed"}
```

```json
404 Not Found

{"error":"base ERC not found"}
```

```json
404 Not Found

{"error":"overlay ERC not found"}
```

## View substituted compendium

### Request

This request is the same as for a regular compendium, see [view compendium](view.md#view-single-compendium).

### Response

A substituted ERC response contains additional metadata (a) marking it as a substituted ERC with the property `metadata.substituted`, and (b) giving information about the substitution in the property `substitution`.

**Example** (no naming conflicts):

```json
200 OK

{
  "id": "oMMFn",
  ...
  "metadata": {
      ...
      "substituted": true,
      "substitution": {
          "base": "G92NL",
          "overlay": "9fCTR",
          "substitutionFiles": [
            {
              "base": "climate-timeseries.csv",
              "overlay": "mytimeseries_data.csv",
              "filename": "climate-timeseries.csv"
            },
            {
              "base": "analysis-settings.xml",
              "overlay": "better-settings.txt",
              "filename": "analysis-settings.xml"
            }
          ]
      },
      ...
      },
  ...
}
```

**Example** in case the overlay file has the same filename as one of the existing base files :

```json
200 OK

{
  "id": "oMMFn",
  ...
  "metadata": {
      ...
      "substituted": true,
      "substitution": {
          "base": "G92NL",
          "overlay": "9fCTR",
          "substitutionFiles": [
            {
              "base": "climate-timeseries.csv",
              "overlay": "input.csv",
              "filename": "overlay_input.csv"
            }
          ]
      },
      ...
      },
  ...
}
```

### Response additional metadata

- `substituted` - will be set `true`
- `substitution` - object, specifying information about the substitution
  - `base` - id of the base ERC
  - `overlay` - id of the overlay ERC
  - `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
    - `base` - filename of the file from the base ERC
    - `overlay` - filename of the file from the overlay ERC
    - `filename` - if there is a conflict with any base filename and an overlay filename, the overlay file is actually stored with `overlay_` prepended to the file name, which is stored in this property.

## List substituted compendia

### Request

`curl https://.../api/v1/substitution`

`GET /api/v1/substitution`

### Response

Result will be a list of compendia ids which are created by a substitution process.

```json
200 OK

{
  "results":[
    "oMMFn",
    "asdi5",
    "nb2sg",
    …
  ]
}
```

### Filter

Results can be filtered with the parameters `base` and `overlay`.

`curl https://.../api/v1/substitution?base=$BASE_ID&overlay=$OVERLAY_ID`

`GET /api/v1/substitution?base=base_id&overlay=overlay_id`

**Example** for filtering by `base`:

`curl https://.../api/v1/substitution?base=jfL3w`

`GET /api/v1/substitution?base=jfL3w`

Result will be a list of compendia ids that have been substituted out of a choosen base ERC

```json
200 OK

{
  "results":[
    "wGmFn",
    …
  ]
}
```

**Example** for filtering by `overlay`:

`curl https://.../api/v1/substitution?overlay=as4Kj`

`GET /api/v1/substitution?overlay=as4Kj`

Result will be a list of compendia ids that have been substituted out of a chosen overlay ERC.

```json
200 OK

{
  "results":[
    "9pQ34",
    "1Tnd3",
    …
  ]
}
```

**Example** for filtering with both `base` and `overlay`:

`curl https://.../api/v1/substitution?base=lO3Td&overlay=as4Kj`

`GET /api/v1/substitution?base=lO3Td&overlay=as4Kj`

The result is a list of compendia ids that have been substituted out of a chosen base and overlay ERC.

```json
200 OK

{
  "results":[
    "9pQ34",
    …
  ]
}
```

### URL parameters

- `:base` - id of the base ERC of substitutions in the result
- `:overlay` - id of the base ERC of substitutions in the result

### Error responses

```json
401 Unauthorized

{"error":"not authenticated"}
```

```json
401 Unauthorized

{"error":"not allowed"}
```

```json
404 Not Found

{"error":"base ERC not found"}
```

```json
404 Not Found

{"error":"overlay ERC not found"}
```
