#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

require 'util/tree'

$ghost_cmd['ls', lambda do | flags, path |

  tree = Util::Tree.new path
  tree.list
  print "\n"

end]