require 'utils/cmd'

$arg_lib = { }
$arg_lib['d|daemon'] = lambda { $daemon = true }

lambda do

  arguments = []
  command = []

  add_argument = lambda do | arg |
    $arg_lib.keys.each do |arg_key|
      arg_aliases = arg_key.split('|')
      arg_aliases.each do |arg_alias|
        if arg_alias == arg
          add_argument = true
          arguments.each do |existing_arg|
            add_argument = false if existing_arg == $arg_lib[arg_key]
          end
          arguments << $arg_lib[arg_key] if add_argument
        end
      end
    end
  end

  ARGV.each do |arg|
    if arg.start_with?('-')
      add_argument.call(arg.sub(/\-*/, ''))
    else
      command << arg
    end
  end

  arguments.each { |arg| arg.call }

  if command.length > 0
    Cmd::exec(command)
    exit
  end

end[]