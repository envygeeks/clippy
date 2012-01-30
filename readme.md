About:
Clippy is a  cross-platform clipboard utility and script for Ruby.

---
<pre>
Requirements:
  Windows:
    Ruby1.9
    Windows Vista+

  Development:
    cucumber
    rake
    minitest
    rspec-expectations

All other distros should work with 1.8+  If you have Ruby1.8 please install JSON too.
</pre>

---
<pre>
Usage:
  Shell:
    clippy --copy '#1'
    echo '#2' |clippy --copy
    clipy --copy < 'file#3.txt'
  Ruby:
    require 'clippy'
    Clippy.copy('#1')
    Clippy.[paste, clear]
</pre>

---
<pre>
    Clippy v0.1 by Envygeeks
    --paste    Paste
    --help     This
    --clear    Clear
    --copy     Copy
    --version  Version
</pre>

---
I want to throw a big  thank you to Nathaniel (@firestar) who took the time to
also build a Java version of clippy too.
