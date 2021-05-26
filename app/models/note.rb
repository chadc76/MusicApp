# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  user_id    :integer          not null
#  track_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Note < ApplicationRecord
  validates :user_id, :track_id, :content, presence: true

  belongs_to :track,
    foreign_key: :track_id,
    primary_key: :id,
    class_name: :Track

  belongs_to :author,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :User
end
