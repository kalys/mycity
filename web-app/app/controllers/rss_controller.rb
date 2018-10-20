# frozen_string_literal: true

require 'rss'

class RssController < ApplicationController
  def rss_index
    render plain: maker
  end

  def maker(_category = nil)
    xml_link = feed_url
    xml = '2.0'

    messages = Message.all.where(status: :actual)

    rss = RSS::Maker.make(xml) do |maker|
      maker.channel.author = 'my-city'
      maker.channel.updated = Time.now.to_s
      xml == '2.0' ? maker.channel.description = xml_link : maker.channel.about = xml_link
      maker.channel.link = xml_link
      maker.channel.title = 'My City Feed'

      messages.each do |message|
        maker.items.new_item do |item|
          item.link = url_for(message)
          item.title = message.body.truncate(50)
          item.updated = message.created_at.to_s
        end
      end
    end

    rss
  end
end
