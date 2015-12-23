$ghost_cmds = {}
$ghost = lambda do |name, proc|
  $ghost_cmds[name.downcase] = proc
end

Dir['command/*.rb'].each { | f | require f }

class Cmd

  def self.exec(request)
    cmd_str = request[0].downcase
    args = request[1..-1]
    cmd = Cmd::resolve(cmd_str)
    return printf INVALID_COMMAND, cmd_str unless cmd != nil
    if cmd.check_args(args)
      cmd.exec(args)
    else
      printf PARAMS_MISMATCH, cmd_str, args.length, cmd.arity
    end
  end

  def self.resolve(cmd_str)
    cmd = $ghost_cmds[cmd_str]
    cmd == nil ? nil : Cmd::new(cmd)
  end

  def initialize(cmd)
    @cmd_block = cmd
  end

  def exec(args)
    check_args(args) ? @cmd_block[*args] : -1
  end

  def check_args(args)
    if @cmd_block.lambda?
      arity = @cmd_block.arity
      if arity < 0
        arity *= -1
        arity -= 1
      end
      args.length == arity
    end
  end

  def arity
    @cmd_block.lambda? ? @cmd_block.arity : -1
  end

end