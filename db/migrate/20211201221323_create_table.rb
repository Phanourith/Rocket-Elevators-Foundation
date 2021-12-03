class CreateTable < ActiveRecord::Migration[5.2]
  def change
    create_table :interventions do |t|
      t.bigint :author
      t.bigint :customer_id
      t.bigint :building_id
      t.bigint :battery_id
      t.bigint :column_id
      t.bigint :elevator_id
      t.bigint :employee_id
      t.date :start_intervention
      t.date :end_intervention
      t.string :result
      t.string :report
      t.string :status
      
    end
  end
end
