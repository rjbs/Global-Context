package Global::Context::Terminal;
use Moose::Role;
# ABSTRACT: the origin of a request

=head1 OVERVIEW

Global::Context::Terminal is a role.

Terminal objects represent the source machine (or other locator) of a request,
like an IP address, hostname, or other identifier.  They have only one required
attribute, C<uri>, which must be a string.

=cut

use namespace::autoclean;

has uri => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub as_string { $_[0]->uri }

1;
