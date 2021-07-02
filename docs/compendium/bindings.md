# UI Bindings

A user interface binding (UI binding) is an optional component of an ERC.
It can be used to make static figures interactive.
For example, authors can show how different parameter settings of a computational model affect the result shown in a figure.
A UI binding stores information on

- the code lines needed to generate the corresponding figure,
- the variable/parameter in the code that should be made interactive,
- the data subset required for the figure, and
- the UI widget (e.g., a slider or radio buttons).

The UI binding configuration is a JSON object tored in the property `interaction` of the ERC metadata.
For this reason, the compendium must be at least a `candidate` where the metadata extraction is completed before a UI binding can be created.

## Create a UI binding

`POST /api/v1/bindings/binding`

Example request body for a new UI binding, here using with a slider:

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
      "first_line": 101,
      "last_line": 503
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

- `id` - ID of the compendium for which the UI binding should be created
- `computationalResult` - specification of the computational result that should be made interactive
  - `type` - type of the computational result, e.g., a figure or a table
  - `result` - the name of the result as it is referred to in the text
- `sourcecode` all code-related information needed to create a UI binding for result specified above
  - `file` - main file of the research compendium containing the R code
  - `codelines` - array of code chunks with the code needed to generate the result
    - `first_line` - start of the code chunk
    - `last_line` - end of the code chunk
  - `parameter` - array of parameters that should be made interactive
    - `text` - parameter as it is initialized in the code
    - `name` - the name of the parameter without the value
    - `val` - the value of the parameter without the name as it is set in the code
    - `uiWidget` - specification of the UI widget, one per parameter
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
  "data": {
  "id": "rDdFN",
  "computationalResult": {
    "type": "figure",
    "result": "Figure 3"
  },
  "sourcecode": {
    "file": "main.Rmd",
    "codelines": [{
      "first_line": 101,
      "last_line": 503
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
}
```

## Get changed Image from UI binding

`GET /api/v1/compendium/:compendium/binding/:binding`

### Request parameters

- `:compendium` - ID of the compendium for which the UI binding server should be started
- `:binding` - name of the binding in context for which the UI binding server should be started

#### Add  changed bynding parameters as query parameters

'?newValue0=<value>&newValue1=<value> ...'
  
 - 'newValue0' The value which should be assigned to the first changeable UI parameter
  
### Response

200 Ok - Image of updated Figure/Table
  
  
## Start server for one UI Binding

`POST /api/v1/compendium/:compendium/binding/:binding`

### Request parameters

- `:compendium` - ID of the compendium for which the UI binding server should be started
- `:binding` - name of the binding in context for which the UI binding server should be started

### Request body properties

- Optional

### Response


```json
200 Ok

{
  "callback": "ok",
  "data": {
      request.body
  }
}
```

## Search for a UI binding

`POST /api/v1/bindings/searchBinding`

Request body for finding UI bindings that include a certain code snippet:

```json
{
  "term": "processData(input)",
  "metadata": {o2r.metadata}
}
```

### Request body properties

- `term` - search for UI bindings including the given code snippet
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
