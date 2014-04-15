package Global::Context::AuthToken;
use Moose::Role;
# ABSTRACT: an authentication token

use namespace::autoclean;

=head1 OVERVIEW

Global::Context::AuthToken is a role.

AuthToken objects represent the means by which a request was authenticated and
a handle by which actions can be checked for authorization.

They have two required methods: C<uri>, which must return a string, and
C<agent>, which must return a value pointing to the user.

It is expected that any serious use of Global::Context will use a non-trivial
AuthToken class that has more stringent requirements.

=cut

requires 'uri';
sub as_string { $_[0]->uri }

requires 'agent';

1;
