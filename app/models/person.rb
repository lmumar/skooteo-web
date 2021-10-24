class Person < ApplicationRecord
  belongs_to :user, inverse_of: :person, touch: true, optional: true

  def full_name
    @full_name ||= PersonName.new(first: self.first_name, last: self.last_name).full
  end
end
