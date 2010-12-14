package Global::Context::StackFrame;
use Moose::Role;
# ABSTRACT: one frame in a stack

=head1 OVERVIEW

Global::Context::StackFrame is a role.

Stack frames are only required to provide an C<as_string> method.  The
StackFrame role also provides a boolean C<ephemeral> attribute indicating
whether a frame is ephemeral.

Most frames are I<not> ephemeral, but those that are will be replaced when a
new frame is pushed, rather than being shifted down.

=cut

use namespace::autoclean;

requires 'as_string';

has ephemeral => (
  is  => 'ro',
  isa => 'Bool',
  default => 0,
  reader  => 'is_ephemeral',
);

1;
