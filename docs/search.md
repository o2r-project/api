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

- [https://…/api/v1/search?q=*&from=[2014-01-01T00:00:00]&to=[2016-04-11T00:00:00]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences](http://o2r.uni-muenster.de/api/v1/search?q=*&from=[2014-01-01T00:00:00]&to=[2016-04-11T00:00:00]&coords=[[[-86.98,54.23],[-86.98,84.06],[-11.05,84.06],[-11.05,54.23],[-86.98,54.23]]]&keyword=geosciences)

Query with URL Encoding
- [https://…/api/v1/search?q=*&from=2014-01-01T00%3A00%3A00&to=2016-04-11T00%3A00%3A00&coords=%5B%5B%5B-86.98%2C54.23%5D%2C%5B-86.98%2C84.06%5D%2C%5B-11.05%2C84.06%5D%2C%5B-11.05%2C54.23%5D%2C%5B-86.98%2C54.23%5D%5D%5D&keyword=geosciences](https://…/api/v1/search?q=*&from=2014-01-01T00%3A00%3A00&to=2016-04-11T00%3A00%3A00&coords=%5B%5B%5B-86.98%2C54.23%5D%2C%5B-86.98%2C84.06%5D%2C%5B-11.05%2C84.06%5D%2C%5B-11.05%2C54.23%5D%2C%5B-86.98%2C54.23%5D%5D%5D&keyword=geosciences)

### Example Response


```json
{
        "_index" : "test",
        "_type" : "test1",
        "_id" : "2",
        "_score" : 3.287682,
        "_source" : {
          "createdAt" : "2017-03-30T12:36:28.061Z",
          "updatedAt" : "2017-03-30T12:36:28.061Z",
          "id" : "g5G4c",
          "user" : "0000-0002-1194-2058",
          "metadata" : {
            "raw" : {
              "author" : [
                {
                  "affiliation" : [ ],
                  "name" : "Markus Konkol",
                  "orcid" : "0000-0002-4898-0314"
                }
              ],
              "community" : "o2r",
              "date" : "30 November 2016",
              "depends" : [
                {
                  "category" : "CRAN Top100",
                  "identifier" : "shiny",
                  "packageSystem" : "https://cloud.r-project.org/",
                  "version" : null
                },
                {
                  "category" : "none",
                  "identifier" : "likert",
                  "packageSystem" : "https://cloud.r-project.org/",
                  "version" : null
                }
              ],
              "description" : null,
              "ercIdentifier" : "g5G4c",
              "file" : {
                "filename" : "main.Rmd",
                "filepath" : "g5G4c/data/main.Rmd",
                "mimetype" : "text/markdown"
              },
              "generatedBy" : "o2r-meta metaextract.py",
              "inputfiles" : [
                "/tmp/o2r/compendium/g5G4c/data/quest.csv"
              ],
              "interaction" : {
                "interactive" : true
              },
              "keywords" : [ ],
              "license" : null,
              "output" : {
                "html_document" : {
                  "number_sections" : true
                }
              },
              "paperLanguage" : [
                "en"
              ],
              "paperSource" : "main.Rmd",
              "publicationDate" : null,
              "r_comment" : [
                {
                  "feature" : "comment",
                  "line" : 29,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 32,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 37,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 81,
                  "text" : "Participants"
                },
                {
                  "feature" : "comment",
                  "line" : 84,
                  "text" : "What are you doing in the context of scientific publications"
                },
                {
                  "feature" : "comment",
                  "line" : 86,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 89,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 92,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 118,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 119,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 120,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 123,
                  "text" : "What are your research fields"
                },
                {
                  "feature" : "comment",
                  "line" : 192,
                  "text" : "Please tell us your age"
                },
                {
                  "feature" : "comment",
                  "line" : 198,
                  "text" : "Please tell us your gender"
                },
                {
                  "feature" : "comment",
                  "line" : 203,
                  "text" : "Reproducible research"
                },
                {
                  "feature" : "comment",
                  "line" : 237,
                  "text" : "Interaction"
                },
                {
                  "feature" : "comment",
                  "line" : 239,
                  "text" : "Relating to your last five publications"
                },
                {
                  "feature" : "comment",
                  "line" : 262,
                  "text" : "While reading a scientific publication that is related to my own research work"
                },
                {
                  "feature" : "comment",
                  "line" : 273,
                  "text" : "It would be useful for my research work"
                },
                {
                  "feature" : "comment",
                  "line" : 283,
                  "text" : "For my research work I would like to search for other scientific publications on the web by using"
                }
              ],
              "r_input" : [
                {
                  "feature" : "data input",
                  "line" : 8,
                  "text" : "quest.csv"
                }
              ],
              "r_output" : [
                {
                  "feature" : "result",
                  "line" : 67,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 69,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 76,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 77,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 112,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 118,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 119,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 120,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 179,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 182,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 183,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 184,
                  "text" : "print"
                }
              ],
              "recordDateCreated" : "2017-03-30",
              "runtime" : "shiny",
              "softwarePaperCitation" : null,
              "spatial" : {
                "files" : [ ],
                "union" : [ ]
              },
              "temporal" : {
                "begin" : "2016-11-30T00:00:00",
                "end" : "2016-12-08T13:55:02"
              },
              "title" : "Reproducible research in Geosciences",
              "version" : null
            },
            "o2r" : {
              "author" : [
                {
                  "affiliation" : [ ],
                  "name" : "Markus Konkol",
                  "orcid" : "0000-0002-4898-0314"
                }
              ],
              "community" : "o2r",
              "date" : "30 November 2016",
              "depends" : [
                {
                  "category" : "CRAN Top100",
                  "identifier" : "shiny",
                  "packageSystem" : "https://cloud.r-project.org/",
                  "version" : null
                },
                {
                  "category" : "none",
                  "identifier" : "likert",
                  "packageSystem" : "https://cloud.r-project.org/",
                  "version" : null
                }
              ],
              "description" : null,
              "ercIdentifier" : "g5G4c",
              "file" : {
                "filename" : "main.Rmd",
                "filepath" : "g5G4c/data/main.Rmd",
                "mimetype" : "text/markdown"
              },
              "generatedBy" : "o2r-meta metaextract.py",
              "inputfiles" : [
                "/tmp/o2r/compendium/g5G4c/data/quest.csv"
              ],
              "interaction" : {
                "interactive" : true
              },
              "keywords" : [ ],
              "license" : null,
              "output" : {
                "html_document" : {
                  "number_sections" : true
                }
              },
              "paperLanguage" : [
                "en"
              ],
              "paperSource" : "main.Rmd",
              "publicationDate" : null,
              "r_comment" : [
                {
                  "feature" : "comment",
                  "line" : 29,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 32,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 37,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 81,
                  "text" : "Participants"
                },
                {
                  "feature" : "comment",
                  "line" : 84,
                  "text" : "What are you doing in the context of scientific publications"
                },
                {
                  "feature" : "comment",
                  "line" : 86,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 89,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 92,
                  "text" : "sum of "
                },
                {
                  "feature" : "comment",
                  "line" : 118,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 119,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 120,
                  "text" : "print"
                },
                {
                  "feature" : "comment",
                  "line" : 123,
                  "text" : "What are your research fields"
                },
                {
                  "feature" : "comment",
                  "line" : 192,
                  "text" : "Please tell us your age"
                },
                {
                  "feature" : "comment",
                  "line" : 198,
                  "text" : "Please tell us your gender"
                },
                {
                  "feature" : "comment",
                  "line" : 203,
                  "text" : "Reproducible research"
                },
                {
                  "feature" : "comment",
                  "line" : 237,
                  "text" : "Interaction"
                },
                {
                  "feature" : "comment",
                  "line" : 239,
                  "text" : "Relating to your last five publications"
                },
                {
                  "feature" : "comment",
                  "line" : 262,
                  "text" : "While reading a scientific publication that is related to my own research work"
                },
                {
                  "feature" : "comment",
                  "line" : 273,
                  "text" : "It would be useful for my research work"
                },
                {
                  "feature" : "comment",
                  "line" : 283,
                  "text" : "For my research work I would like to search for other scientific publications on the web by using"
                }
              ],
              "r_input" : [
                {
                  "feature" : "data input",
                  "line" : 8,
                  "text" : "quest.csv"
                }
              ],
              "r_output" : [
                {
                  "feature" : "result",
                  "line" : 67,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 69,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 76,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 77,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 112,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 118,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 119,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 120,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 179,
                  "text" : "plot"
                },
                {
                  "feature" : "result",
                  "line" : 182,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 183,
                  "text" : "print"
                },
                {
                  "feature" : "result",
                  "line" : 184,
                  "text" : "print"
                }
              ],
              "recordDateCreated" : "2017-03-30",
              "runtime" : "shiny",
              "softwarePaperCitation" : null,
              "spatial" : {
                "geometry" : {
                  "type" : "Polygon",
                  "coordinates" : [
                    [
                      [
                        -22.0,
                        76.0
                      ],
                      [
                        -27.0,
                        65.0
                      ],
                      [
                        -57.0,
                        65.0
                      ],
                      [
                        -59.0,
                        76.0
                      ],
                      [
                        -22.0,
                        76.0
                      ]
                    ]
                  ]
                }
              },
              "temporal" : {
                "begin" : "2014-08-01T22:00:00.000Z",
                "end" : "2015-03-30T12:35:41.142Z"
              },
              "title" : "Reproducible research in Geosciences",
              "version" : null
            },
            "zenodo" : {
              "title" : "Reproducible research in Geosciences"
            },
            "cris" : {
              "title" : "Reproducible research in Geosciences"
            },
            "orcid" : {
              "title" : "Reproducible research in Geosciences"
            },
            "datacite" : {
              "title" : "Reproducible research in Geosciences"
            }
          },
          "jobs" : [ ],
          "created" : "2017-03-30T12:35:35.774Z",
          "__v" : 0
        }
      }

}}
```

### List of URL Parameters

The Search API and it's URL consist of certain parameters based on [Elasticsearch DSL queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html) which help to fetch a specific ERC.

#### Parameters for Temporal Searching

`from` :- This takes in the value as a timestamp according to ISO 8601 standards when the creation of ERC was started. (currently it's restricted to 2014-01-01 which can be modified on the basis of data). The cardinality for `from` is 
`1 until n` and the input has to be provided by the user. 

`to` :- This takes in the value as a timestamp according to ISO 8601 standards when the creation of ERC was ended.Current date and time can be entered as a value in this case.The cardinality for `to` is `1 until n` and the input has to be provided by the user. Both parameters can be used multiple times by providing the inputs in a sequential order.

The values from the parameters are used in a pre-configured Elasticsearch [range query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html) which queries the database for defined duration

```json
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

`coords` :- This should cater for the coordinates defined by the bounding box. A 2-d array of coordinates is expected as a parameter. The coordinates are to be pairs of latitude longitude values describing a closed polygon.
The value from this parameter is used in a pre-configured Elasticsearch [spatial query](https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-queries.html) which applies a `geo_shape` filter to fetch the desired ERC according to spatial parameters.The cardinality for `coords` is `1 until n` and the input has to be provided by the user. The parameter can be used multiple times to perform searching in different regions.

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
A simple match query is used at the back-end to match the query value with the values in dataset.The cardinality for `coords` is `n` and the input has to be provided by the user. The parameter can be used multiple times to perform searching.

```json
{
    "match" : { "metadata.o2r.title" : keyword}
  }
  ```
 
