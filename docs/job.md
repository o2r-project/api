# Job

__Stability:__ 0 - subject to changes

Execution jobs are used to execute a research compendium. When a new execution job is started, the contents of the research compendium are cloned to create a trackable execution. The status information, logs and final working directory data are saved in their final state, so that they can be reviewed later on.

All execution jobs are tied to a single research compendium and reflect the execution history of that research compendium.

A trivial execution job would be a completely unmodified research compendium, to test the reproducibility of a research compendium. A _potential_ future feature would be that the input data (input files, datasets, parameters) can be altered to run a modified execution job. This functionality is not yet final.

## New job

Create and run a new execution job. Requires a `compendium_id`.

`curl -F compendium_id=$ID https://…/api/v1/job`

`POST /api/v1/job`

```json
200 OK

{"job_id":"ngK4m"}
```

### Body parameters

- `compendium_id` - The `id` of the compendium to base this job on.
- `steps` - **TODO** select steps that will be executed (skip some steps in successive executions?)
- `inputs` - **_proposal_** - Array with one or more `FileDescriptor`.

### `FileDescriptor`

_The FileDescriptor functionality is only a potential feature and not at all finalized._

`[FileDescriptor]` allows overriding files from the compendium with files from a different execution job or a different compendium.

**`[FileDescriptor]` Syntax:**

```text
ERC/JOB:ID:Source:Destination
```

e.g. `ERC:lnj82:/data/bigdataset.Rdata:/data/newinput.Rdata` would provide `/data/bigdataset.Rdata` from the `ERC` with the ID `lnj82` as the file `/data/newinput.Rdata` in this execution Job.

### Error responses

```json
404 Not Found

{"error":"no compendium with this ID found"}
```

```json
500 Internal Server Error

{"error":"could not create job"}
```

```json
500 Internal Server Error

{
  "error":"could not provide file",
  "filedescriptor":"[FileDescriptor]"
 }
```

## List jobs

__Stability:__ 0 - subject to changes

Lists jobs. Will return up to 100 results by default. For pagination purposes, URLs for previous and next results are provided if applicable. Results will be sorted by descending date and can be filtered by one or more related `compendium_id` as well as by `status`. Additionally results can be provided as a list of strings or as objects with added `fields`.

`curl -F compendium_id=$ID https://…/api/v1/job?limit=100&start=2&compendium_id=$ID&state=success&fields=status`

`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm&status=success`

```json
200 OK

{
  "results":[
    "nkm4L",
    "asdi5",
    "nb2sg",
    …
  ],
  "next":"/api/v1/job?limit=100&start=3",
  "previous":"/api/v1/job?limit=100&start=1"
}
```
`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm&status=success&fields=status`

```json
200 OK

{
  "results":[
    {
      "id":"nkm4L",
      "status":"failure"
    },
    {
      "id":"asdi5",
      "status":"success"
    },
    {
      "id":"nb2sg",
      "status":"running"
    },
    …
  ],
  "next":"/api/v1/job?limit=100&start=3&fields=status",
  "previous":"/api/v1/job?limit=100&start=1&fields=status"
}
```

### GET parameters

- `compendium_id` - Comma-separated list of related compendium ids to filter by.
- `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
- `limit` - Specify maximum amount of results per page. Defaults to 100.
- `status` - Specify state to filter by. Can contain following `status`: `success`, `failure`, `running`.
- `fields` - Specify if/which additional attributes results should contain. Can contain following `fields`: `status`. Defaults to none.

### Status

Shows the overall state of a job.

The status will be one of following:

- `success` - if state of all steps is `success`.
- `failure` - if state of at least one step is `failure`.
- `running` - if state of at least one step is `running` and no state is `failure`.

More information about `steps` can be found in subsection `Steps` of section `View single job`.


## View single job

__Stability:__ 0 - subject to changes

View details for a single job. Filelisting format is described in [Files](files.md)

`curl https://…/api/v1/job/$ID`

`GET /api/v1/job/:id`

```json
200 OK

{
  "id":"nkm4L",
  "compendium_id":"a4Dnm",
  "creation_date": Date,
  "status": "fail",
  "steps":{
    "unpack":{
      "status":"failure",
      "start": Date,
      "end": Date,
      "text":"not a valid archive"
    },
    …
  },
  "files":{
    {FileListing}
  }
}
```

### URL parameters

- `:id` - id of the job to be viewed

### Steps

The answer will contain information to the following `steps`:

- `validate_bag`
- `validate_compendium`
- `validate_dockerfile`
- `image_build`
- `image_execute`
- `cleanup`

Their status will be one of:

- `queued`
- `running`
- `success`
- `failure`
- `warning`
- `skip`

Additional explanations to their state will be transmitted in the `text` property. The `start` and `end` timestamps indicate the start and end time of the step. They are formatted as ISO8601.

### Error responses

```json
404 Not Found

{"error":"no compendium with this ID found"}
```
