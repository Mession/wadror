class Membership < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => [:beer_club_id], :message => "cant be in the same club twice"

  belongs_to :beer_club
  belongs_to :user
end
