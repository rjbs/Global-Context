package Global::Context::Env;
use Moose::Role;

use Global::Context::Stack::Basic;

use namespace::autoclean;

has auth_token => (
  is   => 'ro',
  does => 'Global::Context::AuthToken',
  predicate => 'has_auth_token',
);

sub agent {
  return undef unless $_[0]->auth_token;
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

  return $self->meta->name->new({
    terminal => $self->terminal,
    stack    => $self->stack->with_pushed_frame($frame),
    ($self->has_auth_token ? (auth_token => $self->auth_token) : ()),
  });
}

1;
