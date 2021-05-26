# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  taggable_type :string           not null
#  taggable_id   :bigint           not null
#  tag_id        :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Tagging < ApplicationRecord
  TYPES = [
    'Band',
    'Album',
    'Track'
  ]
  validates :tag_id, :taggable_type, :taggable_id, presence: true
  validates :taggable_type, inclusion: TYPES
  validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type],
  message: "already used" }

belongs_to :taggable, 
  polymorphic: true,
  primary_key: :id,
  foreign_key: :taggable_id,
  class_name: :taggable_type.to_sym

has_one :tag,
  primary_key: :tag_id,
  foreign_key: :id,
  class_name: :Tag
end
