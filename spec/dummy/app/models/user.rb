require "email_validator"

class User < ActiveRecord::Base
  translates :title
  
  has_many :roles
  
  validates :name, :length => {:in => 2..255}
  validates :name, :uniqueness => true, :presence => true
  validates :name, :format => {:with => /\A[A-z]+\Z/}
  validates :email, :email => true
end
