# Job

Execution jobs are used to execute a research compendium. When a new execution job is started, the contents of the research compendium are cloned to create a trackable execution. The status information, logs and final working directory data are saved in their final state, so that they can be reviewed later on.

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

One job consists of a series of steps. All of these steps can be in one of three status: `running`, `failure`, or `success`. The are executed in order.

- **validate_bag**
  Validate the BagIt bag based on npm's [bagit](https://www.npmjs.com/package/bagit).
- **validate_compendium**
  Parses and validate the bagtainer configuration and metadta.
- **image_prepare**
  Create an archive of the payload of the BagIt bag, which allows to build and run the image also on remote Docker hosts.
- **image_build**
  Send the bag's payload as a tarballed archive to Docker to build an image, which is tagged `bagtainer:<jobid>`.
- **image_execute**
  Run the container and return based on status code of program that ran inside the container.
- **cleanup**
  Remove image or job files (depending on server-side settings).

The step status is one of:

- `queued`
- `running`
- `success`
- `failure`
- `warning`
- `skipped`

## New job

Create and run a new execution job. Requires a `compendium_id`.

`curl -F compendium_id=$ID https://…/api/v1/job`

`POST /api/v1/job`

```json
200 OK

{"job_id":"ngK4m"}
```

### Body parameters for new jobs

- `compendium_id` - The `id` of the compendium to base this job on.
- `steps` - **TODO** select steps that will be executed (skip some steps in successive executions?)
- `inputs` - **_proposal_** - Array with one or more `FileDescriptor`.

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

Lists jobs. Will return up to 100 results by default.

For pagination purposes, URLs for previous and next results are provided if applicable. Results will be sorted by descending date of last change. Results can be filtered by one or more compendiums, i.e. parameter `compendium_id`, as well as by `state`.
The content of the response can be limited to certain properties of each result by providing a list of fields, i.e. the parameter `fields`.

`curl -F compendium_id=$ID https://…/api/v1/job?limit=100&start=2&compendium_id=$ID&state=success`

`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm&state=success`

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

The overall job state can be added to the job list response:

`GET /api/v1/job?limit=100&start=2&compendium_id=a4Dnm&state=success&fields=state`

```json
200 OK

{
  "results":[
    {
      "id":"nkm4L",
      "state":"failure"
    },
    {
      "id":"asdi5",
      "state":"success"
    },
    {
      "id":"nb2sg",
      "state":"running"
    },
    …
  ],
  "next":"/api/v1/job?limit=100&start=3&fields=state",
  "previous":"/api/v1/job?limit=100&start=1&fields=state"
}
```

### GET query parameters for listing jobs

- `compendium_id` - Comma-separated list of related compendium ids to filter by.
- `start` - List from specific search result onwards. 1-indexed. Defaults to 1.
- `limit` - Specify maximum amount of results per page. Defaults to 100.
- `state` - Specify state to filter by. Can contain following states: `success`, `failure`, `running`.
- `fields` - Specify if/which additional attributes results should contain. Allowed values are `state`. Defaults to none (<code>&#32;</code>).

## View single job

View details for a single job. Filelisting format is described in [Files](files.md)

`curl https://…/api/v1/job/$ID`

`GET /api/v1/job/:id`

```json
200 OK

{
  "id":"nkm4L",
  "compendium_id":"a4Dnm",
  "creation_date": Date,
  "state": "fail",
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

### URL parameters for single job view

- `:id` - id of the job to be viewed

### Steps

The answer will contain information regaring the job steps.

Additional explanations to their state will be transmitted in the `text` property. The `start` and `end` timestamps indicate the start and end time of the step. They are formatted as ISO8601.

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

__TODO__: add documentation on messages on the socket.
