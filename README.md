Clippy is a  cross-platform clipboard utility and script for Ruby.

[![Build Status](https://travis-ci.org/envygeeks/ruby-clippy.png?branch=master)](https://travis-ci.org/envygeeks/ruby-clippy) [![Coverage Status](https://coveralls.io/repos/envygeeks/ruby-clippy/badge.png?branch=master)](https://coveralls.io/r/envygeeks/ruby-clippy) [![Code Climate](https://codeclimate.com/github/envygeeks/ruby-clippy.png)](https://codeclimate.com/github/envygeeks/ruby-clippy) [![Dependency Status](https://gemnasium.com/envygeeks/ruby-clippy.png)](https://gemnasium.com/envygeeks/ruby-clippy)

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
