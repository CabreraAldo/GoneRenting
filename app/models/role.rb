class Role < ActiveRecord::Base
    has_many :role_user
  has_many :users, :through=>:role_user
end
