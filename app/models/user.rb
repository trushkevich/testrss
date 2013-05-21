class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :first_name, :last_name, :login, :password, :password_confirmation, :remember_me,
                  :provider, :uid
                  
  attr_accessor :meta_login

  validates :first_name, :length => { :maximum => 50 }, :presence => true
  validates :last_name, :length => { :maximum => 50 }, :presence => true
  validates :login, :length => { :maximum => 50 }, :presence => true, :uniqueness => true

  def full_name
    [first_name.capitalize, last_name.capitalize].join ' '
  end

  # Override Devise's method to let oauth users register without requiring email
  # (for example Twitter won't share user's email)
  def email_required?
    super && provider.blank?
  end

  # Override Devise's method to let oauth users to register without requiring password
  def password_required?
    super && provider.blank?
  end

  # tell Devise to authenticate by login or email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup

    if meta_login = conditions.delete(:meta_login)
      where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => meta_login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # find a user for google oauth
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.new(
        first_name: data['first_name'],
        last_name: data['last_name'],
        login: access_token.uid,
        email: data['email'],
        provider: 'google_oauth2',
        uid: access_token.uid,
      )
      user.confirm! 
      user.save! 
    end
    user
  end

  # find a user for twitter oauth
  def self.find_for_twitter(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(provider: access_token.provider, uid: access_token.uid).first

    unless user
      name_parts = data['name'].split(' ')

      user = User.new(
        first_name: name_parts.first,
        last_name: name_parts.length > 1 ? name_parts.last : 'Surname',
        login: data['nickname'],
        provider: 'twitter',
        uid: access_token.uid,
      )
      user.confirm! 
      user.save! 
    end
    user
  end

  # Override Devise's method to let oauth users edit their profile
  # without a need to provide a current password
  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if valid_password?(current_password) || self.password.blank?
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

end
