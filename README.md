[![Actions Status](https://github.com/raku-community-modules/Test-Class/workflows/test/badge.svg)](https://github.com/raku-community-modules/Test-Class/actions)

NAME
====

Test::Class - Raku version of Perl's Test::Class

SYNOPSIS
========

```raku
use Dest::Class;
```

DESCRIPTION
===========

Some people at work are enamored of Perl's Test::Class, so I thought I'd have a look at it. This module is an attempt to recreate much of the same functionality for Raku.

There are no docs yet. See the programs in examples/ for how to use it.

Random things that come to mind though:

  * * this Test::Class is a role that you can compose into your own classes

  * * Instead of running Test::Class.run-tests, you execute YourClass.run-tests or Test::Class.run-tests(YourClass)

  * * where in Perl you'd say "sub foo : Test", here you'd say "method foo is test"

  * * instead of ": Test(no_plan)", you say "is test(*)" or "is tests"

  * * this Test::Class will also export the Test routines so that you don't have to (i.e., in Perl you'd need to say "use Test::Class; use Test::More;" if you wanted to use the is(), ok(), etc. routines. For this version of Test::Class, you just say "use Test::Class;" and you've automatically got those routines in your lexical scope)

AUTHOR
======

Jonathan Scott Duff

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2017 Jonathan Scott Duff

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

