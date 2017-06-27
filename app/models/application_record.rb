class ApplicationRecord < ActiveRecord::Base
  attr_protected :abstract_class
  self.abstract_class = true
end
