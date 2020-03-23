# User levels

Users are authenticated via OAuth and the actions on the website are limited by the `level` associated with an account.
On registration, each account is assigned a level `0`.
Only admin users and the user herself can read the level of a user.

The following is a list of actions and the corresponding required _minimum_ user level.

- `0` _Users_ (everybody)
    - Create new jobs
    - View compendia, jobs, user details
- `100` _Known users_
    - Create new compendium
    - Create shipments
    - Create substitutions
    - Delete own candidates
- `500` _Editors_
    - Edit user levels up to own level
    - Edit compendium metadata
    - Delete candidates
    - Manage [public links](../compendium/link.md) for candidates
- `1000` _Admins_
    - Edit user levels up to own level
    - Delete compendia and candidates
    - View status pages of microservices
