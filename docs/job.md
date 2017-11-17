# Execute a compendium

Execution jobs are used to run the analysis in a compendium. When a new execution job is started, the contents of the research compendium are cloned to create a trackable execution. The status information, logs and final working directory data are saved in their final state, so that they can be reviewed later on.

All execution jobs are tied to a single research compendium and reflect the execution history of that research compendium.

A trivial execution job would be a completely unmodified research compendium, to test the executability/reproducibility of the contained data and code.

## State of a job

The property `>job>.state` shows the overall state of a job.

The status will be one of following:

- `success` - if state of all steps is `success`.
- `failure` - if state of at least one step is `failure`.
- `running` - if state of at least one step is `running` and no state is `failure`.

More information about `steps` can be found in subsection `Steps` of section `View single job`.

## Steps of a job

One job consists of a series of steps.
The are executed in order.

- **validate_bag**
  Validate the BagIt bag using the npm library [bagit](https://www.npmjs.com/package/bagit); may be skipped if compendium is not a bag, will usually fail because of added metadata files during upload.
- **generate_configuration**
  Create a compendium configuration file; may be skipped if configuration file is already present.
- **validate_compendium**
  Parses and validates the bagtainer configuration file.
- **generate_manifest**
  Executes the given analysis to create a container manifest; may be skipped if manifest file is already present.
- **image_prepare**
  Create an archive of the payload (i.e. the workspace, or the data in a BagIt bag), which allows to build and run the image also on remote hosts.
- **image_build**
  Build an image and tag it `erc:<job_id>`.
- **image_execute**
  Run the container and return based on status code of program that ran inside the container.
- **check**
  Run a check on the contents of the container. Validate the results of the executed calculations. The check provides either a list of errors or a reference to displayable content in the property `display.diff`.
- **cleanup**
  Remove image or job files (depending on server-side settings).

### Status

All of these steps can be in one of the following status:

- `queued`: step is not yet started
- `running`: step is currently running
- `success`: step is completed successfully
- `failure`: step is completed unsuccessfully
- `skipped`: step does not fit the given input, e.g. bag validation is not done for non-bag workspaces

### Step metadata

Additional explanations on steps' status will be transmitted in the `text` property.
`text` is an array, with the latest element holding the newest information.
During long running steps, the `text` element is updated by appending new information when available.

The `start` and `end` timestamps indicate the start and end time of the step. They are formatted as ISO8601.

Specific steps may carry more information in additional properties.

## New job

Create and run a new execution job with an HTTP `POST` request using `multipart/form-data`.
Requires a `compendium_id`.

`curl -F compendium_id=$ID https://…/api/v1/job`

`POST /api/v1/job`

```json
200 OK

{"job_id":"ngK4m"}
```

### Body parameters for new jobs

- `compendium_id` (`string`): __Required__ The identifier of the compendium to base this job on.

### Error responses for new jobs

```json
404 Not Found

{"error":"no compendium with this ID found"}
```

```json
500 Internal Server Error

{"error":"could not create job"}
```

## List jobs

Lists jobs with filtering and pagination, returning up to 100 results by default.

Results will be sorted by descending date of last change. The content of the response can be limited to certain properties of each result by providing a list of fields, i.e. the parameter `fields`.

Results can be filtered:

- by `compendium_id` i.e. `compendium_id=a4Dnm`,
- by `status` i.e. `status=success` or
- by `user` i.e. `user=0000-0000-0000-0001`

`curl https://…/api/v1/job?limit=100&start=2&compendium_id=$ID&status=success&fields=status`

`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm&status=success`

```json
200 OK

{
  "results":[
    "nkm4L",
    "asdi5",
    "nb2sg",
    …
  ]
}
```

The overall job state can be added to the job list response:

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
  ]
}
```

### GET query parameters for listing jobs

- `compendium_id` - Comma-separated list of related compendium ids to filter by.
- `start` - Starting point of the result list. `start - 1` results are skipped. Defaults to 1.
- `limit` - Limits the number of results in the response. Defaults to 100.
- `status` - Specify status to filter by. Can contain following `status`: `success`, `failure`, `running`.
- `user` - Public user identifier to filter by.
- `fields` - Specify which additional attributes results list should contain. Can contain following fields: `status`, `user`. Defaults to none.

## View single job

View details for a single job. The file listing format is described in [compendium files](compendium/files.md)

`curl https://…/api/v1/job/$ID?details=all`

`GET /api/v1/job/:id?details=all`

