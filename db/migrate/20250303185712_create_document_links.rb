class CreateDocumentLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :document_links do |t|
      t.belongs_to :plan
      t.string :document_link, null: false

      t.timestamps
    end
  end
end
