Clippy is a  cross-platform clipboard utility and script for Ruby.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/envygeeks/clippy)

---
* Requirements:
  * Ruby1.9+ or JRuby in 1.9+
  * Any Linux distro with xsel or xclip.
  * Any OS X version that supports pbcopy.
  * At least Windows Vista if you are on Windows.
* Development:
  * Rake
  * Minitest

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

<pre>
Clippy v1.0.1 by Envygeeks
  --no-encoding   Encoding
  --paste         Paste
  --help          This
  --clear         Clear
  --copy          Copy
  --version       Version
</pre>
