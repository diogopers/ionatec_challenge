class PetsController < ApplicationController

  def index
    @filterrific = initialize_filterrific(
      Pet,
      params[:filterrific]
    ) or return
    @pets = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
