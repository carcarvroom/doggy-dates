class LikesController < ApplicationController
    def create
        liked_dog = params[:dog]
        @like = Like.new(user_id: current_user.id, dog_id: liked_dog)
        if @like.save
            owner_id = Dog.find_by(id: liked_dog).user_id
            if Match.where(matcher_id: owner_id, matchee_id: current_user.id, status: "pending").exists?
                match = Match.find_by(matcher_id: dog.user.id, matchee_id: current_user.id)
                match.update(status: "approved")
                match.chats.create(timestamp: Time.now)
            else
                # byebug
                Match.create(matcher_id: current_user.id, matchee_id: owner_id)
                redirect_to dogs_path
            end
        end
    end
end
# match = Match.create(matcher_id: 23, matchee_id: 27, status: "pending")