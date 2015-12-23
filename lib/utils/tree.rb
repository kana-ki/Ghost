require 'interface/strings/constants'

class Tree

  def initialize(path)
    @path = path
  end

  def path
    @path
  end

  def list
    begin
      d = Dir.new(@path)
      d.each do |x|
        puts(x)
      end
    rescue SystemCallError
      puts INVALID_DIRECTORY
    end
  end

end