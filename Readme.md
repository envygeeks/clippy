Clippy is a  cross-platform clipboard utility and script for Ruby.

[![Build Status](https://travis-ci.org/envygeeks/clippy.png?branch=master)](https://travis-ci.org/envygeeks/clippy) [![Coverage Status](https://coveralls.io/repos/envygeeks/clippy/badge.png?branch=master)](https://coveralls.io/r/envygeeks/clippy) [![Code Climate](https://codeclimate.com/github/envygeeks/clippy.png)](https://codeclimate.com/github/envygeeks/clippy) [![Dependency Status](https://gemnasium.com/envygeeks/clippy.png)](https://gemnasium.com/envygeeks/clippy)

---
* Requirements:
  * Windows: `clip`
  * OS X: `pbcopy`
  * Linux: `xsel` || `xclip`

*Right now there is a bug with jRuby stable that causes Clippy to fail, this bug is inside of Open3.popen3 where jRuby actually short-circuits and does not meet the same guidelines as Ruby1.9+, you can see the progress of this bug at: http://jira.codehaus.org/browse/JRUBY-6409 -- this has been fixed in jRuby-head so if you plan to use Clippy please use jRuby-head until a new stable is released.*

---
Examples:

```bash
clippy --copy '#1'
clippy --paste
echo '#2' |clippy --copy
clippy --copy < 'file#3.txt'
```

```ruby
require 'clippy'
Clippy.copy('#1')
Clippy.paste and Clippy.clear
```

```
Clippy v2.0.11: Clippy [--copy [< File] ['Text']]
  --paste    Paste
  --help     This
  --clear    Clear
  --version  Version
  --copy     Copy a String or STDIN
```
