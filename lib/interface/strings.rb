#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

module Interface

  module Strings

    INCORRECT_ARGS = 'Incorrect number of arguments given.'
    INVALID_DIRECTORY = 'Invalid directory given'
    INVALID_COMMAND = "Could not find command '%s', has it been properly added to the command directory?\n"
    PARAMS_MISMATCH = "Incorrect number of arguments for '%s', received %i, need %i.\n"
    STARTING_AS_DAEMON = 'Initializing as daemon.\n'
    STARTED_DAEMON_LISTENER = "Daemon listening on %i.\n"

  end

end
