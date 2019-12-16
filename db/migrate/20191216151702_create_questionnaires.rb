# frozen_string_literal: true

class CreateQuestionnaires < ActiveRecord::Migration[6.0]
  def change
    create_table :questionnaires do |t|
      t.string :reference
      t.json :body
    end

    add_index :questionnaires, :reference
  end
end
