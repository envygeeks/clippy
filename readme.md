Clippy is a  cross-platform clipboard utility and script for Ruby.

---
* Requirements:
  * Windows:
    * Ruby1.9
    * Windows Vista+
* Development:
  * Cucumber
  * Rake
  * Minitest
  * RSPEC-Expectations

All other distros should work with 1.8+

---
Usage:
  Shell:
    clippy --copy '#1'
    echo '#2' |clippy --copy
    clipy --copy < 'file#3.txt'
  Ruby:
    require 'clippy'
    Clippy.copy('#1')
    Clippy.paste and Clippy.clear

---
<pre>
    Clippy v0.1 by Envygeeks
    --paste    Paste
    --help     This
    --clear    Clear
    --copy     Copy
    --version  Version
</pre>
