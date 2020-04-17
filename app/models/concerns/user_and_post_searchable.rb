module UserAndPostSearchable
  extend ActiveSupport::Concern
  extend self

  INDEX_NAME = 'users_and_posts'

  def create_index!(options = {})
    client = User.__elasticsearch__.client

    if options.delete(:force)
      begin
        client.indices.delete index: INDEX_NAME
      rescue StandardError
        nil
      end
    end

    mapping_properties = {
      relation_type: {
        type: 'join',
        relations: { User::JOIN_TYPE => Post::JOIN_TYPE }
      }
    }
    merged_properties = mapping_properties
      .merge(User.mappings.to_hash[:properties])
      .merge(Post.mappings.to_hash[:properties])

    settings = User.settings.to_hash.merge(Post.settings.to_hash)
    client.indices.create({ index: INDEX_NAME,
                            body: {
      settings: settings.to_hash,
      mappings: { properties: merged_properties }
    } }.merge(options))
  end
end
