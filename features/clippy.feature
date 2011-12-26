Feature: Clippy
  Background:
    Sometimes you would like to copy and paste from a Ruby script. In order to
    that though we will need a small little class called Clippy that can copy,
    paste and also clear the clipboard on Windows, Linux and Mac.

    Given Clippy exist and it has a version.
    Then Copy, Paste and Clear should exist.
