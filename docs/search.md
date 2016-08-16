# Search

## Indexed information

- compendium metadata __planned__
- PDF documents in a compendium __planned__
- text files in a compendium __planned__

## Simple search

The search is based on [Elasticsearch](https://www.elastic.co/) and the regular [Elasticsearch search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html) is exposed at

```bash
http://…/api/v1/search
```

### Example requests

- [http://o2r.uni-muenster.de/api/v1/search?q=*](http://o2r.uni-muenster.de/api/v1/search?q=*)
- [http://o2r.uni-muenster.de/api/v1/search?q=term](http://o2r.uni-muenster.de/api/v1/search?q=term)
- [http://o2r.uni-muenster.de/api/v1/search?q=*&fields=compendium_id](http://o2r.uni-muenster.de/api/v1/search?q=*&fields=compendium_id)

### Security

Only reading requsts, i.e. `GET` requests, are allowed at the moment. This means that Kibana cannot be run against this interface, and neither can complex queries requiring `POST` requests. `GET` requests with payloads are allowed.

Example query:

```bash
curl -XGET 'https://…/api/v1/search' -d '{
    "query": {
            "type" : {
                "value" : "jobs"
            }
        }
    }
}'
```

## Suggesters

**UNDER DEVELOPMENT**

[Elasticsearch suggest API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters.html) 