# File Listing

The file listing is returned in the single view of a job or compendium. It includes the complete content of the bagtainer in its current state. If a job has been run and the programm outputs new data, this new data will be included as well.

_Note: currently, the bagtainer will be invalid if new data is saved, as the checksums are not updated._

File listings are represented as a Object. The file structure for a synthetic job `nj141` is as follows.

```text
nj141
├── bagit.txt
└── data
    ├── paper.Rmd
    └── Dockerfile
```

will be represented as

```json
{
  "path": "/api/v1/job/nj141/data",
  "name": "nj141",
  "children": [
    {
      "path": "/api/v1/job/nj141/data/bagit.txt",
      "name": "bagit.xt",
      "type": "text/plain",
      "size": 55
    },
    {
      "path": "/api/v1/job/nj141/data/data",
      "name": "data",
      "children": [
        {
          "path": "/api/v1/job/nj141/data/data/paper.Rmd",
          "name": "paper.Rmd",
          "type": "text/plain",
          "size": 346512
        }
        {
          "path": "/api/v1/job/nj141/data/data/Dockerfile",
          "name": "Dockerfile",
          "type": "text/plain",
          "size": 1729
        }
      ]
    }
  ]
}
```

## `path` property

The `path` property for each file in the listing is a link to the raw file. Additionally the `GET` parameter `?size=…` can be appended to retrieve previews of the files. In the case of Images (`png`, `jpg`, `gif`, `tiff`), the value defines the maximum width/height. For text files (`txt`, `csv`, scripts), the value defines the amount of lines returned.

### `type` property

The `type` property is a best guess for the MIME type of the file content. It is a result of the files extension. Look at the [list of extension to type mapping](files-mime.md) for specific details.