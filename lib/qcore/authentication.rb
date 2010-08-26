module Qcore
  module Authentication

    def qcore_authentication
      send :include, InstanceMethods
      send :extend, ClassMethods
      
      protect_from_forgery # See ActionController::RequestForgeryProtection for details

      helper_method :current_user_session, :current_user
      filter_parameter_logging :password, :password_confirmation
      
    end

    module ClassMethods
    end
  
    module InstanceMethods
      private

      def record_not_found
        render :template => 'pages/404', :status => 404
      end

      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
      end

      def require_user
        unless current_user
          store_location
          flash[:notice] = "You must be logged in to access this page"
          redirect_to new_user_session_url
          return false
        end
      end

      def require_no_user
        if current_user
          store_location
          flash[:notice] = "You must be logged out to access this page"
          redirect_to root_url
          return false
        end
      end

      def store_location
        session[:return_to] = request.request_uri
      end

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end
    end
  end
end