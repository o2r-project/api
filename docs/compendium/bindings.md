# Bindings

Bindings make static scientific papers interactive by providing better access to the underlying source code and dataset.
Bindings connect the paper, the dataset, and the source code used to compute a specific figure, numerical result, or table with user interface widgets such as slider to manipulate a value shown in the figure. 

!!! note For now, we only support datasets saved as comma separated values (.csv). This is a technical constraint. The overall concept is also applicable to other data formats.

## Purposes

The sort of interactivity depends on the purpose. Here, we support the following purposes:

1. Show the dataset underlying the paper - showPaperData
2. Show the source code underlying the paper - showPaperCode
3. Show the dataset underlying a specific result in the text - showResultData
4. Show the dataset underlying a figure - showFigureData
5. Show the source code underlying a specific result in the text - showResultCode
6. Show the source code underlying a figure - showFigureCode
7. Manipulate a parameter used to compute a specific numerical result in the text - manipulateNumRes
8. Manipulate a parameter used to compute a figure - manipulateFigure
9. Select data subsets used to produce a figure - figureDatasubset
10. Select data subsets used to produce a specific numerical result in the text - numResultDatasubset

## Prerequisites

Bindings can be created if the following criteria are met:

- the upload of the workspace is finished
- [metadata](http://o2r.info/o2r-web-api/compendium/metadata/) extraction is done but not necessarily complete
- the ERC is at least a [candidate](http://o2r.info/o2r-web-api/compendium/candidate/)
- the ERC is not yet [shipped](http://o2r.info/o2r-web-api/shipment/) to third-party archives such as Zenodo (otherwise files created by the ui bindings cannot be stored in the same ERC)

## Creating a new binding

When creating a new compendium, authors will reach the "Create bindings section".
The purposes have some own characteristics. 
For exmaple, _showFigureData_ only considers the dataset but not the code (vise versa for _showFigureCode_).
The final JSON object might thus be different for each purpose.

`POST /api/v1/binding`

### Request body for a new binding depending on the purpose
1. Show the dataset underlying the paper
```json
{
  "id":"compendium_id",
  "task": "inpect",
  "purpose": "showPaperData",
  "dataset": ["data.csv"]  
}
```

2. Show the source code underlying the paper
```json
{
  "id":"compendium_id",
  "task": "inspect",
  "purpose": "showPaperCode",
  "mainfile": "main.Rmd"
}
```

3. Show the dataset underlying a specific result.
```json
{
  "id":"compendium_id",
  "inspect": "inspect",
  "purpose": "showResultData",
  "mainfile": "main_file.Rmd",
  "result": "We identified Pi approximately as 3.14",  
  "lineOfResult": "19-20",
  "dataset": [{
    "file": ["data.csv"],
    "columns" : ["measured_values"],
    "rows": ["1-100"]
   }]  
}
```

4. Show the dataset underlying a figure
```json
```

5. Show the source code underlying a specific result in the text
```json
{
  "id": "compendium_id",
  "mainfile": "main_file.Rmd",
  "task": "inspect",
  "purpose": "showResultCode",
  "result": "3.14",
  "lineOfResult": 25,
  "codeLines": [20, 28]
}

```

6. Show the source code underlying a figure
```json
{
  "id":"compendium_id",
  "mainfile": "main_file.Rmd",
  "task": "inspect",
  "purpose": "showFigureCode",
  "result": "figure 1",
  "codeLines": [20, 28]
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
