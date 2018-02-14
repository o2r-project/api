# Compendium file listing

The file listing is returned in the single view of a job or compendium. It includes the complete content of the bagtainer in its current state.
If a job has been run and the programme outputs new data, this new data is included as well.

File listings are represented as a Object. The file structure for a synthetic job `nj141` is as follows.

```text
nj141
├── bagit.txt
└── data
    ├── paper.Rmd
    └── Dockerfile
```

is be represented as

```json
{
  "path": "/api/v1/job/nj141/data",
  "name": "nj141",
  "children": [
    {
      "path": "/api/v1/job/nj141/data/bagit.txt",
      "name": "bagit.xt",
      "type": "text/plain",
      "size": 55
    },
    {
      "path": "/api/v1/job/nj141/data/data",
      "name": "data",
      "children": [
        {
          "path": "/api/v1/job/nj141/data/data/paper.Rmd",
          "name": "paper.Rmd",
          "type": "text/plain",
          "size": 346512
        }
        {
          "path": "/api/v1/job/nj141/data/data/Dockerfile",
          "name": "Dockerfile",
          "type": "text/plain",
          "size": 1729
        }
      ]
    }
  ]
}
```

## `path` property

The `path` property for each file in the listing is a link to the raw file. Additionally the `GET` parameter `?size=…` can be appended to retrieve previews of the files. In the case of Images (`png`, `jpg`, `gif`, `tiff`), the value defines the maximum width/height. For text files (`txt`, `csv`, scripts), the value defines the amount of lines returned.

### `type` property

The `type` property is a best guess for the MIME type of the file content. It is a result of the files extension. Look at the list of extension to type mapping below.

## File extension to MIME type mappings

This list contains the custom mapping of file extensions to MIME types used in the server.

| Extension        | MIME type          |
|------------------|--------------------|
| `.R`, `.r`       | `script/x-R`       |

## File inspection: RData

`.RData` files are a [binary format](https://stat.ethz.ch/R-manual/R-devel/library/base/html/save.html) for usage with R to save any kind of object (data, functions) using an internal serialisation.
The format is [not suitable](https://www.loc.gov/preservation/digital/formats/fdd/fdd000470.shtml) for archival or data exchange, but might be included in a compendium out of negligence by or convenience for the author.

Since the file format is binary and not readable by non-R client applications, the API provides the endpoint `/api/v1/inspection` to retrieve a JSON representation of the objects in an RData file.

Values of objects are provided as JSON arrays following the specifications by the R package [`jsonlite`](https://cran.r-project.org/package=jsonlite).

### Simple data types

`GET /api/v1/inspection/<compendium id>?file=simple.Rdata`

```json
200 OK

{  
  "aChar":[  
    "a"
  ],
  "aDouble":[  
    2.3
  ],
  "anInteger":[  
    1
  ],
  "aString":[  
    "The force is great in o2r."
  ]
}
```

### Complex data types

Lists are be nested objects, and vectors are JSON arrays (see [`jsonlite` docs](https://rdrr.io/cran/jsonlite/man/fromJSON.html) for details, defaults are used):

`GET /api/v1/inspection/<compendium id>?file=complex.Rdata`

```json
200 OK

{  
  "characterVector":[  
    "one",
    "two",
    "3"
  ],
  "logicalVector":[  
    true,
    true,
    false
  ],
  "numericVector":[  
    1,
    2,
    -7,
    0.8
  ],
  "orderedList":{  
    "name":[  
      "Fred"
    ],
    "mynumbers":[  
      1,
      2
    ],
    "age":[  
      5.3
    ]
  }
}
```

Data frames and matrices are mapped to JSON arrays of complex objects (see [`jsonlite` docs](https://rdrr.io/cran/jsonlite/man/fromJSON.html) for details, defaults are used):

`GET /api/v1/inspection/<compendium id>?file=matrices.Rdata`

```json
200 OK

{  
  "dataFrame":[  
    {  
      "ID":1,
      "Passed":true,
      "Colour":"red"
    },
    {  
      "ID":2,
      "Passed":true,
      "Colour":"white"
    },
    {  
      "ID":3,
      "Passed":true,
      "Colour":"red"
    },
    {  
      "ID":4,
      "Passed":false
    }
  ],
  "namedMatrix":[  
    [  
      1,
      26
    ],
    [  
      24,
      68
    ]
  ]
}
```

### Path parameters

- `compendium_id` _mandatory_ - the compendium identifier to inspect the file from

### Query parameters

- `file` _mandatory_ - the name of the file to inspect, or a relative path to a file within the compendium
- `objects` _optional_ - the name of objects in the file

If selected objects are not loadable from the file, an `errors` property in the response is given for each problematic object:

`GET /api/v1/inspection/<compendium id>?file=simple.RData&objects=bar,anInteger,foo`

```json
200 OK

{  
  "anInteger":[  
    1
  ],
  "errors":[  
    "Error: Object 'bar' does not exist in the file simple.RData",
    "Error: Object 'foo' does not exist in the file simple.RData"
  ]
}
```

### Errors

```json
400 Bad Request

{"error": "Query parameter 'file' missing"}
```

```json
400 Bad Request

{"error": "file 'not_available.Rdata' does not exist in compendium kOSMO"}
```

```json
400 Bad Request

{"error": "compendium '12345' does not exist"}
```

```json
500 Internal Server Error

{"error": "Error loading objects"}
```
