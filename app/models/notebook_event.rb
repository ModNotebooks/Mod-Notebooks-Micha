# == Schema Information
#
# Table name: notebook_events
#
#  id          :integer          not null, primary key
#  notebook_id :integer
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  scope       :string(255)
#

class NotebookEvent < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :notebook

  validates_presence_of :notebook_id
  validates_inclusion_of :state, in: Notebook::STATES

  before_validation :default_scope

  private
    def default_scope
      self.scope ||= :default
    end
end
