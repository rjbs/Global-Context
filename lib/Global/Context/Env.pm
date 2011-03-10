package Global::Context::Env;
use Moose::Role;
# ABSTRACT: the global execution environment

=head1 OVERVIEW

Global::Context::Env is a role.

Global::Context::Env objects are the heart of the L<Global::Context> system.
They're the things that go in the shared C<$Context> variable, and they're the
things that point to the AuthToken, Terminal, and Stack.

=cut

with 'MooseX::Clone';

use Global::Context::Stack::Basic;

use namespace::autoclean;

=attr auth_token

Every environment either has an auth token that does
L<Global::Context::AuthToken> or it has none.  This attribute cannot be changed
after initialization.

The C<agent> method will return undef if there is no auth token, and will
otherwise get the agent from the token.

=cut

has auth_token => (
  is   => 'ro',
  does => 'Global::Context::AuthToken',
  predicate => 'has_auth_token',
);

sub agent {
  return undef unless $_[0]->has_auth_token;
  return $_[0]->auth_token->agent;
}

=attr terminal

Every environment has a terminal that does L<Global::Context::Terminal>.
This attribute cannot be changed after initialization.

=cut

has terminal => (
  is   => 'ro',
  does => 'Global::Context::Terminal',
  required => 1,
);

=attr stack

Every environment has a stack that does L<Global::Context::Stack>.
This attribute cannot be changed after initialization.

Instead, the C<with_pushed_frame> method is used to create a clone of the
entire environment, save for a new frame pushed onto the stack.

=cut

has stack => (
  is   => 'ro',
  does => 'Global::Context::Stack',
  required => 1,

  # XXX: This seems wrong; probably there should be no default, and it's up to
  # ctx_init to get this right. -- rjbs, 2010-12-13
  default  => sub { Global::Context::Stack::Basic->new },
);

=method stack_trace

C<< ->stack_trace >> is a convenience method that returns a list
containing the string representation of each frame in the stack.

=cut

sub stack_trace {
  my ($self) = @_;
  map $_->as_string, $self->stack->frames;
}

sub with_pushed_frame {
  my ($self, $frame) = @_;

  return $self->clone(
    stack => $self->stack->with_pushed_frame($frame),
  );
}

1;
