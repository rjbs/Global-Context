use strict;
use warnings;
package Global::Context;

use Carp ();
use Global::Context::Env::Basic;
use Global::Context::StackFrame::Trivial;
use Sub::Exporter::Util ();

{
  package Sub::Exporter::GlobSharer;

  sub glob_export_collector {
    my ($default_name, $globref) = @_;

    return sub {
      my ($value, $data) = @_;

      my $name;
      $name = defined $value->{'-as'} ? $value->{'-as'} : $default_name;

      my $sym = "$data->{into}::$name";

      {
        no strict 'refs';
        *{$sym} = *$globref;
      }

      $_[0] = $globref;
      return 1;
    }
  }
}

use Sub::Exporter -setup => {
  exports    => [
    ctx_init => \'_build_ctx_init',
    ctx_push => \'_build_ctx_push',
  ],
  collectors => {
    '$Context' => Sub::Exporter::GlobSharer::glob_export_collector(
      Context => \*Object,
    )
  },
};

sub default_context_class { 'Global::Context::Env::Basic' }
sub default_frame_class   { 'Global::Context::StackFrame::Trivial' }

sub _build_ctx_init {
  my ($class, $name, $arg, $col) = @_;

  return sub {
    my ($arg) = @_;

    my $ref = *{ $col->{'$Context'} }{SCALAR};
    Carp::confess("context has already been initialized") if $$ref;

    $$ref = $class->default_context_class->new($arg)->with_pushed_frame(
      $class->default_frame_class->new({
        description => Carp::shortmess("context initialized"),
        ephemeral   => 1,
      }),
    );

    return $$ref;
  };
}

sub _build_ctx_push {
  my ($class, $name, $arg, $col) = @_;

  return sub {
    my ($frame) = @_;

    $frame = { description => $frame } unless ref $frame;

    $frame = $class->default_frame_class->new($frame)
      unless Scalar::Util::blessed($frame);

    return ${ *{ $col->{'$Context'} }{SCALAR} }->with_pushed_frame($frame);
  }
}

1;
