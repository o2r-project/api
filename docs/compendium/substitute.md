# Substitute two compendia

Substitution is the combination of an base ERC and an overlay ERC.
A user can choose files from the overlay ERC that will replace files of the base ERC or will be uniquely added.

## Create substitution

### Request

`POST /api/v1/substitution`

input of request-body for substitution
```json
{
  "base": "<base ERC id>",
  "overlay": "<overlay ERC id>",
  "substitutionFiles": [
    {
      "original": "<filename of base ERC>",
      "xchange": "<filename of overlay ERC>"
    }
  ]
}
```

### Request body properties

- `base` - id of the base ERC
- `substfiles` - array of file substitutions specified by `original` and `xchange`
  - `original` - filename of the file from the base ERC
  - `xchange` - filename of the overlay ERC that will be exchanged for the original file
- `overlay` - id of the overlay ERC

### Response

```json
201 CREATED

{
  "id": "new_erc_id"
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

{"error":"base erc not found"}
```

```json
404 Not Found

{"error":"overlay erc not found"}
```

```json
500 Internal Server Error

{"error":"Error during substitution"}
```

## View single Compendium

### Request

`GET /api/v1/compendium/:id`

This request will be handled as a GET-request of an usual compendium. ( [Click for more information.](http://o2r.info/o2r-web-api/compendium/view/#view-single-compendium) )

### Response

additional metadata of a substituted ERC
```json
{
  ...
  "metadata": {
      ...
      "substitution": true,
      "overlay": {
          "id": "<overlay ERC id>",
          "substitutionFiles": [
            {
              "original": "<filename of base ERC>",
              "xchange": "<filename of overlay ERC>"
            }
          ]
      },
      ...
      },
  ...
}
```

## View substituted Compendia

### Request

`GET /api/v1/substitutions/:id`

### Response

Result will be a list of compendia ids that have been substituted out of a choosen base ERC
```json
200 OK
{
  "results":[
    "nkm4L",
    "asdi5",
    "nb2sg",
    …
  ]
}
```

### URL parameters for substititions

- `:id` - id of the base ERC
