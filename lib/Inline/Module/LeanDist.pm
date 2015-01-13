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

=head1 DESCRIPTION

=head1 SEE ALSO

L<Inline-Module-LeanDist github repo|https://github.com/hoytech/Inline-Module-LeanDist>

=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2015 Doug Hoyte.

This module is licensed under the same terms as perl itself.
