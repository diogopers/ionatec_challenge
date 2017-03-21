class Pet < ApplicationRecord
  validates_presence_of :fullname, :gender, :breed

  alias_attribute :nome_do_pet, :fullname
  alias_attribute :última_visita, :fullname



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
    # Searches the students table on the 'first_name' and 'last_name' columns.
    # Matches using LIKE, automatically appends '%' to each term.
    # LIKE is case INsensitive with MySQL, however it is case
    # sensitive with PostGreSQL. To make it work in both worlds,
    # we downcase everything.
    return nil  if query.blank?

    # condition query, parse into individual keywords
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

  scope :with_user_id, lambda { |user_ids|
    where(user_id: [*user_ids])
  }

  scope :with_gender, lambda { |genders|
    where(gender: [*genders])
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^last_visit_/
      # Simple sort on the created_at column.
      # Make sure to include the table name to avoid ambiguous column names.
      # Joining on other tables is quite common in Filterrific, and almost
      # every ActiveRecord table has a 'created_at' column.
      order("pets.last_visit #{ direction }")
    when /^fullname/
      order("LOWER(pets.fullname) #{ direction }")
    # when /^country_name_/
    #   # This sorts by a student's country name, so we need to include
    #   # the country. We can't use JOIN since not all students might have
    #   # a country.
    #   order("LOWER(users.name) #{ direction }").includes(:user)
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['Nome do Pet (a-z)', 'name_asc'],
      ['Última Visita (mais recente)', 'last_visit_desc'],
      ['Data de Nascimento (mais recente)', 'birth_date_desc'],
      ['Data de cadastro (mais recente)', 'created_at_asc'],
      ['Nome do dono (a-z)', 'user_name_asc']
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
