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
- **check**
  Run a check on the contents of the container. Validate the results of the executed calculations.
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

Results will be sorted by descending date of last change. The content of the response can be limited to certain properties of each result by providing a list of fields, i.e. the parameter `fields`.

Results can be filtered:
- by `compendium_id` i.e. `compendium_id=a4Dnm`,
- by `status` i.e. `status=success` or
- by `user` i.e. `user=0000-0000-0000-0001`

`curl -F compendium_id=$ID https://…/api/v1/job?limit=100&start=2&compendium_id=$ID&status=success&fields=status`

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
- `fields` - Specify if/which additional attributes results should contain. Can contain following `fields`: `status`. Defaults to none.

## View single job

View details for a single job. The file listing format is described in [compendium files](compendium/files.md)

`curl https://…/api/v1/job/$ID`

`GET /api/v1/job/:id`

```json
//200 OK

{
  "id": "nkm4L",
  "compendium_id": "a4Dnm",
  "user": "0000-0001-9757-xxxx",
  "status": "failure",
  "steps": {
    "validate-bag": {
      "status":"skipped",
      "text": "bag validation during job execution is disabled"
    },
    "validate_compendium": {
      "text": "compendium is invalid, but execution may continue",
      "status": "failure",
      "start": "2017-10-23T08:44:30.768Z",
      "end": "2017-10-23T08:44:30.785Z"
    },
    "image_prepare": {
     "text": "payload with 12800 total bytes",
     "status": "success",
     "start": "2017-10-23T08:44:30.789Z",
     "end": "2017-10-23T08:44:31.013Z"
    },
    "image_build": {
      "text": "Step 1/6 : FROM alpine\nStep 3/6 : ENV HOST 127.0.0.1\nSuccessfully tagged erc:nkm4L\n",
      "status": "success",
      "start": "2017-10-23T08:44:31.043Z",
      "end": "2017-10-23T08:44:31.405Z"
    },
    "image_execute": {
      "text": "PING 127.0.0.1 (127.0.0.1): 56 data bytes\r\n64 bytes from 127.0.0.1: seq=0 ttl=64 [TRUNCATED FOR EXAMPLE]",
       "status": "success",
      "start": "2017-10-23T08:44:31.561Z",
      "end": "2017-10-23T08:45:01.160Z",
      "statuscode": 0
    },
    "check": {
        "status": "success",
        "images": [
            {
                "imageIndex": 0,
                "resizeOperationCode": 0,
                "compareResults": {
                    "differences": 0,
                    "dimension": 1290240
                }
            }
        ],
        "resultHTML": "[merged HTML with difference highlighting for images]",
        "timeOfCheck":
        {
            "start": "2017-10-23T08:45:01.168Z",
            "end": "2017-10-23T08:45:02.193Z"
        },
        "errorsEncountered": []
    },
    "cleanup": {
      "text": "Done: removed container.\nDone: kept image with tag erc:nkm4L for job nkm4L\nDone: deleted tmp payload file.",
      "status": "success",
      "start": "2017-10-23T08:45:01.201Z",
      "end": "2017-10-23T08:45:01.226Z"
    }
  },  
  "createdAt": "2017-10-23T08:44:30.693Z",
  "updatedAt": "2017-10-23T08:45:01.237Z"
}
```

### URL parameters for single job view

- `:id` - id of the job to be viewed
- `details` - Details of steps to be loaded. By default, only `status`, `start` and `end` of any step will be loaded. 
Can contain the following `details`: `all, validate-bag, validate_compendium, image_prepare, image_build, image_execute, `
### Steps

The answer will contain information regaring the job steps.

Additional explanations to their status will be transmitted in the `text` property. The `start` and `end` timestamps indicate the start and end time of the step. They are formatted as ISO8601.

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
