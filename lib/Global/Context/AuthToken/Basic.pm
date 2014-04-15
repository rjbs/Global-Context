package Global::Context::AuthToken::Basic;
use Moose;
with 'Global::Context::AuthToken';
# ABSTRACT: trivial class implementing Global::Context::AuthToken

=head1 SEE ALSO

L<Global::Context::AuthToken>

=cut

use namespace::autoclean;

has uri => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

has agent => (
  is   => 'ro',
  isa  => 'Defined',
  required => 1,
);

1;
