class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # POST /webhooks/sms_status
  def sms_status
    # Log the webhook data for debugging
    Rails.logger.info "SMS Webhook received: #{params.inspect}"
    
    # Extract the message SID and status from Twilio's webhook
    message_sid = params[:MessageSid]
    message_status = params[:MessageStatus]
    
    if message_sid.present?
      # Find the message by Twilio SID
      message = Message.find_by(twilio_sid: message_sid)
      
      if message
        # Update the message status
        message.update(
          status: message_status,
          sent_at: Time.current
        )
        
        Rails.logger.info "Updated message #{message.id} status to: #{message_status}"
        render json: { success: true }, status: :ok
      else
        Rails.logger.warn "Message not found for SID: #{message_sid}"
        render json: { error: 'Message not found' }, status: :not_found
      end
    else
      Rails.logger.error "No MessageSid in webhook payload"
      render json: { error: 'MessageSid required' }, status: :bad_request
    end
  end
end 