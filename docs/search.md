# Search 🚧 UNDER DEVELOPMENT 🚧

------

🚧 These endpoints are _not_ available on the public demo server. 🚧

------

The search uses a document database to provide high speed and powerful search capabilities for compendia, including spatial and temporal properties.

The search structure is based on [Elasticsearch](https://www.elastic.co/) and thereby eases an implementation, because the requests and responses shown here can be directly mapped to respectively from [Elasticsearch's API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html).

**Indexed information:**

- compendium _metadata_ (including harvested and user-edited metadata such as temporal ranges and spatial extents)
- _full texts_ of text files in a compendium

## Simple search

A simple search allows searching for search terms using an `HTTP GET` request accepting `application/json` content type.

`curl -H 'Content-Type: application/json' https://.../api/v1/search?q=$SEARCHTERM`

`GET /api/v1/search?q=Reproducible`

`GET /api/v1/search?q=great reproducible research`

The **response** is `JSON` with the root element is `hits`, which has the same as the `hits` element from an Elasticsearch response but does not include internal fields such as `_index`, `_type`, and `_id`.

```json
200 ok

{
  "hits": {
    "total": 1,
    "max_score": 1.0586987,
    "hits": [
      {
        "_score": 1.0586987,
        "_source": {
          "metadata": {
            "o2r": ...
          },
        }
      }
    ]
  }
}
```

!!! Note
    The available metadata is a synced clone of the compendium metadata stored in the main database.
    For more information on the mapping from the main database to the search database, take a look at the [`o2r-finder` microservice](https://github.com/o2r-project/o2r-finder).

### Query parameters for simple search

- `q` - search term(s), must be [URL-encoded](https://en.wikipedia.org/wiki/Percent-encoding)
- `resources` - a comma-separated list of resources to include in the search; supported values are
  - `compendia`
  - `jobs`
  - `all` (default)

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*](http://o2r.uni-muenster.de/api/v1/search?q=*)
- [http://o2r.uni-muenster.de/api/v1/search?q=europe temperature data analysis](http://o2r.uni-muenster.de/api/v1/search?q=europe temperature data analysis)
- [http://o2r.uni-muenster.de/api/v1/search?q=europe%20temperature%20data%20analysis](http://o2r.uni-muenster.de/api/v1/search?q=europe%20temperature%20data%20analysis)
- [http://o2r.uni-muenster.de/api/v1/search?q=10.5555%2F12345678](http://o2r.uni-muenster.de/api/v1/search?q=10.5555%2F12345678)
- [http://o2r.uni-muenster.de/api/v1/search?q=geo&resources=compendia](http://o2r.uni-muenster.de/api/v1/search?q=geo&resources=compendia)
- [http://o2r.uni-muenster.de/api/v1/search?q=failure&resources=jobs](http://o2r.uni-muenster.de/api/v1/search?q=failure&resources=jobs)

## Complex Search

A complex search is enabled via `POST` requests with a `JSON` payload as `HTTP POST` data (_not_ `multipart/form-data`) accepting an `application/json` content type as response.
Queries can include filters, aggregation and spatio-temporal operations as defined in the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html).

`curl -X POST -H 'Content-Type: application/json' 'https://.../api/v1/search' -d '$QUERY_DSL'`

The **response** structure is the same as for [simple search](#simple-search).

!!!Note
    Use the index names `compendia` and `jobs` in a terms query to only retrieve one resource type.

### Query fields  for complex search

The following fields are especially relevant to build queries.

- `metadata.o2r.temporal.begin` and `metadata.o2r.temporal.end` provide a compendium's temporal extent
- `metadata.o2r.spatial.geometry` has the compendium's spatial extent

Besides these fields, all metadata of the [`o2r` metadata format](compendium/metadata.md#metadata-formats) can be used.

### Examples

#### Temporal search

```bash
POST /api/v1/search -d '{
  "query": {
      "bool": {
          "must": {
              "match_all": {}
          },
          "filter": [
              {
                  "range": {
                      "metadata.o2r.temporal.begin": {
                          "from": "2015-03-01T00:00:00.000Z"
                      }
                  }
              },
              {
                  "range": {
                      "metadata.o2r.temporal.end": {
                          "to": "2017-10-01T00:00:00.000Z"
                      }
                  }
              }
          ]
      }
  },
  "from": 0,
  "size": 10
}'
```

#### Spatial search

```json
{
    "bool": {
        "must": {
            "match_all": {}
         },
         "filter": {
              "geo_shape": {
                   "metadata.o2r.spatial.geometry": {
                        "shape": {
                            "type": "polygon",
                            "coordinates": [... GeoJSON coordinates...]
                         },
                         "relation": "within"
                    }
               }
          }
     }
}
```

In this example a filter has been nested within a [boolean/must match](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html) query.
The filter has been applied to the `metadata.o2r.spatial.geometry` field of the dataset with a `within` relation so that only compendia with a spatial extent completely contained in the provided shape are fetched.

#### Resource search

```json
{
    "query": {
        "terms": {
            "_index": ["compendia"]
        }
    }
}
```

#### Response

```json
200 ok

{
  "hits": {
    "total": 1,
    "max_score": 1.0586987,
    "hits": [
      {
        "_score": 1.0586987,
        "_source": {
          "metadata": {
            "o2r": ...
          },
        }
      }
    ]
  }
}
```

