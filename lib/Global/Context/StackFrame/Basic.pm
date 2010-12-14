package Global::Context::StackFrame::Basic;
use Moose;
with 'Global::Context::StackFrame';
# ABSTRACT: trivial class implementing Global::Context::StackFrame

=head1 SEE ALSO

L<Global::Context::Terminal>

=cut

has description => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub as_string { $_[0]->description }

1;
