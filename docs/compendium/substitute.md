# Substitution

Substitution is the combination of an base compendium, "base" for short, and an overlay compendium, or "overlay".
A user can choose files from the overlay that will replace files of the base or will be uniquely added.

## Create substitution

`Create substitution` produces a new compendium with its own files in the storage and metadata in the database.
A substitution can be created with an HTTP `POST` request using `multipart/form-data` and content-type `JSON`.
Required content of the request are the identifiers of the base and overlay compendia and at least one pair of _substitution files_, consisting of a base file and an overlay file.

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
  ]
}
```

### Request body properties

- `base` - id of the base compendium
- `overlay` - id of the overlay compendium
- `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
  - `base` - name of the file from the base compendium
  - `overlay` - name of the overlay compendium that is exchanged for the original file

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

## View substituted Compendium

### Request

`curl https://.../api/v1/compendium/$ID`

`GET /api/v1/compendium/:id`

This request will be handled as a GET-request of an usual compendium. ( [Click for more information.](http://o2r.info/o2r-web-api/compendium/view/#view-single-compendium) )

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
      "substituted": true,
      "substitution": {
          "base": "G92NL",
          "overlay": "9fCTR",
          "substitutionFiles": [
            {
              "base": "climate-timeseries.csv",
              "overlay": "mytimeseries_data.csv",
              "filename": "climate-timeseries.csv"
            }
          ]
      },
      ...
      },
  ...
}
```

Example 02 - in case the overlay file has the same filename as one of the existing base files:

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
  - `base` - id of the base compendium
  - `overlay` - id of the overlay compendium
  - `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
    - `base` - filename of the file from the base compendium
    - `overlay` - filename of the file from the overlay compendium
    - `filename` - as seen in the examples above, `filename` will be created if there is a conflict with any base file name and an overlay file name. In this case the overlay file name will get the prefix `overlay_` (see Example 02).

## List substituted Compendia

### Request

`curl https://.../api/v1/substitution`

`GET /api/v1/substitution`

### Response

The result is be a list of compendia ids that have been substituted:

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

Result will be a list of compendia ids that have been substituted using the given base:

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

Result will be a list of compendia ids that have been substituted using the given overlay:

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

Result will be a list of compendia ids that have been substituted using the given base and overlay:

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

### URL parameters for substituted compendium lists

- `:base` - id of the base compendium that the results should be related to
- `:overlay` - id of the overlay compendium that the results should be related to
