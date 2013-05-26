class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :first_name, :last_name, :login, :password, :password_confirmation, :remember_me,
                  :provider, :uid, :profile_type, :avatar, :crop_x, :crop_y, :crop_w, :crop_h
                  
  attr_accessor :meta_login, :crop_x, :crop_y, :crop_w, :crop_h

  has_attached_file :avatar,
    :url => "/assets/:class/:attachment/:id/:style/:hash.:extension",
    :path => ":rails_root/app/assets/images/:class/:attachment/:id/:style/:hash.:extension",
    :hash_secret => "udhg72gu2f9273ggf2hf823f2",
    :styles => { 
      :pre_crop   => ["500x500>", :png],
      :large   => ["400x400#", :png],
      :medium  => ["200x200#", :png],
      :small   => ["100x100#", :png],
      :tiny    => ["50x50#", :png],
    },
    :processors => [:cropper],
    :default_url => "/assets/missing_avatar.png"

  validates :first_name, :length => { :maximum => 50 }, :presence => true
  validates :last_name, :length => { :maximum => 50 }, :presence => true
  validates :login, :length => { :maximum => 50 }, :presence => true, :uniqueness => true
  validates :profile_type, :inclusion=> { :in => %w(basic medium premium) }, :presence => true
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/pjpeg', 'image/x-png'] #last two for IE 6-8
  validates_attachment_size :avatar, :less_than => 1.megabyte


  def full_name
    [first_name.capitalize, last_name.capitalize].join ' '
  end

  def max_channels
    case profile_type
    when 'basic'
      10
    when 'medium'
      20
    when 'premium'
      100
    end
  end

  #############################
  ###     DEVISE  START     ###
  #############################

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

  #############################
  ###     DEVISE  END       ###
  #############################


  #############################
  ###   PAPERCLIP  START    ###
  #############################

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  def reprocess_avatar
    avatar.reprocess!
  end

  # to allow recrop previously uploaded image
  # file operations are necessary due to after recropping one style, filenames for all other
  # style are being recalculated
  def reprocess_pre_crop
    old_files = {}
    avatar.styles.keys.each do |style|
      old_files[style] = avatar.path(style)
    end
    avatar.reprocess!(:pre_crop)
    avatar.styles.keys.each do |style|
      next if style == :pre_crop
      FileUtils.move(old_files[style], avatar.path(style))
    end
  end

  #############################
  ###    PAPERCLIP  END     ###
  #############################

end
