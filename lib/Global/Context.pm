use strict;
use warnings;
package Global::Context;

use Sub::Exporter -setup => {
  exports    => [
    init_context =>
  ],
  collectors => { '$Context' => \'_export_context_glob' },
};

our $Object;

sub _export_context_glob {
  my ($self, $value, $data) = @_;

  $value  = 'Context' unless defined $value;
  my $sym = "$data->{into}::$value";

  {
    no strict 'refs';
    *{$sym} = *Global::Context::Object;
  }

  return 1;
}

1;
