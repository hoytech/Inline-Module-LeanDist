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
        postamble => {
          inline => {
            file => 'lib/Acme/Math/XS/LeanDist.pm',
          },
        },
        OBJECT => '',
    );

B<NOTE>: The C<postamble.inline.file> parameter should be the filename of your module that is using L<Inline>, and you must have an C<OBJECT> parameter in the C<WriteMakefile> arguments.

=head1 DESCRIPTION

=head1 SEE ALSO

L<Inline-Module-LeanDist github repo|https://github.com/hoytech/Inline-Module-LeanDist>

=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2015 Doug Hoyte.

This module is licensed under the same terms as perl itself.
