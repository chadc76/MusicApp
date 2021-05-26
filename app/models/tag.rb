# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  tag        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  validates :tag, presence: true, uniqueness: true

  has_many :taggings,
    dependent: :destroy,
    primary_key: :id,
    foreign_key: :tag_id,
    class_name: :Tagging
  
  has_many :tagged_bands,
    through: :taggings,
    source: :taggable,
    source_type: 'Band'

  has_many :tagged_albums,
    through: :taggings,
    source: :taggable,
    source_type: 'Album'

  has_many :tagged_tracks,
    through: :taggings,
    source: :taggable,
    source_type: 'Track'

  def tagged_items
    {
      bands: tagged_bands,
      albums: tagged_albums,
      tracks: tagged_tracks
    }
  end
end
