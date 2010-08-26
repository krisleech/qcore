module Qcore
  module Authorization


    def qcore_autherization
      send :include, InstanceMethods
      send :extend, ClassMethods
      
      before_filter :authorisation
    end

    module ClassMethods
      
    end

    module InstanceMethods
      # Autherisation for controller
      # Maps user roles to controller/actions
      def authorisation
        crud_map = { 'index' => 'read', 'show' => 'read', 'new' => 'create', 'create' => 'create', 'edit' => 'update', 'update' => 'update', 'destroy' => 'delete'}

        allowed = false

        # load auth file for current environment
        auth_file = File.join(RAILS_ROOT, 'config', 'authorisation.yml')
        raise "authorisation.yml missing" unless File.exists? auth_file
        auth = YAML::load(File.open(auth_file))[RAILS_ENV]
      
        # TODO: replace with this (upgrade to latest settingslogic as to_hash does not return a Hash)
        #auth = Settings.security.authorization.to_hash
      

        controller_name = self.class.to_s.gsub('Controller', '').downcase # 'ReportsController' becomes 'reports'



        # get hash for controller (navigate down namespacing)
        controller_name.split('::').each do | c |

          auth = auth[c]

          break if auth.is_a? String # leaf
        end

        # hash of actions and roles
        if auth.is_a? Hash
          action_name = crud_map[self.action_name] || self.action_name
          auth = auth[action_name] || auth['all']
          unless auth.nil?
            auth = auth.split(' ')
          else
            render :text => "Action (#{action_name}) not found" and return if RAILS_ENV == 'development'
          end
        end

        auth = auth.split(' ') if auth.is_a? String # turn single role in to an array

        # auth is now an array of roles
        if auth.is_a? Array
          allowed = true if auth.include? 'public'
          if current_user
            allowed = true if current_user.roles.any? { |r| auth.include? r }
            allowed = true if current_user.roles.include? 'super'
            logger.debug 'No roles' if current_user.roles.empty?
          else
            logger.debug 'Not logged in'
          end
        end

        logger.debug "**********"
        logger.debug "controller: #{self.controller_name} action: #{self.action_name}"
        logger.debug "controller: #{controller_name}"
        logger.debug "action roles: #{auth.inspect} "
        logger.debug "user roles: #{current_user.roles.inspect}" if current_user
        logger.debug "allowed: #{allowed}"
        logger.debug "**********"

        unless allowed
          if current_user
            render :text => 'Not allowed' and return
          else
            store_location
            flash[:notice] = 'Please login to continue'
            redirect_to login_path and return
          end
        end
      end
    end
  end
end