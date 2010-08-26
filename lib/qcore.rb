require File.join(File.dirname(__FILE__), 'qcore', 'authentication')
require File.join(File.dirname(__FILE__), 'qcore', 'authorization')

module Qcore
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
end

#ActionController::Base.extend Qcore::Authorization
#ActionController::Base.extend Qcore::Authentication

#class ActionController::Base
#   extend Qcore::Authorization
#   extend Qcore::Authentication
#end