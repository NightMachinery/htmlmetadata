# About

`htmlmetadata` is a CLI app that extracts metadata out of HTML. Extremely fast (written in `nim`), but might not handle edge cases.

I use this tool often, so you can be sure that it's maintained (i.e., working), even if it has not had recent activity.

# Installation

Install `nim`, which includes its own package manager `nimble`:

``` sh
brew install nim
# or
sudo apt install nim
# or ...
```

Now:

`nimble install https://github.com/NightMachinary/htmlmetadata`

Don't forget to add nimble's binary path (`~/.nimble/bin/` on my machine) to your PATH.

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

## Examples

``` sh
curl --silent https://slatestarcodex.com/2020/06/17/slightly-skew-systems-of-government/ | htmlmetadata
```

> (title: "Slightly Skew Systems Of Government", description: "[Related To: Legal Systems Very Different From Ours Because I Just Made Them Up, List Of Fictional Drugs Banned By The FDA] I. Clamzoria is an acausal democracy. The problem with democracy is that …", image: "https://s0.wp.com/i/blank.jpg", author: "", creator: "", site_name: "Slate Star Codex", keywords: "")

`curl --silent https://nintil.com/reversible-senescence | htmlmetadata`
> (title: "Nintil - Is cellular senescence irreversible?", description: "The internet\'s best blog!", image: "", author: "Jose Luis Ricon", creator: "", site_name: "", keywords: "economics, philosophy, technology, innovation, gdp growth, progress studies")

Note: `cat -v` is used to show the NUL character.

`curl --silent https://nintil.com/reversible-senescence | htmlmetadata author | cat -v`
> Jose Luis Ricon

`curl --silent https://nintil.com/reversible-senescence | htmlmetadata site_name author keywords |cat -v`
> ^@Jose Luis Ricon^@economics, philosophy, technology, innovation, gdp growth, progress studies

# Need to extract a metadata tag not covered by the API?

Check out the source! It's extremely easy to extend `htmlmetadata`. You can add support for a new tag by adding ~3 lines of code.

# Similar projects

- [MetadataParser](https://github.com/jvanasco/metadata_parser) is a python library for extracting HTML metadata. It's 10x slower than `htmlmetadata`, but it handles edge cases better.

# License

Dual-licensed under GPL3 (and its later versions) and MIT.
