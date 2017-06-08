# Search

## Indexed information

- compendium metadata
- text files in a compendium
- PDF documents in a compendium (TBD)

## Simple search

The search is based on [Elasticsearch](https://www.elastic.co/) and the regular [Elasticsearch search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html) is exposed at

```bash
http://…/api/v1/search
```

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*](http://o2r.uni-muenster.de/api/v1/search?q=*)
- [http://o2r.uni-muenster.de/api/v1/search?q=term](http://o2r.uni-muenster.de/api/v1/search?q=term)
- [http://o2r.uni-muenster.de/api/v1/search?q=*&fields=compendium_id](http://o2r.uni-muenster.de/api/v1/search?q=*&fields=compendium_id)

### Security

Only reading requsts, i.e. `GET` requests, are allowed at the moment. This means that Kibana cannot be run against this interface, and neither can complex queries requiring `POST` requests. `GET` requests with payloads are allowed.

Example query:

```bash
curl -XGET 'https://…/api/v1/search' -d '{
    "query": {
            "type" : {
                "value" : "jobs"
            }
        }
    }
}'
```

## Advanced Search 

Advanced Search is based on [Elasticsearch](https://www.elastic.co/). It comprises of spatio-temporal search and keyword search.

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*&from&to&coords&keyword](http://o2r.uni-muenster.de/api/v1/search?q=*&from&to&coords&keyword)
- [http://o2r.uni-muenster.de/api/v1/search?q=*&from=Wed+Apr+02+2014+00%3A00%3A00+GMT%2B0200+%28CEST%29&to=Fri+Jun+09+2017+00%3A00%3A00+GMT%2B0200+%28CEST%29%0D%0A&coords=%5B%5B%5B-74.33349609375%2C55.44771083630114%5D%2C%5B-74.33349609375%2C83.91787587317228%5D%2C%5B7.22900390625%2C83.91787587317228%5D%2C%5B7.22900390625%2C55.44771083630114%5D%2C%5B-74.33349609375%2C55.44771083630114%5D%5D%5D&keyword=geosciences](http://o2r.uni-muenster.de/api/v1/search?q=*&from=Wed+Apr+02+2014+00%3A00%3A00+GMT%2B0200+%28CEST%29&to=Fri+Jun+09+2017+00%3A00%3A00+GMT%2B0200+%28CEST%29%0D%0A&coords=%5B%5B%5B-74.33349609375%2C55.44771083630114%5D%2C%5B-74.33349609375%2C83.91787587317228%5D%2C%5B7.22900390625%2C83.91787587317228%5D%2C%5B7.22900390625%2C55.44771083630114%5D%2C%5B-74.33349609375%2C55.44771083630114%5D%5D%5D&keyword=geosciences)

### Advanced Search Query

```bash
{
                "query": {
                    "bool": {
                        "must": [{
                                "range": {
                                    "metadata.o2r.temporal.begin": {
                                        "from": from
                                    }
                                }
                            },
                            {
                                "range": {
                                    "metadata.o2r.temporal.end": {
                                        "to": to
                                    }
                                }
                            },
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
                                                    "coordinates": coords


                                                },
                                                "relation": "within"
                                            }
                                        }
                                    }
                                }
                            },
                            {
    "match" : { "metadata.o2r.title" : keyword }
  }
                        ]
                    }
                }
            }
```
## Suggesters - WORK IN PROGRESS

[Elasticsearch suggest API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters.html) 
