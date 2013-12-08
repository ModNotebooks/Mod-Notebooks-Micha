# == Schema Information
#
# Table name: notebook_events
#
#  id          :integer          not null, primary key
#  notebook_id :integer
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class NotebookEvent < ActiveRecord::Base
  belongs_to :notebook

  validates_presence_of :notebook_id
  validates_inclusion_of :state, in: Notebook::STATES

  class << self
    def with_last_state(state)
      order("id desc").group("notebook_id").having(state: state)
    end
  end
end
