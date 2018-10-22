require 'rails_helper'

describe MyCity::Transactions::CreateMessageTransaction do
  let(:transaction) { described_class.new(notify_moderators: notify_moderators, notify_reporter: notify_reporter) }
  subject { transaction.call(items) }
  let(:sender_id) { 11111 }
  let(:notify_reporter) { double(:notify_reporter).tap {|nr| allow(nr).to receive(:call) } }
  let(:notify_moderators) { double(:notify_moderators).tap {|nm| allow(nm).to receive(:call) } }

  before do
    ENV['BOT_TOKEN'] = 'telegrambottoken'
    api = double(:api)
    allow(api).to receive(:getFile).with(file_id: 'blabla.jpg') { {'result' => {'file_path' => 'filepath.jpg'}} }
    fake_bot = double(:fake_bot, api: api)
    WebApp::Container.stub('telegram.bot', fake_bot)
    stub_request(:get, "https://api.telegram.org/file/bottelegrambottoken/filepath.jpg").
      to_return(status: 200, body: "", headers: {})
  end

  context "happy path" do
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
          'file_id': 'blabla.jpg'
        }
      ]
    end

    it { is_expected.to be_success }

    it 'should create a new message' do
      expect { subject }.to change(Message, :count).by(1)
      message = subject.value_or(nil)
      message.reload
      expect(message).not_to be_nil
      expect(message.body).to eq("Pitfall\nPlease, fix it quick!")
      expect(message.latitude).to eq(101)
      expect(message.longitude).to eq(202)
      expect(message.sender_name).to eq("johndoe")
      expect(message.sender_id).to eq(1234567)
      expect(message.images.count).to eq(1)
    end
  end
end
