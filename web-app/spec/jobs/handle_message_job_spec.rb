require 'rails_helper'

describe HandleMessageJob do
  let(:job) { described_class.new }

  subject { job.perform(items_json) }
  let(:items_json) { items.to_json }
  let(:items) do
    [
      {
        'type' => 'text',
        'text' => 'Pitfall'
      },
      {
        'type': 'text',
        'text': 'Please, fix it quick!'
      },
      {
        'type': 'location',
        'latitude': '101',
        'longitude': '202'
      },
      {
        'type': 'meta',
        'sender_name': 'johndoe',
        'sender_id': 1234567
      },
      {
        'type': 'file',
        'file_id': 'AgADAgADO6kxG2SWYErYp7ZP3DmjCRPjtw4ABPd5BzxzGWNJFJcBAAEC'
      }
    ]
  end

  describe 'integration' do
    before do
      ENV['BOT_TOKEN'] = '637743157:examplebotsecret'
      stub_request(:post, "https://api.telegram.org/bot/getFile") \
        .with( body: {"file_id"=>"AgADAgADO6kxG2SWYErYp7ZP3DmjCRPjtw4ABPd5BzxzGWNJFJcBAAEC"}) \
        .to_return(File.open('spec/support/responses/get_file_response.txt'))
      stub_request(:get, "https://api.telegram.org/file/bot637743157:examplebotsecret/photos/file_4") \
        .to_return(File.open('spec/support/responses/file_response.txt'))
      stub_request(:post, "https://api.telegram.org/bot/sendMessage") \
        .to_return(status: 200, body: "{}")
    end

    it 'should create a message' do
      expect { subject }.to change(Message, :count).by(1)
    end

    it 'should create an image' do
      expect { subject }.to change(Image, :count).by(1)
    end
  end
end
