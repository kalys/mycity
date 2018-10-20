# frozen_string_literal: true

class AddCategoryToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :category, foreign_key: true
  end
end
