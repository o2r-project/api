# Bindings

Bindings make static scientific papers interactive. They facilitate access to the source code and dataset underlying a figure. Bindings link the paper, the dataset, and the source code used to compute a specific figure, numerical result, or table with user interface (UI) widgets such as slider to manipulate a value shown in the figure. 

!!! note For now, we only support datasets saved as comma separated values (.csv). This is a technical constraint. The overall concept is also applicable to other data formats.

## Purposes

The type of interactivity depends on the purpose. Here, we support the following purposes:

Discover

1. Search for paper/result/figure using spatiotemporal properties - discoverResult

Inspect

2. Show dataset and source code underlying the paper - showPaperDataCode
3. Show dataset and source code underlying a specific result in the text - showNumberDataCode
4. Show dataset and source code underlying a figure  - showFigureDataCode

Manipulate

5. Manipulate a parameter used to compute a specific numerical result in the text - manipulateNumber
6. Manipulate a parameter used to compute a figure - manipulateFigure

Substitute

7. Substitute the dataset underlying a specific numerical result in the text - substituteNumberData
8. Substitute the dataset underlying a figure - substituteFigureData

## Prerequisites

Bindings can be created if the following criteria are met:

- the upload of the workspace is finished
- [metadata](http://o2r.info/o2r-web-api/compendium/metadata/) extraction is done. Required metadata are complete.
- the ERC is not yet [shipped](http://o2r.info/o2r-web-api/shipment/) to third-party archives such as Zenodo (otherwise files created by the bindings cannot be stored in the same ERC)

## Creating a new binding

When creating a new compendium, authors will reach the "Create bindings section".
The purposes have some own characteristics. 

### Request body for a new binding depending on the purpose

#### Discover


`POST /api/v1/binding/discover/discoverResult`

1. Search for paper/... using spatiotemporal properties

```json
{
}
```

#### Inspect

`POST /api/v1/binding/inspect/showPaperCode`

2. Show dataset and source code underlying the paper
```json
{
  "id":"compendium_id",
  "mainfile": "main.Rmd",
  "dataset": ["data.csv"]
}
```

`POST /api/v1/binding/inspect/showNumberDataCode`

3. Show dataset and source code underlying a specific result in the text
```json
{
  "id":"compendium_id",
  "mainfile": "main.Rmd",
  "context": "We identified Pi approximately as 3.14",
  "result": 3.14,
  "lineOfResult": "19-20",
  "dataset": [{
    "file": ["data.csv"],
    "columns" : ["measured_values"],
    "rows": ["1-100"]
   }]  
}
```

Note: For now, datasets are specified as bounding boxes.


4. Show dataset underlying a figure
```json
{
  "id":"compendium_id",
  "mainfile": "main.Rmd",
  "figure": "1",
  "dataset": [{
    "file": ["data.csv"],
    "columns" : ["measured_values"],
    "rows": ["1-100"]
   }]  
}
```

#### Manipulate

`POST /api/v1/binding/manipulate/manipulateNumber`

5. Manipulate a parameter used to compute a specific numerical result in the text
```json
{
  "id": "compendium_id",
  "mainfile": "main.Rmd",
  "resultText": "We identified Pi approximately as 3.14",
  "result": "'''{r}pi'''",
  "lineOfResult": 25,
  "codeLines": [20, 28],
  "widget": {
    "type": "slider",
    "min": 0,
    "max": 100,
    "init": 50,
    "step": 1,
    "label": "Change the threshold by using the slider."
    }
}
```


`POST /api/v1/binding/manipulate/manipulateFigure`

6. Manipulate a parameter used to compute a figure
```json
{
  "id": "compendium_id",
  "mainfile": "main.Rmd",
  "codeLines": [20, 28],
  "variable": "threshold <- 10",
  "figure": "1",
  "widget": {
    "type": "slider",
    "min": 0,
    "max": 100,
    "init": 50,
    "step": 1,
    "label": "Change the threshold by using the slider."
    }
}
```

#### Substitute
7. Substitute the dataset underlying a specific numerical result in the text.

`POST /api/v1/binding/substitute/substituteNumberData`

```json
{
}
```


8. Substitute the dataset underlying a figure.

`POST /api/v1/binding/substitute/substituteFigureData`

```json
{
}
```

### Request body properties

- `id` - id of the compendium (string)
- `purpose` - task that an author would like to provide (string)
- `mainfile` - main RMarkdown file used to compute the display file (string) 
- `result` - the result (a number or a paragraph) that should be addressed (string)
- `lineOfResult` - line(s) in the text of the RMarkdown where the result is shown (string)
- `dataset` - array of dataset objects used to compute the numeric result (JSON array) 
  - `file` - array of datasets used to compute the number (string array)
  - `column` - array of columns used to compute the number (integer array)
  - `row` - array of row ranges used to compute the number (string array)

### Response

```json
204 OK
```

### Error responses for bindings creation

```json
400 Bad Request

{"error": "file 'FILE' not found"}

```

```json
401 Unauthorized

{"error":"not authorized"}
```

```json
404 Not Found

{"error":"compendium not found"}
```

```json
422 Unprocessable Entity

{"error":"The selected code is not valid"}
```

```json
422 Unprocessable Entity

{"error":"The selected data is not valid"}
```

```json
422 Unprocessable Entity

{"error":"The selected text is ambiguous"}
```
