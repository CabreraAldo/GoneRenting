class InviteToken < ActiveRecord::Base

  belongs_to :user
	belongs_to :portal

  validates_presence_of :email
  
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

	def before_create()
		self.token = UUIDTools::UUID.timestamp_create().to_s		
	end



	
end
