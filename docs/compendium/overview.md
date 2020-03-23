# Compendium lifecycle

An authorized user (see [user levels](../user/levels.md)) can create compendia from different sources, i.e. [direct API upload](upload.md) or [via a public share](public_share.md).
The uploaded workspace is then treated as a [candidate compendium](candidate.md) until all required [metadata](metadata.md) is provided.
A candidate must be [saved](candidate.md) to become publicly available, and then may not become a candidate again.
A published compendium can be [executed](../job.md) and the whole compendium can be [shipped](../shipment.md) to repositories for preservation purposes.
A user can combine data and workflow of multiple compendia with [substitution](substitute.md).

[Specific users](../user/levels.md)) can (i) create [public links](link.md) for candidates so these can be inspected by third parties without logging in, and (ii) manage [users](../user/user.md)).

The API provides a generic [search](../search.md) endpoint for finding compendia and jobs and uses [ORCID and OAuth for authentication](../user/auth.md).