```json
200 OK

{
  "id":"UMmJ7",
  "compendium_id":"BSgxj",
  "steps":{
    "validate_bag":{
      "status":"skipped",
      "text":[
        "Not a bag"
      ],
      "end":"2017-11-17T13:22:48.105Z",
      "start":"2017-11-17T13:22:48.105Z"
    },
    "generate_configuration":{
      "status":"success",
      "text":[
        "configuration file not found, generating it...",
        "Saved configuration file to job and compendium"
      ],
      "end":"2017-11-17T13:22:48.119Z",
      "start":"2017-11-17T13:22:48.113Z"
    },
    "validate_compendium":{
      "status":"success",
      "text":[
        "all checks passed"
      ],
      "end":"2017-11-17T13:22:48.127Z",
      "start":"2017-11-17T13:22:48.125Z"
    },
    "generate_manifest":{
      "status":"success",
      "text":[
        /* abbreviated */
        "INFO [2017-11-17 13:22:56] Going online? TRUE  ... to retrieve system dependencies (sysreq-api)",
        "INFO [2017-11-17 13:22:56] Trying to determine system requirements for the package(s) 'knitr, backports, magrittr, rprojroot, htmltools, yaml, Rcpp, stringi, rmarkdown, stringr, digest, evaluate' from sysreq online DB",
        "INFO [2017-11-17 13:22:58] Adding CRAN packages: backports, digest, evaluate, htmltools, knitr, magrittr, Rcpp, rmarkdown, rprojroot, stringi, stringr, yaml",
        "INFO [2017-11-17 13:22:58] Created Dockerfile-Object based on /erc/main.Rmd",
        "INFO [2017-11-17 13:22:58] Writing dockerfile to /erc/Dockerfile",
        /* abbreviated */
        "generated manifest"
      ],
      "manifest":"Dockerfile",
      "end":"2017-11-17T13:22:58.865Z",
      "start":"2017-11-17T13:22:48.129Z"
    },
    "image_prepare":{
      "status":"success",
      "text":[
        "payload with 756224 total bytes created"
      ],
      "end":"2017-11-17T13:22:58.906Z",
      "start":"2017-11-17T13:22:58.875Z"
    },
    "image_build":{
      "status":"success",
      "text":[
        "Step 1/6 : FROM rocker/r-ver:3.4.2",
        "---> 3cf05960bf30",
        /* abbreviated */
        "---> Running in eb7ccd432592",
        "---> 84db129215f6",
        "Removing intermediate container eb7ccd432592",
        "Successfully built 84db129215f6",
        "Successfully tagged erc:UMmJ7"
      ],
      "end":"2017-11-17T13:22:59.899Z",
      "start":"2017-11-17T13:22:58.912Z"
    },
    "image_execute":{
      "status":"success",
      "text":[
        "[started image execution]",
        /* abbreviated */
        "Output created: display.html\r\n> \r\n>",
        "[finished image execution]"
      ],
      "statuscode":0,
      "start":"2017-11-17T13:22:59.904Z"
    },
    "check":{
      "status":"failure",
      "text":[
        "Check failed"
      ],
      "images":[
        {
          "imageIndex":0,
          "resizeOperationCode":0,
          "compareResults":{
            "differences":204786,
            "dimension":1290240
          }
        }
      ],
      "display":{
        "diff":"/api/v1/job/UMmJ7/data/diffHTML.html"
      },
      "errors":[ ],
      "checkSuccessful":false,
      "end":"2017-11-17T13:23:04.439Z",
      "start":"2017-11-17T13:23:03.479Z"
    },
    "cleanup":{
      "status":"success",
      "text":[
        "Running regular cleanup",
        "Removed image with tag erc:UMmJ7: [{\"Untagged\":\"erc:UMmJ7\"},{\"Deleted\":\"sha256:84db129215f60f805320e0f70c54a706b6e4030f4627c74abfb1e17f287fefa8\"},{\"Deleted\":\"sha256:0dc5b951dc58a10e50ea42dd14a1cd59b080199d9ca40cadd0a4fc8ae5e0d139\"},{\"Deleted\":\"sha256:ea88669b92a1c67dc2825f9f6d90d334a6032882d3d31bc85671afbd04adaa70\"}]",
        "Deleted temporary payload file."
      ],
      "end":"2017-11-17T13:23:05.592Z",
      "start":"2017-11-17T13:23:04.575Z"
    }
  },
  "status":"failure",
  "files":{ /* see compendium */  }
}
```

### URL parameters for single job view

- `:id` - id of the job to be viewed
- `steps` - Steps to be loaded with full details

By default, only `status`, `start` and `end` of all steps are included in the response.

`steps` may either be `all`, or a comma separated list of one or more step names.
Any other step values for `details` than the listed ones will return the default (e.g. `details=no`).

### Error responses for single job view

```json
404 Not Found

{"error":"no compendium with this ID found"}
```

## Job status updates

You can subscribe to real time status updates on jobs using [WebSockets](https://en.wikipedia.org/wiki/WebSocket). The implementation is based on [socket.io](http://socket.io) and using their client is recommended.

The job log is available at `https://o2r.uni-muenster.de` under the namespace `api/v1/logs/job`.

```JavaScript
# create a socket.io client:
var socket = io('https://o2r.uni-muenster.de/api/v1/logs/job');
```
