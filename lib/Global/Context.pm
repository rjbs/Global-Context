use strict;
use warnings;
package Global::Context;

use Carp ();
use Global::Context::Env::Basic;
use Global::Context::StackFrame::Trivial;
use Sub::Exporter::Util ();

{
  package Sub::Exporter::GlobSharer;
  use Scalar::Util ();

  my $is_ref;
  BEGIN {
    $is_ref = sub {
      return(
        !  Scalar::Util::blessed($_[0])
        && Scalar::Util::reftype($_[0]) eq $_[1]
      );
    };
  }

  sub glob_exporter {
    my ($default_name, $globref) = @_;

    my $globref_method = $is_ref->($globref, 'GLOB')   ? sub { $globref }
                       : $is_ref->($globref, 'SCALAR') ? $$globref
                       : Carp::confess("illegal glob locator '$globref'");

    return sub {
      my ($value, $data) = @_;
      my $globref = $data->{class}->$globref_method;

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
    '$Context' => Sub::Exporter::GlobSharer::glob_exporter(
      Context => \'common_globref',
    )
  },
};

sub common_globref { \*Object }

sub default_context_class { 'Global::Context::Env::Basic' }
sub default_frame_class   { 'Global::Context::StackFrame::Trivial' }

sub _build_ctx_init {
  my ($class, $name, $arg, $col) = @_;

  Carp::croak("can't import $name without importing \$Context")
    unless $col->{'$Context'};

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

  Carp::croak("can't import $name without importing \$Context")
    unless $col->{'$Context'};

  return sub {
    my ($frame) = @_;

    $frame = { description => $frame } unless ref $frame;

    $frame = $class->default_frame_class->new($frame)
      unless Scalar::Util::blessed($frame);

    return ${ *{ $col->{'$Context'} }{SCALAR} }->with_pushed_frame($frame);
  }
}

1;
