# Upload

## URC

Upload a unvalidated research compendium as a zipped file. [ heißt das, es gibt für die anderen RCs eigene URLs? Ist es nicht besser, das unabhängig vom ERS Status zu machen?]

Implemented
: No

Stability
: 0 - subject to changes

Method
: `POST`

URL
: `/upload/urc`

URL Params
: _none_

Data Params
: TODO

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
     User is not logged in [Kann man mit reinnehmen, aber der User wird im nicht eingeloggten Zustand ohnehin nicht die Möglichkeit haben, irgendwas hochzuschieben]

-

Code


## Workspace

Upload a workspace as a zipped file.

Implemented
: No

Stability:
: 0 - subject to changes

Method
: `POST`

URL
: `/upload/urc` [obwohl es hier noch kein RC ist?]

URL Params
: _none_

Data Params
: TODO

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
