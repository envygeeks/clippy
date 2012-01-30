Clippy is a  cross-platform clipboard utility and script for Ruby.

---
* Requirements:
  * Ruby1.9 (if on Windows)
* Development:
  * Cucumber
  * Rake
  * Minitest
  * RSPEC-Expectations

All other distros should work with 1.8+

    # Shell (Linux and Windows)
    clippy --copy '#1'
    echo '#2' |clippy --copy
    clipy --copy < 'file#3.txt'
    
    # Ruby1.8+
    require 'clippy'
    Clippy.copy('#1')
    Clippy.paste and Clippy.clear

<pre>
    Clippy v0.1 by Envygeeks
    --paste    Paste
    --help     This
    --clear    Clear
    --copy     Copy
    --version  Version
</pre>
