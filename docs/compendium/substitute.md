# Substitute two compendia

Substitution is the combination of an base ERC and an overlay ERC.
A user can choose files from the overlay ERC that will replace files of the base ERC or will be uniquely added.

## Create substitution

`Create substitution` will produce a new ERC with metadata, saved to mongoDB.

### Request

`POST /api/v1/substitution`

input of request-body for substitution(create)

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

`Run substitution` will produce a new ERC with metadata, saved to mongoDB, and also run the substitution in a docker container.

### Request

`POST /api/v1/substitution/run`

input of request-body for substitution(run)

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
  "id": "oMMFn",
  "job_id": "asdi5"
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

```json
500 Internal Server Error

{"error":"Error during substitution"}
```


## View single Compendium

### Request

`curl https://.../api/v1/compendium/$ID`

`GET /api/v1/compendium/:id`

This request will be handled as a GET-request of an usual compendium. ( [Click for more information.](http://o2r.info/o2r-web-api/compendium/view/#view-single-compendium) )

### Response

additional metadata of a substituted ERC

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

## List substituted Compendia

### Request

`curl https://.../api/v1/substitutions`

`GET /api/v1/substitutions`

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

`curl https://.../api/v1/substitutions?base=$BASE_ID&overlay=$OVERLAY_ID`

`GET /api/v1/substitutions?base=base_id&overlay=overlay_id`

- Filter by `base`:

`curl https://.../api/v1/substitutions?base=jfL3w`

`GET /api/v1/substitutions?base=jfL3w`

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

`curl https://.../api/v1/substitutions?overlay=as4Kj`

`GET /api/v1/substitutions?overlay=as4Kj`

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

`curl https://.../api/v1/substitutions?base=lO3Td&overlay=as4Kj`

`GET /api/v1/substitutions?base=lO3Td&overlay=as4Kj`

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
