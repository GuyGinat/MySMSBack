class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  field :to, type: String
  field :from, type: String
  field :status, type: String
  field :sent_at, type: Time
  field :twilio_sid, type: String
  field :error_message, type: String
  
  belongs_to :user
end