# Substitution

Substitution is the combination of an base compendium and an overlay compendium.
A user can choose files from the overlay compendium that will replace files of the base compendium, or add new files to the substitution.

## Create substitution

Creating a substitution produces a new compendium with its own metadata and files.
A substitution is created with an HTTP `POST` request using `multipart/form-data` and content-type `JSON`.
Required fields are the identifiers of base compendium and overlay compendium and at least one pair of _substitution files_, consisting of one base file and one overlay file.

!!! Note
    A substitution process removes potentially existing packaging information, i.e. if the base compendium was a BagIt bag, the substitution will only contain the payload directory contents (`/data` directory).

    The overlay file is stripped of all paths and is copied directly into the substitution's root directory.
    The original path is preserved in the substitution metadata.

### Created metadata and files

The substitution creation includes an update of the compendium metadata in the file **`erc.yml`**, which implements the actual substitution.
After creation, subsequent [jobs](http://o2r.info/o2r-web-api/job/) consider these settings.

The **files** of a substituted compendium comprise all base compendium files and the overlay files.
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

  - `base` - name of the file from the base compendium
  - `overlay` - either a reference to a file in the overlay ERC, or embedded file upload
    - _overlay file_: filename of a file in the overlay ERC, which is exchanged for the file from the base ERC
    - _file upload_: JSON object with metadata and content of the file in the properties `filetype`, `filename` and `base64`, the latter being a [Base64](https://en.wikipedia.org/wiki/Base64) encoding of the file.
- `base` - id of the base compendium
- `overlay` - id of the overlay compendium
- `substitutionFiles` - array of file substitutions specified by `base` and `overlay`

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

{"error":"base compendium not found"}
```

```json
404 Not Found

{"error":"overlay compendium not found"}
```

## View substituted compendium

### Request

This request is the same as for a regular compendium, see [view compendium](view.md#view-single-compendium).

### Response

A substituted compendium is be saved as a usual compendium, but with additional metadata specifying this as a substituted compendium and giving information about the substitution.

**Example** without naming conflicts:

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

**Example** with naming conflicts and overlay from sub-directory:

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
              "overlay": "dataFiles/input.csv",
              "filename": "overlay_input.csv"
            }
          ]
      },
      ...
      },
  ...
}
```

Note that the base file must not be the file causing the naming conflict.

### Response additional metadata

- `substituted` - is `true`
- `substitution` - object, specifying information about the substitution
  - `base` - id of the base compendium
  - `overlay` - id of the overlay compendium
  - `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
    - `base` - filename of the file from the base compendium
    - `overlay` - filename of the file from the overlay compendium
    - `filename` - as seen in the examples above, `filename` is created if there is a conflict with any base file name and an overlay file name. In this case the overlay file name is given the prefix `overlay_` (see Example 02).

## List substituted compendia

### Request

`curl https://.../api/v1/substitution`

`GET /api/v1/substitution`

### Response

Result will be a list of compendia ids which are created by a substitution process.

```json
200 OK

{
  "results": [
    "oMMFn",
    "asdi5",
    "nb2sg",
    …
  ]
}
```

### Filter
If there are no substitutions yet, the returned list is empty.

```json
200 OK
{
  "results": [ ]
}
```

Results can be filtered with the parameters `base` and `overlay`.

`curl https://.../api/v1/substitution?base=$BASE_ID&overlay=$OVERLAY_ID`

`GET /api/v1/substitution?base=base_id&overlay=overlay_id`

**Example** for filtering by `base`:

`curl https://.../api/v1/substitution?base=jfL3w`

`GET /api/v1/substitution?base=jfL3w`

Result is a list of compendia ids that have been substituted using the given base:

```json
200 OK

{
  "results": [
    "wGmFn",
    …
  ]
}
```

**Example** for filtering by `overlay`:

`curl https://.../api/v1/substitution?overlay=as4Kj`

`GET /api/v1/substitution?overlay=as4Kj`

Result is be a list of compendia ids that have been substituted using the given overlay:

```json
200 OK

{
  "results": [
    "9pQ34",
    "1Tnd3",
    …
  ]
}
```

**Example** for filtering with both `base` and `overlay`:

`curl https://.../api/v1/substitution?base=lO3Td&overlay=as4Kj`

`GET /api/v1/substitution?base=lO3Td&overlay=as4Kj`

Result is be a list of compendia ids that have been substituted using the given base and overlay:

```json
200 OK

{
  "results": [
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

{"error":"base compendium not found"}
```

```json
404 Not Found

{"error":"overlay compendium not found"}
```

### URL parameters for substituted compendium lists

- `:base` - id of the base compendium that the results should be related to
- `:overlay` - id of the overlay compendium that the results should be related to
