class CreateActivationqueues < ActiveRecord::Migration
  def change
    create_table :activationqueues do |t|

      t.timestamps
    end
  end
end
