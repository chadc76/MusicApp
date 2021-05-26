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
require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
