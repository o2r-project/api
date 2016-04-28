# Execution Jobs

* view job
  * execution log
  * live log _(websockets)_
  * view file structure
  * view single file

---

Execution jobs are used to execute a research compendium. When a new execution
job is started, the contents of the research compendium are cloned to create a
trackable execution. The status information, logs and final working directory
data are saved in their final state, so that they can be reviewed later on.

All execution jobs are tied to a single research compendium and reflect the
execution history of that research compendium.

A trivial execution job would be a completely unmodified research compendium, to
test the reproducibility of a research compendium. A potential future feature
would be that the input data (input files, datasets, parameters) can be altered
to run a modified execution job. This functionality is not yet final.

## New Job

Create and run a new execution job.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `POST`

URL
: `/api/v1/job`

URL Params
: None

Data Params
: ```{ compendium_id : String, inputs : [ [FileDescriptor], … ] }```

_The FileDescriptor functionality is only a potential feature and not at all
finalized._

Where `[FileDescriptor]` allows overriding files from the compendium with files
from a different execution job or a different compendium.

__`[FileDescriptor]` Syntax:__
```
ERC/JOB:ID:Source:Destination
```

e.g. `ERC:lnj82bkmj23:/data/bigdataset.Rdata:/data/newinput.Rdata` would provide
`/data/bigdataset.Rdata` from the `ERC` with the ID `lnj82bkmj23` as the file
`/data/newinput.Rdata` in this execution Job.


### Success Response

Code
: 200 OK

Content
: ```{ job_id : [alphanumeric] }```

### Error Response

Code
: 404 Not Found

Content
: `{ error : 'no compendium with this ID found' }`
   Could not find a compendium with the provided `compendium_id`.


Code
: 500 Internal Server Error

Content
: `{ error : 'Could not create job'}`
  Could not create job for undefined reason.

Code
: 500 Internal Server Error

Content
: `{ error : 'could not provide file', filedescriptor : [FileDescriptor] }`
  File described in [FileDescriptor] could not be provided to job.

## View Job

View details for a job

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/api/v1/job/:id`

URL Params
: :id → Job ID

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric], compendium_id : [alphanumeric], steps : { [ExecutionStep], … }}```

Where `[ExecutionStep]` are `Object` types containing status information for a execution step.

```
[ExecutionStep] : {
  status : [StepStatus],
  text : [alphanumeric],
  }
```

Possible types of [ExecutionStep] are:

* `fetch`
* `unpack`
* `validateBag`
* `validateERC`
* `validateDockerfile`
* `buildImage`
* `executeImage`
* `cleanup`
* `finish`

Possible types of [StepStatus] are:

* `queued`
* `running`
* `success`
* `failure`
* `warning`
* `skip`

Additional explanations will be saved in the `text` property.

### Error Response

Code
: 404 Not Found

Content
: `{ error : 'no compendium with this ID found' }`
   Could not find a compendium with the provided `:id`.

### Status report

* bagit verifiziert
        * erc format verifiziert
        * image gebaut
        * ausführung im container
          * output?
          * prozente?
        * validierung
        * endergebnis

