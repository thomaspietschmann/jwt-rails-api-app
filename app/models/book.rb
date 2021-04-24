class Book < ApplicationRecord
  validates_presence_of :name, on: :create, message: 'A book needs a name'
  validates_presence_of :pages, on: :create, message: 'A book needs pages'
  validates_uniqueness_of :name, on: :create, message: 'A book title must be unique'
end
