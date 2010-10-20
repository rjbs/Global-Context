package Global::Context::Terminal;
use Moose::Role;

use namespace::autoclean;

has uri => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub as_string { $_[0]->uri }

1;
