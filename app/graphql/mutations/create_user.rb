module Mutations
  class CreateUser < BaseMutation
    # ref. https://graphql-ruby.org/mutations/mutation_classes.html

    field :user, Types::UserType, null: false
    field :errors, [String], null: true

    argument :name, String, required: true

    def resolve(name:)
      user = User.new(name: name)

      if user.save
        {
          user: user,
          errors: [],
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
