# frozen_string_literal: true

Fabricator(:message) do
end

Fabricator(:full_actual_message, from: :message) do
  category
  status :actual
  body { 'Pitfalls' }
  images(count: 3)
end
