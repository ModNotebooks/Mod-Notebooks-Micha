class NotebookEvent < ActiveRecord::Base
  belongs_to :notebook
  attr_accessible :state

  validates_presence_of :notebook_id
  validates_inclusion_of :state, in: Notebook::STATES

  class << self
    def with_last_state(state)
      order("id desc").group("notebook_id").having(state: state)
    end
  end
end
