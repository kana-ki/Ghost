require 'interface/strings/constants'

class GhostTree

  def initialize(path)
    @path = path
  end

  def path
    @path
  end

  def list
    begin
      d = Dir.new(@path)
    rescue SystemCallError
      puts INVALID_DIRECTORY
    end
    d.each do |x|
      puts(x)
    end
  end

end