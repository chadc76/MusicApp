# == Schema Information
#
# Table name: albums
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  year       :integer          not null
#  band_id    :integer          not null
#  live       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Album < ApplicationRecord
  validates :title, :year, :band_id, presence: true

  belongs_to :band,
    foreign_key: :band_id,
    primary_key: :id,
    class_name: :Band

  has_many :tracks,
    dependent: :destroy,
    primary_key: :id,
    foreign_key: :album_id,
    class_name: :Track

  has_many :taggings,
    as: :taggable,
    dependent: :destroy,
    primary_key: :id,
    foreign_key: :taggable_id,
    class_name: :Tagging

  has_many :tags,
    through: :taggings,
    source: :tag
end
