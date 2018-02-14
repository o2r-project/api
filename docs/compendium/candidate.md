# Candidate process

After uploading a compendium is _not_ instantly publicly available.
It is merely a **candidate**, because metadata still must be completed for the compendium to be valid.

The following process models this intermediate state of a compendium.

## Creation and view

Candidates can be identified by the property `candidate`.
It is set to `true` after creating a new compendium by [upload](upload.md) or [public share submission](public_share.md) **and** the authoring user having reviewed the metadata.

!!! Note
    It is not possible to circumvent the metadata review.
    Only a successful [metadata update](metadata.md#update-metadata) can set `candidate: true`.

**Example:**

```json
{
  "id":"12345",
  "metadata": … ,
  "created": "2016-08-01T13:57:40.760Z",
  "files": …,
  "candidate": true
}
```

Only the creating user and users with [required level](../user.md#user-levels) can view a candidate and see the `candidate` property while it is `true`.

When accessing a [list of compendia](view.md#list-compendia) for a specific user _as that user_, then this list is extended by available candidates.
The candidates may be added to the response independently from any pagination settings, i.e. if a client requests the first 10 compendia for a user having two candidates, the client should be prepared to handle 12 items in the response.

## Metadata review and saving

After the user has reviewed and potentially updated the metadata as required and [saved them](metadata.md#update-metadata) successfully, then the candidate status is changed (`candidate: false`) and the compendium is publicly available.

The `candidate` property is not exposed any more if it is `false`.

It is _not_ possible to save invalid metadata or to manually change the `candidate` property, therefore a compendium cannot become a candidate again after successful completion of the creation.

## Deletion

Unlike published compendia, a candidate can be deleted by a the authoring user, see [delete compendium](delete.md).
