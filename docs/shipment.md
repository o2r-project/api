# Ship compendia and metadata

Shipments are used to deliver ERCs or their metadata to third party repositories or archives. This section covers shipment related requests, including repository file management.

## List shipments

Will return the complete list of shipments, currently without pagination.

`curl https://…/api/v1/shipment`

`GET /api/v1/shipment`

```json
200

{
  "shipments": ["dc351fc6-314f-4947-a235-734ab5971eff", "..."]
}
```

You can also get only the shipments belonging to a specific id or compendium id.

`curl http://…/api/v1/shipment?compendium_id=4XgD9`

`GET /api/v1/shipment?compendium_id=4XgD97`

```json
200 

{
  "last_modified": "2016-12-12 10:34:32.001475",
  "recipient": "zenodo",
  "id": "dc351fc6-314f-4947-a235-734ab5971eff",
  "deposition_id": "63179",
  "user": "0000-0001-6021-1617",
  "status": "delivered",
  "compendium_id": "4XgD9",
  "deposition_url": "https://sandbox.zenodo.org/record/63179"
}
```

_Note that returned deposition urls from Zenodo (records) will only be active after publishing._

### URL parameters for shipment lists

- `id` - The identifier of a specific shipment.
- `compendium_id` - The identifier of a specific compendium.

### Error responses for shipment lists

```json
400

{"error":"bad request"}
```


## New shipment

You can start a transmission to a repository at the same endpoint using a `POST` request.

`curl https://…/api/v1/shipment`

`POST /api/v1/shipment`

```json
200

{
  "recipient": "zenodo",
  "id": "dc351fc6-314f-4947-a235-734ab5971eff"
}
```

### File management in a repository depot

## Get a list of all files that are in a depot

`curl https://…/api/v1/shipment
-H "Content-Type: application/json"
--data '[{"action":"r"}, {"recipient":"zenodo"}, {"depot": "12345"}]'
`

```json
200

{
  "checksum": "2345720d53e9dbac16b42e88d9a06f4f", 
  "filename": "4XgD9.zip", 
  "filesize": 393320, 
  "id": "110d667c-7691-4fc9-93e7-5652a52df6f2"
  ...
}
```

## Delete a specific file from a depot

`curl https://…/api/v1/shipment
-H "Content-Type: application/json"
--data '[{"action":"d"}, {"recipient":"zenodo"}, {"depot": "12345"}, {"file_id": "110d667c-7691-4fc9-93e7-5652a52df6f2"]'
`

```json
204

{
"deleted": "110d667c-7691-4fc9-93e7-5652a52df6f2"
}
```

### Body parameters for new shipment creation

This requires the following parameters and conditions:

- `compendium_id`
- `recipient` (name of the repository; _currently only `"zenodo"` is possible_)
- `cookie` user must be logged in with sufficient rights

Optionally, you can specifiy a custom `shipment_id`.

### Error responses for new shipment creation

```json
400

{"error":"bad request"}
```


```json
403

{"error": "insufficient permissions"}
```
