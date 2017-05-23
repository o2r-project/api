# Compendium metadata

## Basics

Metadata in a compendium is stored in a directory `.erc`. This directory contains the normative metadata documents using a file naming scheme `<metadata_model>.<format>`, sometimes preprended with `metadata_` for clarity, e.g. `metadata_raw.json`, `metadata_o2r.json`, `zenodo.json`, or `datacite.xml`.

A copy of the files in this directory is kept in database for easier access, so every compendium returned by the API can contain different sub-properties in the metadata property. _This API always returns the database copy of the metadata elements._ You can download the respective files to access the normative metadata documents.

Both the files and the sub-properties are only available _on-demand_, so for example after a shipment to Zenodo is initiated. After creation the metadata is persisted to file and database.

The sub-properties and their features are

- `raw` contains raw metadata extracted automatically
- `o2r` holds the **main information for display** and is modelled according the the o2r metadata model. This metadata is first an automatic transformation of raw metadata and should then be checked by the uploading user during the upload process.
- `datacite` (TBD) holds DataCite XML
- `zenodo` holds [Zenodo](https://zenodo.org/) metadata for shipments made to Zenodo

**Note:** The information in each sub-property are subject to independent workflows and may differ from one another.

Future sub-properties might expose `enriched` or `harvested` metadata.

## Request and response

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "raw": {
      "title": "Programming with Data. Springer, New York, 1998. ISBN 978-0-387-98503-9.",
      "author": "John M. Chambers.   "
    },
    "o2r": {
      "title": "Programming with Data",
      "creator": "John M. Chambers",
      "year": 1998
    }, {
      …
    }
  },
  "created": …,
  "files": …
}
```

### URL parameters for metadata

- `:id` - compendium id

### Spatial MD

For discovery purposes, the Metadata will included extracted geojson bounding boxes, if suggested by the source files in a workspace (shapefiles, geojson files _TDB_, geotiffs _TDB_ or jpegs _TDB_).

The following structure will be made available per file:

````{json}
    "spatial": {
        "files": [
            {
                "geojson": {
                    "bbox": [
                        -2.362060546875,
                        52.0862573323384,
                        -1.285400390625,
                        52.649729197309426
                    ],
                    "geometry": {
                        "coordinates": [
                            [
                                [
                                    -2.362060546875,
                                    52.0862573323384
                                ],
                                [
                                    -1.285400390625,
                                    52.649729197309426
                                ]
                            ]
                        ],
                        "type": "Polygon"
                    },
                    "type": "Feature"
                },
                "source_file": "path/to/file1.geojson"
            },
            {
                "geojson": {
                    "bbox": [
                        7.595369517803192,
                        51.96245837645124,
                        7.62162297964096,
                        51.96966694957956
                    ],
                    "geometry": {
                        "coordinates": [
                            [
                                [
                                    7.595369517803192,
                                    51.96245837645124
                                ],
                                [
                                    7.62162297964096,
                                    51.96966694957956
                                ]
                            ]
                        ],
                        "type": "Polygon"
                    },
                    "type": "Feature"
                },
                "source_file": "path/to/file2.shp"
            }
        ],
        "union": {
            "geojson": {
                "bbox": [
                    -2.362060546875,
                    51.96245837645124,
                    7.62162297964096,
                    51.96245837645124
                ],
                "geometry": {
                    "coordinates": [
                        [
                            -2.362060546875,
                            51.96245837645124
                        ],
                        [
                            7.62162297964096,
                            51.96245837645124
                        ],
                        [
                            7.62162297964096,
                            52.649729197309426
                        ],
                        [
                            -2.362060546875,
                            52.649729197309426
                        ]
                    ],
                    "type": "Polygon"
                },
                "type": "Feature"
            }
        }
    }
```
The `spatial` key has a `union` bounding box, that wraps all extracted bounding boxes.

### URL parameters for metadata

- `:id` - compendium id

### GET metadata - example request and response

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "raw": {
      "title": "Programming with Data. Springer, New York, 1998. ISBN 978-0-387-98503-9.",
      "author": "John M. Chambers.   "
    },
    "o2r": {
      "title": "Programming with Data",
      "creator": "John M. Chambers",
      "year": 1998
    }, {
      …
    }
  },
  "created": …,
  "files": …
}
```

## Update metadata

The following endpoint can be used to update the `o2r` metadata elements.
_Only authors of a compendium can update the metadata._
All other metadata sub-properties are only updated by the platform itself.

### Metadata update request

```bash
curl -H 'Content-Type: application/json' \
  -X PUT \
  --cookie "connect.sid=<code string here>" \
  -d '{ "o2r": { "title": "Blue Book" } }' \
  /api/v1/compendium/:id/metadata
```

The request will _overwrite_ the existing metadata properties, so the full o2r metadata must be put with a JSON object called `o2r` at the root, even if only specific fields are changed.

### Metadata update response

The response contains an excerpt of a compendium with only the o2r metadata property.

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "o2r": {
      "title": "Blue Book"
    }
  }
}
```

This response is also available at `GET /api/v1/compendium/:id/metadata`.

### Metadata update error responses

```json
401 Unauthorized

{"error":"not authorized"}
```

```txt
400 Bad Request

"SyntaxError [...]"
```

```json
422 Unprocessable Entity

{"error":"JSON with root element 'o2r' required"}
```
