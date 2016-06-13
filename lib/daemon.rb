#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

DAEMON_PORT = 2091

class Daemon

  def initialize
    print STARTING_AS_DAEMON if $daemon
    Thread::new { start_listening }
    sleep
  end

  def start_listening
    require 'socket'
    @server = TCPServer.open(DAEMON_PORT)
    printf STARTED_DAEMON_LISTENER, DAEMON_PORT if $daemon
    @client_handles = []
    Thread::new(@server.accept) { |c| self.handle_client(c) } until @server.closed?
  end

  def stop_listening
    @server.close unless @server.closed?
  end

  def handle_client(client)
    command = client.gets.strip
    case command
      when 'FORCE_QUIT'
        exit
      when 'QUIT'
        self.stop_listening
        exit
      when 'STOP_LISTENING'
        self.stop_listening
    end
    client.close
  end

end