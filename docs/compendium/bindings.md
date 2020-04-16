# Bindings

A binding is an optional component of an Executable Research Compendium.
It can be used to make static figures interactive, for example, to show how different parameter settings affect the result shown in the figure.
A bindings stores information on the code lines needed to generate the corresponding figure, the parameter that should be made interactive, the data subset required for the figure, and the user interface (UI) widget (e.g. a slider or radio buttons).
The resulting JSON object including the binding is stored in the metadata tag `interaction`.
For this reason, the compendium must be at least a `candidate` where the metadata extraction is completed. 

## Create a binding

`POST /api/v1/bindings/binding`

Request body for a new binding:

```json
{
  "id": "rDdFN",
  "computationalResult": {
    "type": "figure",
    "result": "Figure 3"
  },
  "sourcecode": {
    "file": "main.Rmd",
    "codelines": [{
      "start": 101,
      "end": 503
      }],
    "parameter": [{
      "text": "duration <- 24",
      "name": "duration",
      "val": 24,
      "uiWidget": {
        "minValue": 1,
        "type": "slider",
        "maxValue": 24,
        "stepSize": 1,
        "caption": "The duration parameter specifies the duration of the flood event in hours."
        }
      }]
    }
}
```

### Request body properties

- `id` - ID of the compendium for which the bindings should be created
- `computationalResult` - specification of the computational result that should be made interactive
  - `type` - type of the computational result, e.g. a figure or a table
  - `result` - the actual result as it is referred to in the text
- `sourcecode` all code-related information needed to create a binding for result specified above
  - `file` - main file of the research compendium containing the R code
  - `codelines` - array of code chunks including the code needed to generate the result
    - `start` - start of the code chunk
    - `end` - end of the code chunk
  - `parameter` - array of parameters that should be made interactive
    - `text` - parameter as it is initialized in the code
    - `name` - the name of the parameter without the value
    - `val` - the value of the parameter without the name
    - `uiWidget` - specification of the UI widget, one per parameter, here examplified with a slider
      - `type` - widget type, e.g. a slider or radio buttons
      - `minValue` - minimum value of the slider
      - `maxValue` - maximum value of the slider
      - `stepSize` - step size when moving the slider
      - `caption` - caption for the result
      
### Response

```json
200 Ok

{
  "callback": "ok",
  "data": binding
}
```

## Extract R code

`POST /api/v1/bindings/extractR`

Request body for extracting those code lines needed to generate a specific result:

```json
{
  "id": "rDdFN",
  "file": "main.Rmd",
  "plot": "plotFigure1()"
}
```

### Request body properties

- `id` - ID of the compendium for which the bindings should be created
- `file` - main file of the research compendium containing the R code
- `plot` - function that outputs the result used as starting point for the backtracking algorithm

### Response

```json
200 Ok

{
  "callback": "ok",
  "codelines": [{
    "start": 101,
    "end": 503
    }],
}
```

## Proxy for binding

`GET /api/v1/compendium/:compendium/binding/:binding`

...

## Run binding

`POST /api/v1/compendium/:compendium/binding/:binding`

...

## Search for a binding

`POST /api/v1/bindings/searchBinding`

Request body for finding bindings that include a certain code snippet:

```json
{
  "term": "processData(input)",
  "metadata": {o2r.metadata}
}
```

### Request body properties

- `term` - search for bindings including the this code snippet
- `metadata` - whole metadata object of the corresponding compendium

### Response

```json
200 Ok

{
  "callback": "ok",
  "data": ["result"] 
}
```

- `data` - array of results for which bindings exist that include the corresponding code snippet 