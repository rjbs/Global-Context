package Global::Context::StackFrame::Trivial;
use Moose;
with 'Global::Context::StackFrame';

has description => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub as_string { $_[0]->description }

1;
