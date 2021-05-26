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
require "test_helper"

class TrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
