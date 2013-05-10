Clippy is a  cross-platform clipboard utility and script for Ruby.

[![Build Status](https://travis-ci.org/envygeeks/clippy.png?branch=master)](https://travis-ci.org/envygeeks/clippy) [![Coverage Status](https://coveralls.io/repos/envygeeks/clippy/badge.png?branch=master)](https://coveralls.io/r/envygeeks/clippy) [![Code Climate](https://codeclimate.com/github/envygeeks/clippy.png)](https://codeclimate.com/github/envygeeks/clippy) [![Dependency Status](https://gemnasium.com/envygeeks/clippy.png)](https://gemnasium.com/envygeeks/clippy)

---
* Requirements:
  * Any Linux distro with xsel or xclip.
  * Ruby1.9+, Ruby2.0+ or JRuby in 1.9+
  * Any OS X version that supports pbcopy.
  * At least Windows Vista if you are on Windows.

---
Examples:

```bash
clippy --copy "#1"
clippy --paste
echo "#2" |clippy --copy
clippy --copy < "file#3.txt"
```

```ruby
require 'clippy'
Clippy.copy('#1')
Clippy.paste and Clippy.clear
```

```
Clippy v2.0.0: Clippy [--copy [< File] ['Text']]
  --paste    Paste
  --help     This
  --clear    Clear
  --version  Version
  --copy     Copy a String or STDIN
```
