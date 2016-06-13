#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

$ghost_cmd['stop', lambda do |flags|

  require 'socket'

  force = flags.include?('f') || flags.include?('force')
  socket = TCPSocket.open('localhost', 2091)
  socket.puts('FORCE_QUIT') if force
  socket.puts('QUIT') unless force
  socket.close unless socket.closed?

end]