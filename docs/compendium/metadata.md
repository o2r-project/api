# Compendium metadata

## Basics

Metadata in a compendium is stored in a directory `.erc`. This directory contains the normative metadata documents using a file naming scheme `<PREFIX>_<MODEL>_<VERSION>.<FORMAT>` filled via each metadata mapping file found in the broker tool of the o2r metadata tool suite, the default prefix is `metadata`, e.g. `metadata_o2r_1.json`, `metadata_zenodo_1.json`, or `metadata_datacite_41.xml`. The filename of the extracted raw metadata has no versioning and is constantly found as `metadata_raw.json`.

A copy of the files in this directory is kept in database for easier access, so every compendium returned by the API can contain different sub-properties in the metadata property.
_This API always returns the database copy of the metadata elements._
You can download the respective files to access the normative metadata documents.

## Metadata formats

The files are available on demand, but metadata variants are created after each metadata update.

The sub-properties of the `metadata` and their content are

- `raw` contains raw metadata extracted automatically
- `o2r` holds the **main information for display** and is modelled according the the o2r metadata model. This metadata is reviewed by the user and the basis for translating to other metadata formats and also for [search](../search.md).
- `zenodo` holds [Zenodo](https://zenodo.org/) metadata for shipments made to Zenodo and is brokered from `o2r` metadata
- `zenodo_sandbox` holds [Zenodo](https://zenodo.org/) metadata for shipments made to Zenodo Sandbox, i.e. a clone of `zenodo` metadata

!!! note
    The information in each sub-property are subject to independent workflows and may differ from one another.
    The term **brokering** is used for translation from one metadata format into another.

## Metadata validation

Only valid metadata can be saved to a compendium.
The `o2r` metadata element is validated against a [JSON Schema](http://json-schema.org/) using the `validate` tool of [`o2r-meta`](https://github.com/o2r-project/o2r-meta).
The schema file is included in the `o2r-meta` repository: [https://raw.githubusercontent.com/o2r-project/o2r-meta/master/schema/json/o2r-meta-schema.json](https://raw.githubusercontent.com/o2r-project/o2r-meta/master/schema/json/o2r-meta-schema.json).

## Get all compendium metadata

`curl https://…/api/v1/$ID`

`GET /api/v1/compendium/:id`

Abbreviated example response:

```json
200 OK

{
  "id":"12345",
  "metadata": {
    "raw": {
      "title": "Programming with Data. Springer, New York, 1998. ISBN 978-0-387-98503-9.",
      "author": "John M. Chambers",
      …
    },
    "o2r": {
      "title": "Programming with Data",
      "creators": [
          {
              "name": "John M. Chambers"
          }
      ],
      "publication_date": 1998,
      …
    },
    "zenodo": {
      …
    }
  },
  "created": …,
  "files": …
}
```

## Get o2r metadata

The following endpoint allows to access _only_ the normative o2r-metadata element:

`curl https://…/api/v1/$ID/metadata`

`GET /api/v1/compendium/:id/metadata`

```json
200 OK

{
  "id":"compendium_id",
  "metadata": {
    "o2r": {
      …
    }
  }
}
```

### URL parameters

- `:id` - compendium id

### Spatial metadata

For discovery purposes, the metadata includes extracted [GeoJSON](http://geojson.org/) bounding boxes based on data files in a workspace.

Currently supported spatial data sources:

- [shapefiles](https://en.wikipedia.org/wiki/Shapefile)
[//]: # (- GeoJSON)
[//]: # (- GeoTIFF)
[//]: # (- GeoJPEG2000)

The following structure is made available per file:

```json
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

## Update metadata

The following endpoint can be used to update the `o2r` metadata elements.
All other metadata sub-properties are only updated by the service itself, i.e. brokered metadata.
After creation the metadata is persisted to both files and database, so updating the metadata via this endpoint allows to trigger a brokering process and to retrieve different metadata formats either via this metadata API or via downloading the respective file using the [download endpoint](download.md).

!!! note "Metadata update rights"

    Only authors of a compendium or users with the required [user level](../user/levels.md) can update a compendium's metadata.

### Metadata update request

```bash
curl -H 'Content-Type: application/json' \
  -X PUT \
  --cookie "connect.sid=<code string here>" \
  -d '{ "o2r": { "title": "Blue Book" } }' \
  /api/v1/compendium/:id/metadata
```

The request _overwrites_ the existing metadata properties, so the _full_ o2r metadata must be put with a JSON object called `o2r` at the root, even if only specific fields are changed.

!!! Note
    This endpoint allows only to update the `metadata.o2r` elements. All other properties of 

### URL parameters

- `:id` - compendium id

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

### Metadata update error responses

```json
401 Unauthorized

{"error":"not authorized"}
```

```json
400 Incomplete metadata (description property missing)

{
    "error":"Error updating metadata file, see log for details",
    "log": "[o2rmeta] 20180302.085940 received arguments: {'debug': True, 'tool': 'validate', 'schema': 'schema/json/o2r-meta-schema.json', 'candidate': '/tmp/o2r/compendium/1cAIr/data/.erc/metadata_o2r_1.json'}
    [o2rmeta] 20180302.085940 launching validator
    [o2rmeta] 20180302.085940 checking metadata_o2r_1.json against o2r-meta-schema.json
    [o2rmeta] 20180302.085940 !invalid: None is not of type 'string'
    
    Failed validating 'type' in schema['properties']['description']:
        {'type': 'string'}
        
        On instance['description']:
            None"
}
```

```json
400 Bad Request

"SyntaxError [...]"
```

```json
422 Unprocessable Entity

{"error":"JSON with root element 'o2r' required"}
```

## Other metadata properties

Besides the `metadata` element, a compendium persists some additional properties to reduce computation on the server, and to allows client applications to improve the user experience.

- `bag` - a boolean showing if the uploaded artefact was detected as a BagIt bag (detection file: `bagit.txt`)
- `compendium` - a boolean showing if the uploaded artefact was detected as a compendium (detection file: `erc.yml`)

**Example:**

(Properties `metadata` and `files` not shown for brevity.)

```json
{

    "id": "U9IZ7",
    "metadata": {},
    "created": "2017-01-01T00:00:42.000Z",
    "user": "0000-0002-1825-0097",
    "bag": false,
    "compendium": false,
    "files": {}
}
```
