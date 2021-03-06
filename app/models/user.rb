class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :pass_reset_token

  belongs_to :cohort,            optional: true
  has_many   :sent_messages,     foreign_key: :from_user_id, class_name: "Message", dependent: :destroy
  has_many   :received_messages, foreign_key: :to_user_id,   class_name: "Message", dependent: :destroy
  has_many   :posts,             foreign_key: :author_id
  has_many   :comments,          foreign_key: :author_id, dependent: :destroy
  has_many   :goals,             class_name: "UserGoal",  dependent: :destroy

  default_scope           -> { order(:name) }
  scope :only_deleted,    -> { where.not(deleted_at: nil) }
  scope :without_deleted, -> { where(deleted_at: nil) }

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
  # Password must have at least one lower alpha, one upper alpha, and one number
  VALID_PASSWORD_REGEX = /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])./
	validates :password, presence: true, length: { within: 6..40 },
                       format: { with: VALID_PASSWORD_REGEX,
                                 message: "must have at least one lowercase letter,
                                           one uppercase letter, and one number" },
                       allow_nil: true

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

  # Activates a user
  def activate
    update_columns(activated:    true,
                   activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.pass_reset_token = User.new_token
    update_columns(reset_digest:  User.digest(pass_reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Returns true if reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Removes user from cohort
  def unassign_cohort
    update_attribute(:cohort_id, nil)
  end

  # Marks a user as deleted without deleting the record
  def soft_delete
    update_columns(deleted_at:      Time.zone.now,
                   cohort_id:       nil,
                   password_digest: nil,
                   remember_digest: nil,
                   activated:       false)
  end

  # Unmarks user as soft deleted and restarts activation process
  def reactivate
    self.activation_token = User.new_token
    update_columns(deleted_at: nil,
                   activation_digest: User.digest(activation_token))
    send_activation_email
  end

  # Returns a count of unopened messages
  def new_message_count
    count  = Message.where(to_user_id: self.id).where(opened: false).count
    count += OutsideMessage.where(opened: false).count if self.admin?
    count
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

  # Nullifies (temporary) password_digest for security
  def delete_temp_password_digest
    update_attribute(:password_digest, nil)
  end
end
