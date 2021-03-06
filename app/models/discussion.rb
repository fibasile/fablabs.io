class Discussion < ActiveRecord::Base

  include Authority::Abilities
  self.authorizer_name = 'DiscussionAuthorizer'

  belongs_to :discussable, polymorphic: true
  belongs_to :creator, class_name: 'User'
  has_many :comments, as: :commentable

  validates_presence_of :creator, :title, :body, :discussable
  def to_s
    title
  end
end
