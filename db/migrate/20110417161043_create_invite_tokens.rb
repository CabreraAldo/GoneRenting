class CreateInviteTokens < ActiveRecord::Migration
  def self.up
    create_table :invite_tokens do |t|
      t.string :token
      t.string :email
      t.integer :portal_id
      t.integer :user_id
      t.boolean :is_accepted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :invite_tokens
  end
end
