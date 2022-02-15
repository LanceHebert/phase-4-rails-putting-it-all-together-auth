class UsersController < ApplicationController
    before_action :authorize
    skip_before_action :authorize, only: [:create]


    def create
        user = User.create(user_params)
        session[:user_id] = user.id
        
        if user.valid?       
            render json: user, status: :created
        else                       
            render json: { errors: user.errors.full_messages},status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user &.authenticate(params[:password])
            render json: user, status: :created
        else
            render json: {error: "Unauthorized"},status: 401
        end
    end

private

    def user_params
        params.permit(:username,:password,:image_url,:bio)
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
      end

end
