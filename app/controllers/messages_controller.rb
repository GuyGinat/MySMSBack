class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    # GET /messages
    def index
        # Temporarily show all messages for debugging
        @messages = Message.all.order(created_at: :desc)
        render json: @messages
    end

    # POST /messages
    def create
        session_id = session.id.to_s
        
        # Create message record
        @message = Message.new(message_params.merge(
            session_id: session_id,
            from: ENV['TWILIO_PHONE_NUMBER'],
            status: 'pending'
        ))
        
        if @message.save
            # Send SMS via Twilio
            twilio_service = TwilioService.new
            result = twilio_service.send_sms(
                to: @message.to,
                from: @message.from,
                body: @message.content
            )
            
            # Update message with Twilio response
            if result[:success]
                @message.update(
                    twilio_sid: result[:sid],
                    status: result[:status],
                    sent_at: Time.current
                )
                render json: @message, status: :created
            else
                @message.update(
                    status: 'failed',
                    error_message: result[:error]
                )
                render json: { error: result[:error] }, status: :unprocessable_entity
            end
        else
            render json: @message.errors, status: :unprocessable_entity
        end
    end

    private

    def message_params
        params.require(:message).permit(:content, :to)
    end
end