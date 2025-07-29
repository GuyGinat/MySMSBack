class AuthController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    # POST /auth/register
    def register
        user = User.new(user_params)
        # user.uid = user_params[:email]  # Temporarily comment out
        # user.provider = 'email'         # Temporarily comment out
        
        if user.save
            # Set session for the new user
            session[:user_id] = user.id
            
            render json: {
                user: {
                    id: user.id,
                    email: user.email
                },
                message: 'User registered successfully'
            }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    # POST /auth/login
    def login
        user = User.find_by(email: params[:email])
        
        if user && user.valid_password?(params[:password])
            # Set session for the logged in user
            session[:user_id] = user.id
            
            render json: {
                user: {
                    id: user.id,
                    email: user.email
                },
                message: 'Login successful'
            }
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end
    
    private
    
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end