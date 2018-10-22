# frozen_string_literal: true

WebApp::Container.boot(:logger) do
  init do
    register(:logger, Rails.logger)
  end
end
