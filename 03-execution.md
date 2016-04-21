# Execution Jobs

* view job
  * execution log
  * live log _(websockets)_
  * view file structure
  * view single file

---


Execution jobs are instances of ERCs. When ERCs are executed, they are executed
as a new job. This provides reproducability and build history for ERCs, as well as the option to run a ERC with different input parameters. The most simple execution job is a direct copy of the unmodified ERC.

[ich finde das bis hier hin etwas verwirrend, "instance" passt hier nicht ganz. Auch nicht ganz klar: Eine Kopie eines ERC ist die simpelste Form eines execution jobs?]

## Create job

Create a new execution job for a ERC.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `POST`

URL
: `/jobs/create/:id`

URL Params
: :id → ERC id

Data Params
: ```{ execute_now : [boolean], inputs : [ [FileDescriptor], … ] }```

If `execute_now` is `True`, the job will start as soon as it is created. [gibt es einen Fall, in dem man einen Job erstellt und den nicht sofort ausführen will?]

Where `[FileDescriptor]` allows overriding files from the ERC with files
from a different execution Job or a different ERC. [what? diese Funktionalität ist mir neu.]

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
: ```{ id : [alphanumeric] }```

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in [für diese Funktion muss ein user wahrscheinlich nicht zwingend eingeloggt sein, müssen wir aber noch diskutieren]



Code
: 404 Not Found

Content
: `{ error : 'no ERC with this ID found' }`
   Could not find a ERC with the provided `:id`.


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

## Run Job

Run a execution job.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/jobs/run/:id`

URL Params
: :id → ERC id

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric] }```

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in [Es sollte wahrscheinlich möglich sein, ein ERC ausführen zu können, ohne dass man eingeloggt ist]



Code
: 404 Not Found

Content
: `{ error : 'no ERC with this ID found' }`
   Could not find a ERC with the provided `:id`.


Code
: 500 Internal Server Error

Content
: `{ error : 'Could not run job'}`
  Could not create job for undefined reason.

## View Job

View details for a job

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/jobs/view/:id`

URL Params
: :id → ERC id

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric], erc_id : [alphanumeric], steps : { [ExecutionStep], … }}```

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
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in



Code
: 404 Not Found

Content
: `{ error : 'no ERC with this ID found' }`
   Could not find a ERC with the provided `:id`.


Code
: 500 Internal Server Error

Content
: `{ error : 'Could not run job'}`
  Could not create job for undefined reason.


### Status report

* bagit verifiziert
        * erc format verifiziert
        * image gebaut
        * ausführung im container
          * output?
          * prozente?
        * validierung
        * endergebnis

