require "rss"

class RssController < ApplicationController
  def rss_index
    render :plain => maker("2.0")
  end

  def rss_show
    render :plain => maker("2.0", params[:id])
  end

  def atom_index
    render :plain => maker("atom")
  end

  def atom_show
    render :plain => maker("atom", params[:id])
  end

  def maker(xml, category=nil)
    xml_link = "http://my-city.com/" + xml

    messages = Message.all.where(status: :actual)
    messages = Message.all.where(status: :actual).where(category_id: category) unless category.nil?

    rss = RSS::Maker.make(xml) do |maker|
      maker.channel.author = "my-city"
      maker.channel.updated = Time.now.to_s
      xml == "2.0" ? maker.channel.description = xml_link : maker.channel.about = xml_link
      maker.channel.link = xml_link
      maker.channel.title = "My City Feed"

      messages.each do |message|
        maker.items.new_item do |item|
          item.link = url_for(message)
          item.title = message.body.truncate(50)
          item.updated = message.created_at.to_s
        end
      end
    end

    return rss
  end
end

