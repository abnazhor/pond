class Follow < ApplicationRecord
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true
end
