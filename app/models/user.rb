class User < ActiveRecord::Base
  acts_as_authentic

  self.skip_time_zone_conversion_for_attributes = [] # FIX BUG: https://rails.lighthouseapp.com/projects/8994/tickets/1339-arbase-should-not-be-nuking-its-children-just-because-it-lost-interest

  validates_presence_of :first_name, :last_name  
 
  after_save  :empty_password

  # return an anonymous user
  def self.anonymous
    User.find_by_email('anonymous@example.com')
  rescue
    raise 'No anonymous user found'
  end
  
  def name   
    "#{first_name} #{last_name}"
  end

  def roles=(input)
    write_attribute(:roles, input) if input.is_a? String
    write_attribute(:roles, input.join(' ')) if input.is_a? Array
  end

  def roles
    (read_attribute(:roles) || []).split(' ')
  end

  def has_role?(target_roles)
    target_roles = [target_roles] if target_roles.is_a? String
    roles.any? { |role| target_roles.include? role  }
  end

  # email notifications
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  private

  # after_save
  def empty_password
    @password = nil
    @password_confirmation = nil
  end
end
