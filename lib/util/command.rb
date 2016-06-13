#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

module Util

  CMD_TYPE_LAMBDA = 1
  CMD_TYPE_PROC = 2
  CMD_TYPE_SYMBOL = 3

  $_ghost_cmds = {}
  $ghost_cmd = lambda { |name, proc| $_ghost_cmds[name.downcase] = proc }

  Dir['command/*.rb'].each { | f | require f }

  class Command

    def self.handle_cmds
      loop do
        print '$ghost > '
        request = STDIN.gets.strip!.split(' ')  ## Kernel.gets tries to read the params found in ARGV and only asks console if there are none found in ARGV.
        next if request.empty?                   # To force a read from console - even if ARGV is not empty - use STDIN.
        action(*Argument::lex(request))
      end
    end

    def self.action(cmd, flags = [])
      cmd_str = cmd[0].downcase
      args = cmd[1..-1]
      cmd = resolve(cmd_str)
      if cmd == nil
        printf INVALID_COMMAND, cmd_str
        return
      end
      if cmd.check_args(args)
        cmd.exec(args, flags, false)
      else
        printf PARAMS_MISMATCH, cmd_str, args.length, cmd.arity
      end
    end

    def self.resolve(cmd_str)
      cmd = $_ghost_cmds[cmd_str]
      cmd == nil ? nil : new(cmd)
    end

    def initialize(cmd)
      if cmd.respond_to?('lambda?')
        @cmd_type = cmd.lambda? ? CMD_TYPE_LAMBDA : CMD_TYPE_PROC
      elsif cmd.respond_to?('to_proc')
        @cmd_type = CMD_TYPE_SYMBOL
      else
        raise 'Command is neither Lambda, Proc nor Symbol'
      end
      @cmd_block = cmd
    end

    def exec(args, flags, arity_check = true)
      send(@cmd_block, *args) unless arity_check && !self.check_args(args) if @cmd_type == CMD_TYPE_SYMBOL
      unless arity_check && !self.check_args(args)
        args.unshift(flags) if self.wants_flags
        @cmd_block[*args]
      end
      -1
    end

    def check_args(args)
      if @cmd_type == CMD_TYPE_LAMBDA || @cmd_type == CMD_TYPE_SYMBOL
        proc = @cmd_block.to_proc
        arity = proc.arity
        if arity < 0
          arity *= -1
          arity -= 1
        end
        arity -= 1 if self.wants_flags
        return args.length == arity
      end
      true
    end

    def arity
      if @cmd_type == CMD_TYPE_LAMBDA || @cmd_type == CMD_TYPE_SYMBOL
        arity = @cmd_block.to_proc.arity
        arity -= 1 if self.wants_flags
        return arity
      end
      -1
    end

    def wants_flags
      proc = @cmd_block.to_proc
      proc.parameters.length > 0 && proc.parameters[0][-1].id2name == 'flags'
    end

  end

end
