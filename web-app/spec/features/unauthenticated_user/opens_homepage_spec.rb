# frozen_string_literal: true

require 'rails_helper'

feature 'homepage' do
  scenario 'happy path' do
    Fabricate.times(5, :message, status: :actual)
    visit '/'
    expect(all('.messages .item')).not_to be_empty
  end
end
