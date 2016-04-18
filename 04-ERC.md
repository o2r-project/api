# ERC

## View Metadata

View Metadata for a ERC. __TODO__ define `metadata`!

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/erc/view/:id`

URL Params
: :id → ERC id

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric], metadata : … }```

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in



Code
: 404 Not Found

Content
: `{ error : 'no ERC with this id' }`
   Could not find a ERC with the requested ID.

## List execution jobs

List the job IDs for all execution jobs attached to a ERC.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `GET`

URL
: `/erc/view/:id/jobs`

URL Params
: :id → ERC id

### Success Response

Code
: 200 OK

Content
: ```{ id : [alphanumeric], job_ids: [ [alphanumeric], … ] }```

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in

Code
: 404 Not Found

Content
: `{ error : 'no job attached to this ERC' }`
   This ERC does not yet have a job ID attached to it.



