# Substitute two compendia

Substitution is the combination of an base erc and an overlay erc.
A user can choose files from the overlay erc that will be replaced with some of the base erc or uniquely added.

## Create substitution

### Request

`POST /api/v1/substitution`

input of request-body for substitution
```json
{
  "base": "base_erc_id",
  "substFiles": [
    {
      "original": "base_datei",
      "xchange": "overlay_datei"
    }
  ],
  "overlay": "overlay_erc_id",
}
```

### body parameters for substititions

- `base` - id of the base erc
- `substfiles` - array objects specified by `original` and `xchange`
  - `original` - filename of the file from the base erc
  - `xchange` - filename of the overlay erc that will be exchanged for the original file
- `overlay` - id of the overlay erc

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

### Request

`GET`

This request will be handled as a GET-request of an usual compendium. ( [Click for more information.](http://o2r.info/o2r-web-api/compendium/view/#view-single-compendium) )
