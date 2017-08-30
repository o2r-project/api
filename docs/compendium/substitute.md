# Substitute two compendia

Substitution is the combination of an base ERC and an overlay ERC.
A user can choose files from the overlay ERC that will replace files of the base ERC or will be uniquely added.

## Create substitution

`Create substitution` will produce a new ERC with metadata, saved to mongoDB.

### Request

`POST /api/v1/substitution`

input of request-body for substitution

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

- `base` - id of the base ERC
- `overlay` - id of the overlay ERC
- `substitutionFiles` - array of file substitutions specified by `base` and `overlay`
  - `base` - filename of the file from the base ERC
  - `overlay` - filename of the overlay ERC that will be exchanged for the original file

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

## Run substitution

`Run substitution` will run the analysis of a substitution in a docker container.
This is executed by a [job](http://o2r.info/o2r-web-api/job/).

## View substituted Compendium

### Request

`curl https://.../api/v1/compendium/$ID`

`GET /api/v1/compendium/:id`

This request will be handled as a GET-request of an usual compendium. ( [Click for more information.](http://o2r.info/o2r-web-api/compendium/view/#view-single-compendium) )

### Response

A substituted ERC will be saved as a usual ERC, but with additional metadata specifying this as a substituted ERC and giving information about the substitution.

Example 01 - in case there are no conflicts between filenames of any basefile and overlayfile :

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

Example 02 - in case the overlayfile has the same filename as one of the existing basefiles :

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
    - `filename` - as seen in the examples above, `filename` will be created if there is a conflict with any basefilename and an overlayfilename. In this case the overlayfilename will get an additional "**overlay_**" prepended (see Example 02). *(optional add)*

## List substituted Compendia

### Request

`curl https://.../api/v1/substitution`

`GET /api/v1/substitution`

### Response

Result will be a list of compendia ids that have been substituted

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

### Filter results with following parameters:

`curl https://.../api/v1/substitution?base=$BASE_ID&overlay=$OVERLAY_ID`

`GET /api/v1/substitution?base=base_id&overlay=overlay_id`

- Filter by `base`:

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

- Filter by `overlay`:

`curl https://.../api/v1/substitution?overlay=as4Kj`

`GET /api/v1/substitution?overlay=as4Kj`

Result will be a list of compendia ids that have been substituted out of a choosen overlay ERC

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

- Filter by `base` and `overlay`:

`curl https://.../api/v1/substitution?base=lO3Td&overlay=as4Kj`

`GET /api/v1/substitution?base=lO3Td&overlay=as4Kj`

Result will be a list of compendia ids that have been substituted out of a choosen base and overlay ERC

```json
200 OK

{
  "results":[
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

{"error":"base ERC not found"}
```

```json
404 Not Found

{"error":"overlay ERC not found"}
```

### URL parameters for substituted compendium lists

- `:base` - id of the base ERC that the results should be related to
- `:overlay` - id of the base ERC that the results should be related to
