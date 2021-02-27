class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  extend FriendlyId
  friendly_id :username, use: :slugged
    
  def should_generate_new_friendly_id?
    new_record? || slug.nil? || slug.blank?
  end

  has_rich_text :notes
  after_create :assign_default_role

  validates :username,  presence: true, uniqueness: { :case_sensitive => false }, length: { in: 5..30 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }



  def assign_default_role
    self.add_role(:member) if self.roles.blank?
  end

end
