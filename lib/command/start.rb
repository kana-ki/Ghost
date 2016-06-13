#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

$ghost_cmd['start', lambda do

  RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')

  IO.popen ("#{RUBY} main.rb -d &")
  # pid = Process.spawn("`ruby main.rb -d")
  # Process.detach(pid)

end]