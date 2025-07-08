class Person < ApplicationRecord
  belongs_to :account, class_name: "Account"
end
