package Global::Context::Stack;
use Moose::Role;

with 'MooseX::Clone';

use Moose::Util::TypeConstraints;

use namespace::autoclean;

role_type('Global::Context::StackFrame');

has frames => (
  isa    => 'ArrayRef[ Global::Context::StackFrame ]',
  reader => '_frames',
  traits => [ 'Array' ],
  default => sub { [] },
  handles => {
    frames => 'elements',
  },
);

sub with_pushed_frame {
  my ($self, $frame) = @_;

  my @frames = $self->frames;
  pop @frames if @frames and $frames[0]->is_ephemeral;

  $self->clone(frames => [ @frames, $frame ]);
}

1;
