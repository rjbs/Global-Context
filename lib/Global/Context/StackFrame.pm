package Global::Context::StackFrame;
use Moose::Role;

use namespace::autoclean;

requires 'as_string';

has ephemeral => (
  is  => 'ro',
  isa => 'Bool',
  default => 0,
  reader  => 'is_ephemeral',
);

1;
