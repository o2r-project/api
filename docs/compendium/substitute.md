# Substitution

Substitution is the combination of an base compendium, "base" for short, and an overlay compendium, or "overlay".
A user can choose files from the overlay to replace files of the base, or upload new files.
Additionally the user can choose, if the metadata of the base ERC will be adopted for substitution (`keepBase`) or there will be a new extraction of the metadata for the substituted ERC.
This new extraction is divided into two choices.
The user can let the new extracted metadata be merged into the existing metadata of the base ERC (`extractAndMerge` - **not implemented**) or just save the extracted metadata (`extract` - **not implemented**).

## Create substitution

`Create substitution` produces a new compendium with its own files in the storage and metadata in the database.
A substitution can be created with an HTTP `POST` request using `multipart/form-data` and content-type `JSON`.
Required content of the request are the identifiers of the base and overlay compendia and at least one pair of _substitution files_, consisting of a base file and an overlay file.

!!! Note
    A substitution process removes potentially existing packaging information, i.e. if the base compendium was a BagIt bag, the substitution will only contain the payload directory contents (`/data` directory).

    The overlay file is stripped of all paths and is copied directly into the substitution's root directory.

### Request

`POST /api/v1/substitution`

Request body for a new substitution:

```json
{
  "base": "G92NL",
  "overlay": "9fCTR",
  "substitutionFiles": [
    {
      "base": "climate-timeseries.csv",
      "overlay": "mytimeseries_data.csv"
    }
  ],
  "metadataHandling": "keepBase"
}
```

### Request body properties

- `base` - id of the base compendium
- `overlay` - id of the overlay compendium
- `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
  - `base` - name of the file from the base compendium
  - `overlay` - name of the overlay compendium that is exchanged for the original file
- `metadataHandling` - property to specify, if the metadata of the base ERC will be adopted (`keepBase` = **keep metadata** of base ERC) or there will be a new extraction of metadata, that will be merged into the metadata of the base ERC (`extractAndMerge` = **extract and merge metadata** for new ERC) or that will not be merged (`extract` = **extract metadata** of new ERC)


!!! note "Required user level"

    The user creating a new substitution must have the required [user level](../user/levels.md).

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

## View substituted Compendium

### Request

`curl https://.../api/v1/compendium/$ID`

`GET /api/v1/compendium/:id`

This request is handled as regular GET request of a compendium (see [View single compendium](/api/compendium/view/#view-single-compendium)).

### Response

A substituted compendium is be saved as a usual compendium, but with additional metadata specifying this as a substituted compendium and giving information about the substitution.

Example 01 - in case there are no conflicts between filenames of any base file and overlay file :

```json
200 OK

{
  "id": "oMMFn",
  ...
  "metadata": {
      ...
      "substitution": {
          "base": "G92NL",
          "overlay": "9fCTR",
          "substitutionFiles": [
            {
              "base": "climate-timeseries.csv",
              "overlay": "mytimeseries_data.csv",
              "filename": "climate-timeseries.csv"
            }
          ],
          "metadataHandling": "keepBase"
      },
      ...
  },
  "substituted": true,
  ...
}
```

Example 02 - in case the overlay file has the same filename as one of the existing base files and is in a sub-directory in the overlay compendium:

```json
200 OK

{
  "id": "oMMFn",
  ...
  "metadata": {
      ...
      "substitution": {
          "base": "G92NL",
          "overlay": "9fCTR",
          "substitutionFiles": [
            {
              "base": "climate-timeseries.csv",
              "overlay": "dataFiles/input.csv",
              "filename": "overlay_input.csv"
            }
          ],
          "metadataHandling": "keepBase"
      },
      ...
  },
  "substituted": true,
  ...
}
```

### Response additional metadata

- `metadata.substitution` - object, specifying information about the substitution
    - `base` - id of the base compendium
    - `overlay` - id of the overlay compendium
    - `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
        - `base` - name of the file from the base ERC
        - `overlay` - name of the file from the overlay ERC
        - `filename` - as seen in the examples above, `filename` will be created.
        If there is a conflict with any basefilename and an overlayfilename, the overlayfilename will get an additional "**overlay_**" prepended (see Example 02). *(optional add)*
    - `metadataHandling` - property to specify, if the metadata of the base ERC will be adopted (`keepBase` = **keep metadata** of base ERC) or there will be a new extraction of metadata, that will be merged into the metadata of the base ERC (`extractAndMerge` = **extract and merge metadata** for new ERC) or that will not be merged (`extract` = **extract metadata** of new ERC)
- `substituted` - will be set `true`

## List substituted Compendia

### Request

`curl https://.../api/v1/substitution`

`GET /api/v1/substitution`

### Response

The result is a list of compendia ids which were created by a substitution process.

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

If there are no substitutions yet, the returned list is empty.

```json
200 OK
{
  "results": [ ]
}
```

### Filter results with following parameters:

`curl https://.../api/v1/substitution?base=$BASE_ID&overlay=$OVERLAY_ID`

`GET /api/v1/substitution?base=base_id&overlay=overlay_id`

- Filter by `base`:

`curl https://.../api/v1/substitution?base=jfL3w`

`GET /api/v1/substitution?base=jfL3w`

Result is a list of substituted compendia based on the given base compendium:

```json
200 OK

{
  "results": [
    "wGmFn",
    …
  ]
}
```

- Filter by `overlay`:

`curl https://.../api/v1/substitution?overlay=as4Kj`

`GET /api/v1/substitution?overlay=as4Kj`

Result is a list of substituted compendia based on the given overlay compendium:

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

- Filter by `base` and `overlay`:

`curl https://.../api/v1/substitution?base=lO3Td&overlay=as4Kj`

`GET /api/v1/substitution?base=lO3Td&overlay=as4Kj`

Result is a list of substituted compendia based on the given base _and_ overlay compendium:

```json
200 OK

{
  "results": [
    "9pQ34",
    …
  ]
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

```json
400 Not Found

{"error":"base file is undefined"}
```

```json
400 Not Found

{"error":"overlay file is undefined"}
```

### URL parameters for substituted compendium lists

- `:base` - id of the base compendium that the results should be related to
- `:overlay` - id of the overlay compendium that the results should be related to
