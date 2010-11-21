use strict;
use warnings;
package Global::Context;

use Carp ();
use Global::Context::Env::Basic;
use Global::Context::StackFrame::Trivial;
use Sub::Exporter::Util ();

our $Object;

use Sub::Exporter -setup => {
  exports    => [
    ctx_init => Sub::Exporter::Util::curry_method,
    ctx_push => Sub::Exporter::Util::curry_method,
  ],
  collectors => { '$Context' => \'_export_context_glob' },
};

sub default_variable_name { 'Context' }
sub default_shared_glob { \*Object }

sub _export_context_glob {
  my ($self, $value, $data) = @_;

  my $name;
  $name = $value->{'-as'} || $self->default_variable_name;
  $name =~ s/^\$//;

  my $sym = "$data->{into}::$name";

  {
    no strict 'refs';
    *{$sym} = *{ $self->default_shared_glob };
  }

  return 1;
}

sub default_context_class { 'Global::Context::Env::Basic' }
sub default_frame_class   { 'Global::Context::StackFrame::Trivial' }

sub ctx_init {
  my ($class, $arg) = @_;
  Carp::confess("context has already been initialized") if $Object;

  $Object = $class->default_context_class->new($arg)->with_pushed_frame(
    $class->default_frame_class->new({
      description => Carp::shortmess("context initialized"),
      ephemeral   => 1,
    }),
  );

  return $Object;
}

sub ctx_push {
  my ($class, $frame) = @_;

  $frame = { description => $frame } unless ref $frame;

  $frame = $class->default_frame_class->new($frame)
    unless Scalar::Util::blessed($frame);

  return $Object->with_pushed_frame($frame);
}

1;
