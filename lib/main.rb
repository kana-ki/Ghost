#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

# Don't reserve prints in buffer, immediately flush
$stdout.sync = $stdin.sync = true

# Load path for requires
$: << '.'
require 'interface/strings/constants'
require 'utils/tree'
require 'utils/cmd'

include Interface::Strings

if ARGV.length > 0
  Cmd::exec(ARGV)
  exit
end

loop do
  print '$ghost > '
  # Kernel.gets tries to read the params found in ARGV and only asks console if there are none found in ARGV. To force a read from console - even if ARGV is not empty - use STDIN.
  request = STDIN.gets.strip!.split(' ')
  next if request.empty?
  Cmd::exec(request)
end