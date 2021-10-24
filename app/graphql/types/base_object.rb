# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    protected
      def load_association(assoc)
        AssociationLoader.for(object.class, assoc).load(object)
      end
  end
end
