class User < ApplicationRecord
  has_many :posts
  has_many :comments, as: :commentable
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # Virtual attribute for authenticating by either username or email
   # This is in addition to a real persisted field like 'username'
   attr_accessor :login

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_hash).first
      end
    end

  # USERNAME AND EMAIL VALIDATIONS
  # We need to be very careful with username validation, because there might be conflict between username and email.
  # For example, given these users:
  # id	 username	         email
  # 1	   harrypotter	     harry@gmail.com
  # 2	   harry@gmail.com   real_email@gmail.com
  #
  # The problem is at user #2, he is using #1's email as his username.

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  # Only allow letter, number, underscore and punctuation.
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def karma_up
    karma.increment.where(@post.user_id)
  end

  def karma_down
  end

end
