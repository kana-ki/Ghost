require 'utils/ghost_tree'

$ghost['ls', lambda do | path |

  tree = GhostTree.new path
  tree.list
  print "\n"

end]