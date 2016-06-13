#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

$stdout.sync = $stdin.sync = true # Don't withhold prints in buffer, immediately flush
$: << '.' # Load path for requires
require 'interface/strings'
require 'util/tree'
require 'util/argument'
require 'util/command'
require 'daemon'

include Interface::Strings

Util::Argument::handle_args
Util::Command::handle_cmds unless $daemon

Daemon::new if $daemon