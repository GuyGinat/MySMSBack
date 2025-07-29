class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!

    # GET /messages
    def index
        @messages = current_user.messages.order(created_at: :desc)
        render json: @messages
    end

    # POST /messages
    def create
        # Create message record
        @message = current_user.messages.new(message_params.merge(
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

    # Simple authentication method (temporary replacement for Devise)
    def authenticate_user!
        # For now, we'll use a simple session-based approach
        # In a real app, you'd use proper token authentication
        unless session[:user_id]
            render json: { error: 'Authentication required' }, status: :unauthorized
            return
        end
    end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end