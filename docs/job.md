# Job
Execution jobs are used to execute a research compendium. When a new execution
job is started, the contents of the research compendium are cloned to create a
trackable execution. The status information, logs and final working directory
data are saved in their final state, so that they can be reviewed later on.

All execution jobs are tied to a single research compendium and reflect the
execution history of that research compendium.

A trivial execution job would be a completely unmodified research compendium, to
test the reproducibility of a research compendium. A _potential_ future feature
would be that the input data (input files, datasets, parameters) can be altered
to run a modified execution job. This functionality is not yet final.

## New Job

Create and run a new execution job. Requires a `compendium_id`.

`curl -F compendium_id=$ID http://…/api/v1/job`

`POST /api/v1/job`

```json
200 OK

{"job_id":"ngK4m"}
```
__Implemented:__ Yes

__Stability:__ 0 - subject to changes

### Body parameters:

* `compendium_id` - The `id` of the compendium to base this job on.
* `steps` - __TODO__ select steps that will be executed (skip some steps in successive executions?)
* `inputs` - **_proposal_** - Array with one or more `FileDescriptor`.

### `FileDescriptor`

_The FileDescriptor functionality is only a potential feature and not at all
finalized._

`[FileDescriptor]` allows overriding files from the compendium with files
from a different execution job or a different compendium.

__`[FileDescriptor]` Syntax:__
```
ERC/JOB:ID:Source:Destination
```

e.g. `ERC:lnj82:/data/bigdataset.Rdata:/data/newinput.Rdata` would provide
`/data/bigdataset.Rdata` from the `ERC` with the ID `lnj82` as the file
`/data/newinput.Rdata` in this execution Job.

### Error Responses
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

Lists jobs. Will return up to 100 results by default. For pagination purposes, URLs for previous and next results are provided if applicable. Results can be filtered by one or more related `compendium_id`.

`curl -F compendium_id=$ID http://…/api/v1/job?limit=100&start=2&compendium_id=$ID`

`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm`

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

__Implemented:__ Yes

__Stability:__ 0 - subject to changes

### GET parameters

* `compendium_id` - Comma-separated list of related compendium ids to filter by.
*  `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
*  `limit` - Specify maximum amount of results per page. Defaults to 100.

## View single Job

View details for a single job. Filelisting format is described in [Files](files.md)

`curl http://…/api/v1/job/$ID`

`GET /api/v1/job/:id`

```json
200 OK

{
  "id":"nkm4L",
  "compendium_id":"a4Dnm",
  "steps":{
    "unpack":{
      "status":"failure",
      "text":"not a valid archive"
    },
    …
  },
  "files":{
    {FileListing}
  }
}
```

__Implemented:__ Yes

__Stability:__ 0 - subject to changes


### URL Parameters

* `:id` - id of the job to be viewed

### Steps

The answer will contain information to the following `steps`:

* `validate_bag`
* `validate_compendium`
* `validate_dockerfile`
* `image_build`
* `image_execute`
* `cleanup`

Their status will be one of:

* `queued`
* `running`
* `success`
* `failure`
* `warning`
* `skip`

Additional explanations to their state will be transmitted in the `text` property.

### Error Responses

```json
404 Not Found

{"error":"no compendium with this ID found"}
```
