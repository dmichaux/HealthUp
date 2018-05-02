class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token

	before_save       :downcase_email
  before_create     :create_activation_digest
  before_validation :create_temp_password, on: :create
  after_create      :delete_temp_password_digest

	validates :name,  presence: true, length: { within: 3..25 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { within: 5..254 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false}

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a new random token
  def self.new_token
  	SecureRandom.urlsafe_base64
  end

  # Remembers user in the database for use in persistent cookies
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
  	update_attribute(:remember_digest, nil)
  end

  # Returns true if given token matches digest
  def authenticated?(attribute, token)
  	digest = send("#{attribute}_digest")
  	return false if digest.nil?
  	BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Activates a user
  def activate
    update_attribute(:activated, true)
  end

	private

	def downcase_email
		self.email.downcase!
	end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def create_temp_password
    self.password = self.password_confirmation = User.new_token
  end

  # Nullifies (temporary) password_digest for security reasons
  def delete_temp_password_digest
    update_attribute(:password_digest, nil)
  end
end
