Clippy is a  cross-platform clipboard utility and script for Ruby.

---
* Requirements:
  * Ruby1.9+ or jRuby in 1.9 (Windows)
  * Ruby1.8.6+ (For Unix and Linux))
  * All platforms support jRuby in 1.8 or 1.9 mode except Windows.
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
<br />
<pre>
    Clippy v0.1 by Envygeeks
    --paste    Paste
    --help     This
    --clear    Clear
    --copy     Copy
    --version  Version
</pre>
