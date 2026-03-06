ActiveRecord::Base.transaction do
	Oaken.seed :users, :cubes, :drafts
end
