require 'data_mapper'
require 'bcrypt'

class Player

	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	validates_confirmation_of :password, message: "Sorry, your passwords don't match"

	property :id, Serial
	property :name, String
	property :email, String, unique: true, message: "This email is already registered"
	property :games_played, Integer
	property :games_won, Integer
	property :score_difference, Integer
	property :points, Integer
	property :group_assign, String


	property :password_digest, Text

	def password=(password)
		@password = password
    	self.password_digest = BCrypt::Password.create(password)
  	end

end
