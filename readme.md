About:
Clippy is a  cross-platform clipboard utility and script for Ruby.

---
Requirements:
  Windows:
    Ruby1.9
    Windows Vista+

  Development:
    cucumber
    rake
    minitest
    rspec-expectations

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
    Clippy.[paste, clear]

---
Clippy v0.1 by Envygeeks<br />
&nbsp;&nbsp;--paste&nbsp;&nbsp;&nbsp;&nbsp;Paste<br />
&nbsp;&nbsp;--help&nbsp;&nbsp;&nbsp;&nbsp;This<br />
&nbsp;&nbsp;--clear&nbsp;&nbsp;&nbsp;&nbsp;Clear<br />
&nbsp;&nbsp;--copy&nbsp;&nbsp;&nbsp;&nbsp;Copy<br />
&nbsp;&nbsp;--version&nbsp;&nbsp;&nbsp;&nbsp;Version

---
I want to throw a big  thank you to Nathaniel (@firestar) who took the time to
also build a Java version of clippy too.
