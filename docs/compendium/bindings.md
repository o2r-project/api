# Bindings

Bindings make static scientific papers interactive by providing better access to the underlying source code and dataset. Bindings connect the paper, the dataset, and the source code used to compute a specific figure, numerical result, or table with user interface widgets such as slider to manipulate a value shown in the figure. 

## Purposes
The sort of interactivity depends on the purpose. Here, we support the following purposes:

1. Show the dataset underlying the paper.
2. Show the source code underlying the paper.
3. Show the dataset underlying a specific numerical result.
4. Show the dataset underlying a figure.
5. Show the source code underlying a specific numerical result.
6. Show the source code underlying a figure.
7. Manipulate a parameter used to compute a specific numerical result.
8. Manipulate a parameter used to compute a figure.
9. Select data subsets used to produce a figure.
10. Select data subsets used to produce a specific numerical result.

## Create a new binding
When creating a new _Executable Research Compendium_ (ERC), authors will reach the "Create bindings section". Each purpose has own needs.

`POST /api/v1/binding`

### Request body for a new binding depending on the purpose:

3. Show the dataset underlying a specific numerical result.
```json
{
  "id":"compendium_id",
  "purpose": "showNumResultData",
  "main_file": "main_file.Rmd",
  "result_line": "19-20",
  "numerical_result": "3.14",
  "dataset": [{
    "dataset_file": ["data.csv"],
    "dataset_columns" : ["measured_values"],
    "dataset_rows": ["1-100"]
   }]  
}
```

### Request body properties

- `id` - id of the compendium
- `purpose` - task that an author would like to provide
- `main_file` - main RMarkdown file used to compute the display file
- `result_line` - line(s) where the result occurs
- `numerical result` - the numeric result that should be addressed
- `dataset` - array of dataset objects used to compute the numeric result  
  - `dataset_file` - array of datasets used to compute the number
  - `dataset_columns` - array of columns used to compute the number
  - `dataset_rows` - array of row ranges used to compute the number

### Response

```json
204 OK
```

### Error responses for bindings creation

```json
401 Unauthorized

{"error":"not authorized"}
```

```json
404 Not Found

{"error":"compendium not found"}
```
