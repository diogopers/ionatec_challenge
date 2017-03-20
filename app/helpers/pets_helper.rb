module PetsHelper
  def display_gender(pet)
    if pet.gender == "macho"
      raw("<i class='fa fa-mars' aria-hidden='true'></i>")
    else
      raw("<i class='fa fa-venus' aria-hidden='true'></i>")
    end
  end

  def display_age(pet)
    Date.today.year - pet.birth_date.year
  end

  def display_castrated(pet)
    status = pet.castrated
    status ? "Sim" : "Não"


  end
end
