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
The keyword combined with spatial and temporal parameters are used to search for ERC which fall within the parameters set by the search.

### Example requests

Simple Query

- [http://o2r.uni-muenster.de/api/v1/search?q=*&from=[2014-01-01T00:00:00]&to=[2016-04-11T00:00:00]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences](http://o2r.uni-muenster.de/api/v1/search?q=*&from=[2014-01-01T00:00:00]&to=[2016-04-11T00:00:00]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences)

- [http://o2r.uni-muenster.de/api/v1/search?q=*&from=[WedApr02201400:00:00GMT+0200]&to=[SatJun10201700:00:00GMT+0200]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences](http://o2r.uni-muenster.de/api/v1/search?q=*&from=[WedApr02201400:00:00GMT+0200]&to=[SatJun10201700:00:00GMT+0200]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences)

Query with URL Encoding
- [http://o2r.uni-muenster.de/api/v1/search?q=*&from=Wed+Apr+02+2014+00%3A00%3A00+GMT%2B0200+%28CEST%29&to=Fri+Jun+09+2017+00%3A00%3A00+GMT%2B0200+%28CEST%29%0D%0A&coords=%5B%5B%5B-86.98%2C54.23%5D%2C%5B-86.98%2C84.06%5D%2C%5B-11.05%2C84.06%5D%2C%5B-11.05%2C54.23%5D%2C%5B-86.98%2C54.23%5D%5D%5D&keyword=geosciences](http://o2r.uni-muenster.de/api/v1/search?q=*&from=Wed+Apr+02+2014+00%3A00%3A00+GMT%2B0200+%28CEST%29&to=Fri+Jun+09+2017+00%3A00%3A00+GMT%2B0200+%28CEST%29%0D%0A&coords=%5B%5B%5B-86.98%2C54.23%5D%2C%5B-86.98%2C84.06%5D%2C%5B-11.05%2C84.06%5D%2C%5B-11.05%2C54.23%5D%2C%5B-86.98%2C54.23%5D%5D%5D&keyword=geosciences)

### Example Response

```json
{
"title":"Reproducible research in Geosciences",
"spatial":{
"coordinates":[[[-22,76,],[-27,65],[-57,65],[-59,76],[-22,76]]],
"type":"Polygon"
},
"temporal":{
"begin":"2014-08-01T22:00:00.000Z",
"end":"2015-03-30T12:35:41.142Z"
}}
```
### List of URL Parameters

The Search API and it's URL consist of certain parameters based on Elasticsearch DSL queries which help to fetch a specific ERC.

#### Parameters for Temporal Searching

`from` :- This takes in the value as a timestamp when the creation of ERC was started. (currently it's restricted to 2014-01-01 which can be modified on the basis of data).

`to` :- This takes in the value as a timestamp when the creation of ERC was ended.Current date and time can be entered as a value in this case.

The values from the parameters are used in a pre-configured Elasticsearch range query which queries the database for defined duration 
```bash
{
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
                            }
```
`metadata.o2r.temporal.begin` and `metadata.o2r.temporal.end` are the fields within the dataset which will be queried for the duration which is set by the URL parameters.

#### Parameters for Spatial Searching 

`coords` :- This should cater for the coordinates defined by the bounding box. A 2-d array of coordinates is expected as a parameter. The coordinates are to be 5 pairs of latitude longitude values describing a closed polygon.
The value from this parameter is used in a pre-configured Elasticsearch spatial query which applies a `geo_shape` filter to fetch the desired ERC according to spatial parameters.
```bash
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
                            }
```
The filter has been nested within a `boolean/must match` query so that it completely matches the documents being queried. The filter has been applied to the `metadata.o2r.spatial.geometry` field of the dataset with a `within` relation so that the ERC that matches the document's coordinates completely are fetched.

#### Parameters for Keyword Searching 
`keyword` :- Any word, phrase in the form of text that should be used to match the title of ERC.
A simple match query is used at the back-end to match the query value with the values in dataset
```bash
{
    "match" : { "metadata.o2r.title" : keyword}
  }
  ```
  ##### NOTE :
  The parameters should be used together and not seperatley as they have been coupled together to form one single boolean query as stated below so that a refined search is possible and ERC which passes all the criteria are fetched.
  
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
