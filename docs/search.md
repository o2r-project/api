# Search

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

The **response** is `JSON` with the root element is `hits`, which has the same as the `hits` element from an Elasticsearch response but may not include internal fields such as `_index`, `_type`, and `_id`.

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

- `q` - search term(s)

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*](http://o2r.uni-muenster.de/api/v1/search?q=*)
- [http://o2r.uni-muenster.de/api/v1/search?q=spatial](http://o2r.uni-muenster.de/api/v1/search?q=spatial)

## Complex Search

A complex search is enabled via `POST` requests with a `JSON` payload as `HTTP POST` data (_not_ `multipart/form-data`) accepting an `application/json` content type as response.
Queries can include filters, aggregation and spatio-temporal operations as defined in the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html).

`curl -X POST -H 'Content-Type: application/json' 'https://.../api/v1/search' -d '$QUERY_DSL'`

**Example:**

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

The **response** structure is the same as for [simple search](#simple-search).

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
