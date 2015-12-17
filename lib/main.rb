#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev

$LOAD_PATH << '.'
require 'interface/strings/constants'
require 'utils/ghost_tree'

include Interface::Strings

##

commands = {}
$ghost = lambda do |name, proc|
  commands[name] = proc
end

Dir['command/*.rb'].each { | f | require f }

if ARGV.length > 0
  p INCORRECT_ARGS
end

loop do
  print '> '
  # Kernel.gets tries to read the params found in ARGV and only asks to console if not ARGV found. To force to read from console even if ARGV is not empty use STDIN.
  request = STDIN.gets.strip!.split(' ')
  next if request.empty?
  command_str = request[0]
  args = request[1..-1]
  command = commands[command_str]
  if command == nil
    printf INVALID_COMMAND, command_str
    next
  end
  if command.lambda?
    arity = command.arity
    if arity < 0
      arity *= -1
      arity -= 1
    end
    unless args.length == arity
      printf PARAMS_MISMATCH, command_str, args.length, arity
      next
    end
  end
  command.call(*args)
end