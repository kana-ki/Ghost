#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

module Util

  ARG_TYPE_SHORT = 1
  ARG_TYPE_LONG = 2

  $_ghost_args = {}
  $ghost_arg = lambda { |name, proc| $_ghost_args[name.downcase] = proc }

  Dir['argument/*.rb'].each { | f | require f }

  $_exec_args = []

  class Argument

    def self.handle_args
      cmds, flags = lex
      flags.each do |arg|
        flags.delete(arg) if action(arg)[1]
      end
      if cmds.length > 0
        Command::action(cmds, flags)
        exit
      end
    end

    def self.action(arg)
      arg_proc = resolve(arg)
      found = arg_proc != nil
      return (found && !arg_proc.executed? ? arg_proc.exec : false), found
    end

    def self.lex(arr = ARGV)
      flags = []
      commands = []
      arr.each do |argv|
        if argv.start_with?('-')
          arg_type = get_flag_type(argv)
          arg = argv.sub(/^\-{1,2}/, '')
          if arg_type == ARG_TYPE_SHORT
            flags += arg.split('')
          elsif arg_type == ARG_TYPE_LONG
            flags << arg
          end
        else
          commands << argv
        end
      end
      return commands, flags
    end

    def self.get_flag_type(request)
      return ARG_TYPE_LONG if request.start_with?("--")
      return ARG_TYPE_SHORT if request.start_with?("-")
    end

    def self.resolve(arg)
      $_ghost_args.keys.each do |arg_key|
        arg_key.split('|').each do |arg_alias|
          next unless arg_alias == arg
          return new($_ghost_args[arg_key])
        end
      end
      nil
    end

    def executed?
      $_exec_args.each do |exec_arg|
        return true if exec_arg == @arg_block
      end
      false
    end

    def initialize(arg_block)
      @arg_block = arg_block
    end

    def exec()
      @arg_block[]
      $_exec_args << @arg_block
    end

  end

end