use strict;
use warnings;

use Global::Context -all, '$Context';

use Global::Context::AuthToken::Basic;
use Global::Context::Terminal::Basic;

use Test::More;

ctx_init({
  terminal => Global::Context::Terminal::Basic->new({ uri => 'ip://1.2.3.4' }),
  auth_token => Global::Context::AuthToken::Basic->new({
    uri   => 'websession://1234',
    agent => 'customer://abcdef',
  }),
});

{
  my @frames = map {; $_->as_string } $Context->stack->frames;
  is(@frames, 1);
  like($frames[0], qr/^context initialized/);
}

{
  local $Context = ctx_push("eat some pie");
  my @frames = map {; $_->as_string } $Context->stack->frames;
  is(@frames, 1);
  is($frames[0], 'eat some pie');
}

{
  my @frames = map {; $_->as_string } $Context->stack->frames;
  is(@frames, 1);
  like($frames[0], qr/^context initialized/);
}

done_testing;
