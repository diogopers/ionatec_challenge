class Pet < ApplicationRecord
  validates_presence_of :fullname, :gender, :breed

  filterrific(
    default_filter_params: { sorted_by: 'last_visit_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_castrated_only,
      :with_gender
    ]
  )

  belongs_to :user

  scope :search_query, lambda { |query|
    return nil  if query.blank?

    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
      terms.map { |term|
        "(LOWER(pets.fullname) LIKE ? OR LOWER(pets.breed) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }

  # Check if castrated
  scope :with_castrated_only, lambda { |flag|
      if 1 == flag
        where(castrated: true)
      end
  }

  # Check with gender
  scope :with_gender, lambda { |genders|
    where(gender: [*genders])
  }

  # Sort in columns
  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^last_visit_/
      order("pets.last_visit #{ direction }")
    when /^fullname/
      order("LOWER(pets.fullname) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Nome do Pet (a-z)', 'name_asc'],
      ['Última Visita (mais recente)', 'last_visit_desc']
    ]
  end

  def self.options_for_select
    [
      ['macho'],
      ['fêmea']
    ]
  end

  private

  def pet_params
   params.require(:pet).permit( :breed, :fullname, :castrated,
                                :last_visit, :genre)
  end
end
