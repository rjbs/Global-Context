package Global::Context::Env;
use Moose::Role;

with 'MooseX::Clone';

use Global::Context::Stack::Basic;

use namespace::autoclean;

has auth_token => (
  is   => 'ro',
  does => 'Global::Context::AuthToken',
  predicate => 'has_auth_token',
);

sub agent {
  return undef unless $_[0]->has_auth_token;
  return $_[0]->auth_token->agent;
}

has terminal => (
  is   => 'ro',
  does => 'Global::Context::Terminal',
  required => 1,
);

has stack => (
  is   => 'ro',
  does => 'Global::Context::Stack',
  required => 1,
  default  => sub { Global::Context::Stack::Basic->new },
);

sub with_pushed_frame {
  my ($self, $frame) = @_;

  return $self->clone(
    stack => $self->stack->with_pushed_frame($frame),
  );
}

1;
