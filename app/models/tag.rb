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
end
