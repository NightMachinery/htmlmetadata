# Installation

`nimble install https://github.com/NightMachinary/htmlmetadata`

# Usage

You need to send the HTML input through stdin, by using, e.g., `curl http://example.com | htmlmetadata ...`.

```
  htmlmetadata
    Will print all the extracted metadata in a humanly readable format.
  htmlmetadata <name-of-metadata> ...
    Will print the requested metadata only, separated by the NUL character. (The separator can't be the newline because the description metadata often contains newlines.)
```

```
Available metadata:
  title: string
  description: string
  image: string
  author: string
  creator: string
  site_name: string
  keywords: string
```

