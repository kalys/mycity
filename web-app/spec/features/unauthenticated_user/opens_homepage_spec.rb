require 'rails_helper'

feature 'homepage' do
  scenario 'happy path' do
    create_list :message, 5, status: :actual
    visit '/'
    expect(all('.messages tbody tr')).not_to be_empty
  end
end
