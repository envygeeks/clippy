Clippy is a  cross-platform clipboard utility and script for Ruby.

[![Build Status](https://travis-ci.org/envygeeks/clippy.svg?branch=master)][travis]
[![Test Coverage](https://codeclimate.com/github/envygeeks/clippy/badges/coverage.svg)][coverage]
[![Code Climate](https://codeclimate.com/github/envygeeks/clippy/badges/gpa.svg)][codeclimate]
[![Dependency Status](https://gemnasium.com/envygeeks/clippy.svg)][gemnasium]

[gemnasium]: https://gemnasium.com/envygeeks/clippy
[codeclimate]: https://codeclimate.com/github/envygeeks/clippy
[coverage]: https://codeclimate.com/github/envygeeks/clippy/coverage
[travis]: https://travis-ci.org/envygeeks/clippy
---
* Requirements:
  * Windows: `clip`
  * OS X: `pbcopy`
  * Linux: `xsel` || `xclip`

Examples:

```bash
clippy --copy '#1'
clippy --copy < 'file#3.txt'
echo '#2' |clippy --copy
clippy --paste
```

```ruby
require 'clippy'
Clippy.paste; Clippy.clear
Clippy.copy('#1')
```

```
Clippy v2.3.0: Clippy [--copy [< File] ['Text']]
  -p, --paste        Paste
  -N, --no-unescape  Do not unescape \n
  -c, --copy [STR]   Copy a String or STDIN```
  -v, --version      Version
  -C, --clear        Clear
```
