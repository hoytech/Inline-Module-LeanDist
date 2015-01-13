package Inline::Module::LeanDist;

use strict;

use File::Path;

our $VERSION = '0.100';

our $inline_build_path = '.inline';


sub import {
    my $class = shift;

    File::Path::mkpath($inline_build_path)
        unless -d $inline_build_path;

    my ($module_name) = caller;

    require Inline;

    Inline->import(
        Config =>
        directory => $inline_build_path,
        name => $module_name,
        CLEAN_AFTER_BUILD => 0,
    );

    Inline->import_heavy(@_);
}


1;


__END__

=encoding utf-8

=head1 NAME

Inline::Module::LeanDist - Develop your module with Inline but distribute lean XS

=head1 SYNOPSIS

In your module (say C<Acme::Math::XS::LeanDist>):

    use Inline::Module::LeanDist C => 'DATA';

This module forwards all its parameters to L<Inline>.

B<NOTE>: Currently the entire use statement must be on one line! The DATA section is generally the best place to put your code (heredocs won't work).

In C<Makefile.PL>:

    use ExtUtils::MakeMaker;

    use Inline::Module::LeanDist::MakefilePL;

    WriteMakefile(
        NAME => 'Acme::Math::XS::LeanDist',
        OBJECT => '',
        postamble => {
          inline => {
            file => 'lib/Acme/Math/XS/LeanDist.pm',
          },
        },
    );

B<NOTE>: The C<postamble.inline.file> parameter should be the filename of your module that is using L<Inline>, and you must have an C<OBJECT> parameter in the C<WriteMakefile> arguments.

=head1 DESCRIPTION

This module is heavily inspired by L<Inline::Module>. I wrote it because I wanted to be able to use Inline during development, but ship distributions that have no dependencies on L<Inline> or any other module (for example L<Inline::Filters> and its plugins). I wanted to ship distributions that were (from the user's perspective) identical to XS dists I would have created by hand (without L<Inline>).

Essentially, L<Inline> compiles your code at run-time meaning all compilation dependencies are required then. L<Inline::Module> pushes the compilation dependency requirements back to distribution build time. However, L<Inline::Module::LeanDist> goes one step futher and pushes back the compilation dependencies to distribution I<creation> time (except for a regular XS tool-chain).

The advantage of the L<Inline::Module> approach over L<Inline> is that start-up time is faster for your modules since the fairly heavy-weight L<Inline> system isn't loaded, and a compiled version is always available no matter what the state of your C<.inline> directory is (or which user is running the program or file-system permissions, etc).

L<Inline::Module::LeanDist> has all of these advantages as well as some additional ones: Downloading and installing L<Inline> is not necessary to build the distribution. This also goes for any other dependencies (such as the C<ragel> binary required by L<Inline::Filters::Ragel>). Also, you don't need to worry about updates to L<Inline>/L<Inline::Module>/etc breaking your distribution (though note that L<Inline::Module> recommends avoiding this by bundling the multi-hundreds of KB L<Inline> tool-chain with every distribution). Finally, with L<Inline::Module::LeanDist> you don't need to mess around with awkward "stub" packages.

However, L<Inline::Module> will likely work for more ILSMs. This module has only been tested with L<Inline::C> so far. Also, although it's a bit subjective, in my opinion L<Inline::Module> is slightly nicer to develop with since it always puts the L<.so> files into C<blib/> which is more "normal" than the C<.inline> directory (and of course C<make> actually compiles your code). 


=head1 HOW DOES IT WORK?

Basically it's all a huge hack. :)

During development time, the L<Inline::Module::LeanDist> forwards all its parameters to L<Inline> so you develop with normal L<Inline> practices.

However, L<Inline::Module::LeanDist::MakefilePL> modifies C<Makefile.PL> so that at C<make dist> time, it will comment out the C<use Inline::Module::LeanDist::MakefilePL;> line in C<Makefile.PL>. It will also comment out the C<use Inline::Module::LeanDist ...> line in your module and replace it with an L<XSLoader> invocation. Finally, it copies the generated C<.xs> file from the C<.inline> directory into the distribution and adds this to the C<OBJECT> parameter in C<Makefile.PL> (as well as the dist's C<MANIFEST>).

The consequence of all this hacking is that the created distributions are lean, XS-only distributions.


=head1 EXAMLES

L<Acme::Math::XS::LeanDist> - This is a very simple example in the style of L<Acme::Math::XS> and co.

L<Unicode::Truncate> - This is an actually somewhat useful module that doubles as a proof of concept for L<Inline::Module::LeanDist> and L<Inline::Filters::Ragel>.


=head1 BUGS

It really ought to be possible to have multiple separate files in a single dist that use L<Inline>, but this is not yet supported.

It should support C<Build.PL> in addition to C<Makefile.PL>.

It shoud be possible to do something like this with C++.


=head1 SEE ALSO

L<Inline-Module-LeanDist github repo|https://github.com/hoytech/Inline-Module-LeanDist>

L<Inline::Module>

=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2015 Doug Hoyte.

This module is licensed under the same terms as perl itself.
