class PetsController < ApplicationController

  def index
    @filterrific = initialize_filterrific(
      Pet,
      params[:filterrific],
      select_options: {
              sorted_by: Pet.options_for_sorted_by,
              with_gender: Pet.options_for_select
            }
    ) or return
    @pets = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
