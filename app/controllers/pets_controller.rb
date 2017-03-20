class PetsController < ApplicationController
  def index
    @pets = Pet.paginate(:page => params[:page])
  end
end
