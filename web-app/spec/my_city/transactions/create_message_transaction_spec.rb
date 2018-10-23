require 'rails_helper'

describe MyCity::Transactions::CreateMessageTransaction do
  let(:transaction) { described_class.new }
  subject { transaction.call(items) }

  let(:api) { double(:api) }

  before do
    ENV['BOT_TOKEN'] = 'telegrambottoken'
    allow(api).to receive(:getFile).with(file_id: 'blabla.jpg') { {'result' => {'file_path' => 'filepath.jpg'}} }
    allow(api).to receive(:send_message)
    WebApp::Container.stub('telegram.bot', double(:fake_bot, api: api))
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

    describe 'telegram notifications' do
      it 'should notify moderators' do
        telegram_users = Fabricate.times(2, :admin_user)
        allow(api).to receive(:send_message).exactly(3).times

        subject

        telegram_users.each do |user|
          expect(api).to have_received(:send_message).with(chat_id: "@#{user.telegram_login}", text: anything)
        end
      end

      it 'should notify reporter' do
        allow(api).to receive(:send_message).once
        message = subject.value_or(nil)
        expect(api).to have_received(:send_message).with(chat_id: message.sender_id, text: anything)
      end
    end
  end
end
