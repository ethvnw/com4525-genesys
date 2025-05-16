class AddForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :feature_shares, :app_features
    add_foreign_key :feature_shares, :registrations

    add_foreign_key :question_clicks, :questions
    add_foreign_key :question_clicks, :registrations

    add_foreign_key :review_likes, :reviews
    add_foreign_key :review_likes, :registrations

    add_foreign_key :scannable_tickets, :plans

    add_foreign_key :ticket_links, :plans

    add_foreign_key :trip_memberships, :trips
    add_foreign_key :trip_memberships, :users
  end
end
