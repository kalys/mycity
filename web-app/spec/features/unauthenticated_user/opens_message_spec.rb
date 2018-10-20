# frozen_string_literal: true

require 'rails_helper'

feature 'message details' do
  context 'when status is for_moderation' do
    let!(:message) { Fabricate(:message, status: :for_moderation) }
    scenario 'happy path' do
      visit message_path(message)
      expect(page).to have_content('Message is waiting moderation approval')
    end
  end

  context 'when status is actual' do
    let!(:message) { Fabricate(:full_actual_message) }
    scenario 'happy path' do
      visit message_path(message)
      expect(page).to have_content(message.body)
      expect(all('.fotorama img').count).to eq(message.images.count)
    end
  end
end
