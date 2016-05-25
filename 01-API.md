# o2r Web API

*version 0.0.1*

## Entry point

The API entry point for versions including `0.0.1` and below is `/api/v1`.

Method
: `GET`

URL
: `/api/v1/`

### Success Response

Code
: 200 OK

Content
: ```{
   "version":"[alphanumeric]",
   "latest":true,
   "collections":[
      {
         "name":"upload",
         "url":"https://.../api/v1/upload"
      },
      {
         "name":"jobs",
         "url":"https://.../api/v1/jobs"
      },
      {
         "name":"compendia",
         "url":"https://.../api/v1/compendia"
      }
   ]
}```

Header
: TODO add HATEOAS header _self_

## Collections

There are currently three main collections:

`/api/v1/upload`
: [Upload](02-upload.md)

`/api/v1/job`
: [Execution Job](03-job.md)

`/api/v1/compendium`
: [Compendium](04-compendium.md)
