# Shipment

Shipments are used to deliver ERCs to third party repositories or archives.

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

### URL parameters

- `id` - The identifier of a specific shipment.
- `compendium_id` - The identifier of a specific compendium.

### Error responses

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

### Body parameters
This requires the following parameters and conditions:

+ `compendium_id`
+ `recipient` (name of the repository; _currently only `"zenodo"` is possible_)
+ `cookie` user must be logged in with sufficient rights

Optionally, you can specifiy a custom `shipment_id`.


### Error responses

```json
400

{"error":"bad request"}
```


```json
403

{"error": "insufficient permissions"}
```



**Implemented:** Yes

**Stability:** 0 - subject to changes
