class TimelineController < ApplicationController
    def index
        @posts = Post.includes(:user, :library).order(created_at: :desc)
        @post = Post.new
    end
end
