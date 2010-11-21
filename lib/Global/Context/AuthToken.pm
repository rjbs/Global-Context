package Global::Context::AuthToken;
use Moose::Role;

use namespace::autoclean;

has uri => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub as_string { $_[0]->uri }

has agent => (
  is   => 'ro',
  isa  => 'Defined',
  required => 1,
);

1;
