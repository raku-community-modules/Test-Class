use Test;

# Re-export Test's exported routines as if they came from us
sub EXPORT { (|::EXPORT::DEFAULT::, |Test::EXPORT::DEFAULT::).Map }

my role Test::Class::Method[$ttype, $tcount] {
    has $.test-type  = $ttype;
    has $.test-count = $tcount;
}

multi sub trait_mod:<is>(Method:D $meth, :$test-startup!) is export {
    $meth does Test::Class::Method['Startup', $test-startup]
}
multi sub trait_mod:<is>(Method:D $meth, :$test-shutdown!) is export {
    $meth does Test::Class::Method['Shutdown', $test-shutdown]
}
multi sub trait_mod:<is>(Method:D $meth, :$test-setup!) is export {
    $meth does Test::Class::Method['Setup', $test-setup]
}
multi sub trait_mod:<is>(Method:D $meth, :$test!) is export {
    $meth does Test::Class::Method['Test', $test]
}
multi sub trait_mod:<is>(Method:D $meth, :$tests!) is export {
    $meth does Test::Class::Method['Test', *]
}
multi sub trait_mod:<is>(Method:D $meth, :$test-teardown!) is export {
    $meth does Test::Class::Method['Teardown', $test-teardown]
}

role Test::Class is export {
    method run-tests(*@test-objs) {
        my @objs = @test-objs || self;
        for @objs -> $o is copy {
            $o = $o.new unless $o.DEFINITE;
            my @meths = $o.^methods;
            my @counts = @meths.grep({ (.?test-type // '') eq 'Test' || .?test-count !~~ Bool })
                               .map({ .?test-count // 0 });
            plan any(@counts) ~~ Whatever ?? * !! [+] @counts;
            my %h = @meths.classify({ .?test-type // '' });
            %h{%h.keys} = %h.values».sort(*.name);
            for @(%h<Startup> // []) { $o.$_(); }
            for @(%h<Test> // []) -> $m { 
                for @(%h<Setup> // []) { $o.$_(); }
                $o.$m(); 
                for @(%h<Teardown> // []) { $o.$_(); }
            }
            for @(%h<Shutdown> // []) { $o.$_(); }
        }
    }
}

=begin pod

=head1 NAME

Test::Class - Raku version of Perl's Test::Class

=head1 SYNOPSIS

=begin code :lang<raku>

use Dest::Class;

=end code

=head1 DESCRIPTION

Some people at work are enamored of Perl's Test::Class, so I thought
I'd have a look at it. This module is an attempt to recreate much of the
same functionality for Raku.

There are no docs yet.  See the programs in examples/ for how to use it.

Random things that come to mind though:

=item * this Test::Class is a role that you can compose into your own classes

=item * Instead of running Test::Class.run-tests, you execute YourClass.run-tests
or Test::Class.run-tests(YourClass)

=item * where in Perl you'd say "sub foo : Test", here you'd say "method foo is test"

=item * instead of ": Test(no_plan)", you say "is test(*)" or "is tests"

=item * this Test::Class will also export the Test routines so that you
don't have to (i.e., in Perl you'd need to say "use Test::Class; use
Test::More;" if you wanted to use the is(), ok(), etc. routines. For
this version of Test::Class, you just say "use Test::Class;" and you've
automatically got those routines in your lexical scope)

=head1 AUTHOR

Jonathan Scott Duff

=head1 COPYRIGHT AND LICENSE

Copyright 2015 - 2017 Jonathan Scott Duff

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
