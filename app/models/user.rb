class User < ActiveRecord::Base

  has_many :posts, :dependent =>:destroy
  has_many :votes, :dependent =>:destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :password
  attr_accessible :id, :userName, :email, :password, :password_confirmation

  validates :userName, :presence => true,
            :length => {:maximum => 25}

  validates :email, :presence => true,
            :format => email_regex,
            :uniqueness => true

  validates :password, :presence => true,
            :length => {:within => 6..40},
            :confirmation => true

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(userName, submitted_password)
    user = find_by_userName(userName)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil  if user.nil?
    return user if user.salt == cookie_salt
  end

  private
  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end






































































































