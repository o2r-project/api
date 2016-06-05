# Upload

## Compendium

Upload a unvalidated research compendium as a archived file. Archive Type can be
either `.zip` or `.tar.gz`. Encoding type must be `multipart/form-data`, `name`
must be `compendium`.

Implemented
: No

Stability
: 0 - subject to changes

Method
: `POST`

URL
: `/api/v1/compendium`

URL Params
: _none_

Data Params
: `{ content_type : 'compendium_v1' }` _optional_

### Success Response

Code
: 200 OK

Content
: `{ id : [alphanumeric] }`

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
     User is not logged in

## Workspace

Upload formless workspace directory as a archived file. Archive Type can be
either `.zip` or `.tar.gz`. Encoding type must be `multipart/form-data`, `name`
must be `workspace`.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `POST`

URL
: `/api/v1/compendium`

URL Params
: _none_

Data Params
: `{ content_type : 'workspace' }` _required_

### Success Response

Code
: 200 OK

Content
: `{ id : [alphanumeric] }`

### Error Response

Code
: 401 Unauthorized

Content
: `{ error : 'user not logged in' }`
   User is not logged in

## External Source

__TODO__
