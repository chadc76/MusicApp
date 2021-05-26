# == Schema Information
#
# Table name: tracks
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  ord         :integer          not null
#  album_id    :integer          not null
#  bonus_track :boolean          default(FALSE)
#  lyrics      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Track < ApplicationRecord
  validates :title, :ord, :album_id, presence: true
  validates :ord, uniqueness: { scope: :album_id }
  validate :ord_greater_than_zero
  
  belongs_to :album,
    foreign_key: :album_id,
    primary_key: :id,
    class_name: :Album

  has_one :band,
    through: :album,
    source: :band

  has_many :notes,
    dependent: :destroy,
    foreign_key: :track_id,
    primary_key: :id,
    class_name: :Note

  private

  def ord_greater_than_zero
    return if self.ord > 0

    errors.add(:ord, "must cannot be less than 1")
  end
end
