require 'twilio-ruby'

class TwilioService
  def initialize
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']

    if account_sid.blank? || auth_token.blank?
      raise "Twilio credentials not found. Please set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN environment variables."
    end

    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def send_sms(to:, from:, body:)
    begin
      # Build the status callback URL
      status_callback_url = "#{ENV['APP_URL'] || 'http://localhost:3000'}/webhooks/sms_status"

      message = @client.messages.create(
        to: to,
        from: from,
        body: body,
        status_callback: status_callback_url
      )

      {
        success: true,
        sid: message.sid,
        status: message.status,
        error: nil
      }
    rescue Twilio::REST::RestError => e
      {
        success: false,
        sid: nil,
        status: 'failed',
        error: e.message
      }
    rescue => e
      {
        success: false,
        sid: nil,
        status: 'failed',
        error: e.message
      }
    end
  end

  def get_message_status(sid)
    begin
      message = @client.messages(sid).fetch
      message.status
    rescue => e
      'unknown'
    end
  end
end