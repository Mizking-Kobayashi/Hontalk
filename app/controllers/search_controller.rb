class SearchController < ApplicationController
    def show
        @book_id = params[:id]
    end
end
