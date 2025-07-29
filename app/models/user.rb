class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include DeviseTokenAuth::Concerns::User  # Temporarily comment out
  
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Essential Devise fields
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time

  # Devise Token Auth fields (temporarily commented out)
  # field :provider, type: String
  # field :uid, type: String
  # field :tokens, type: Hash, default: {}

  # Relationships
  has_many :messages, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true

  # Indexes
  index({ email: 1 }, { unique: true, background: true })
  # index({ uid: 1, provider: 1 }, { unique: true, background: true })  # Temporarily comment out
  index({ reset_password_token: 1 }, { background: true })
end
