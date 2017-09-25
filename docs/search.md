# Search

The search is based on [Elasticsearch](https://www.elastic.co/) and the regular [Elasticsearch search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html).

## Indexed information

- compendium metadata
- text files in a compendium
- PDF documents in a compendium (TBD)

## Simple search

A simple search allows searching for search terms.

`curl https://.../api/v1/search?q=$SEARCHTERM`

`GET /api/v1/search?q=Reproducible`

```json
200 ok

{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1.0586987,
    "hits": [
      {
        "_index": "o2r",
        "_type": "compendia",
        "_id": "4",
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

### Query parameters for simple search

- `q` - Searchterm

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*](http://o2r.uni-muenster.de/api/v1/search?q=*)
- [http://o2r.uni-muenster.de/api/v1/search?q=term](http://o2r.uni-muenster.de/api/v1/search?q=term)

### Complex Search

A complex search is enabled via `POST` requests with payload. This allows e.g. filtering, aggregation and spatio-temporal search. The payload MUST be a [Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)).

`curl -XPOST 'http://../api/v1/search' -d '$QUERY_DSL'`

`POST /api/v1/search`

```json
200 ok

{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1.0586987,
    "hits": [
      {
        "_index": "o2r",
        "_type": "compendia",
        "_id": "4",
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

### Example request

```bash
curl -XPOST 'https://o2r.uni-muenster.de/api/v1/search' -d '{
    "index": "o2r",
    "body": {
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
    }
}'
```

## Suggesters - WORK IN PROGRESS

[Elasticsearch suggest API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters.html) 