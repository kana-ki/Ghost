require 'utils/tree'

$ghost['ls', lambda do | path |

  tree = Tree.new path
  tree.list
  print "\n"

end]