class User < ApplicationRecord
	validates :password, length: { minimum: 6, allow_nil: true }
	validates :name, :password_digest, :session_token, presence: true 

	has_many :subs 
	has_many :posts 

	attr_reader :password 

	after_initialize :ensure_session_token!

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end 

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end 

	def reset_session_token!
		self.session_token = SecureRandom.urlsafe_base64(16)
		self.save 
		self.session_token
	end

	def ensure_session_token!
		self.session_token ||= SecureRandom.urlsafe_base64(16)
	end

	def self.find_by_credentials(username, password)
		user = User.find_by_username(username)
		user && user.is_password?(password) ? user : nil
	end 
end
