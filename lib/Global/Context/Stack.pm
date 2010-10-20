package Global::Context::Stack;
use Moose::Role;

use Moose::Util::TypeConstraints;

use namespace::autoclean;

role_type('Global::Context::StackFrame');

has frames => (
  is     => 'ro',
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

  $self->meta->name->new({
    frames => [ @frames, $frame ],
  });
}

1;
