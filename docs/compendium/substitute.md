# Substitute compendia

Introduction to substitution of two compendia. <br/>
A new compendium will be the result. Merged out of choosen data and files of two existing compendia, the new compendium will give the user an opportunity to exchange datasets or analysis and more or less create a new compendium.

## Create substitution


### Request

`GET /api/vl/substitution/:base_id/overlay_id`

### URL parameters for substititions

- `base_id`
- `overlay_id`

> initialize substitution with two compendia after choosing files on base-ercView

### Response

```json
200 OK

{
  "base_id": "base_id",
  "overlay_id": "overlay_id"
}
```

### URL parameters for substititions

- `base` ?
- `overlay` ?

### Error responses

```json
401 Unauthorized

{"error":"not authenticated or not allowed"}
```

```json
404 Not Found

{"error":"compendia ids not found"}
```

### Request

`POST /api/v1/substitution`

input of request-body for substitution <br/>
( where `checked` will be a list of files choosen for substitution )
```json
{
  "user": "user_id",
  "ercs": [
    {
      "id": "base_erc_id",
      "checked": [],
      "user": "creator_id"
    },
    {
      "id": "base_erc_id",
      "checked": [],
      "user": "creator_id"
    }
  ]
}
```

### Response

```json
200 OK

{
  "user": "user_orcid_id",
  "ercs": [
    {
      "id": "base_erc_id",
      "checked": [],
      "user": "creator_id"
    },
    {
      "id": "base_erc_id",
      "checked": [],
      "user": "creator_id"
    }
  ]
}
```

### URL parameters for substititions

- `base` ?
- `overlay` ?

### Error responses

```json
401 Unauthorized

{"error":"not authenticated or not allowed"}
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
