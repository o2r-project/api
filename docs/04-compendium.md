# Compendium

## View compendia

View compendia. Will return up to 50 results by default. For pagination purposes, URLs for previous and next results are provided if applicable.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/api/v1/compendium`

URL Params
: `?job={id, …}` Only include compendia that are related to one or more of the jobs, provided by a comma-separated lists of IDs.
  `?start=…` List from specific search result onwards. 1-indexed. Defaults to 1.
  `?limit=…` Specify maximum amount of results per page. Defaults to 50.

### Success Response

Code
: 200 OK

Content
: ```{ results : [ … ], next: [URL], previous: [URL] }```

### Error Response

Code
: 404 Not Found

Content
: `{ error : 'no compendium found' }`
    No compendium found.

## View single compendium

View Information regarding a research compendium. This includes the complete
metadata set and a tree representation of the included files.

__TODO__ specify the tree representation. This will be very close to the format
used in https://www.npmjs.com/package/directory-tree

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/api/v1/compendium/:id`

URL Params
: :id → Compendium ID

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric], metadata : … , files : … }```

### Error Response

Code
: 404 Not Found

Content
: `{ error : 'no compendium with this id' }`
   Could not find a compendium with the requested ID.

## List execution jobs

List all executon jobs by ID attached to a compendium.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/api/v1/compendium/:id/jobs`

URL Params
: :id → Compendium ID

### Success Response

Code
: 200 OK

Content
: ```{ compendium_id : [alphanumeric], job_ids: [ [alphanumeric], … ] }```

### Error Response

Code
: 404 Not Found

Content
: `{ error : 'no job attached to this compendium' }`
   This compendium does not yet have a job attached to it. This happens, when
   the compendium has never been executed so far.
