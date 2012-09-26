class Portal < ActiveRecord::Base
  acts_as_commentable 
  has_many :amenities, :dependent => :destroy
  has_many :avatars, :dependent => :destroy
  belongs_to :user
  has_many :bills
  has_many :tasks
  has_many :invite_tokens
  has_many :invitees, :through => :invite_tokens, :source => "user"
  

  validates_presence_of :name
  
  accepts_nested_attributes_for :amenities, :allow_destroy => true
  accepts_nested_attributes_for :avatars, :allow_destroy => true

  def owner
    return self.user
  end

  def is_owner?(user)
    self.user_id == user.id
  end

  def all_users
    self.owner.to_a + self.invitees
  end
end
