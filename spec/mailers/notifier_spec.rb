require "rails_helper"

RSpec.describe Notifier, type: :mailer do
  describe "instruction" do
    let(:user) { User.new username: "Norin", email: "norin@example.com" }
    let(:mail) { Notifier.instruction user }
    
    it "should render subject" do
      expect(mail.subject).to eq("Account activation")
    end
    
    it "should render receiver email" do
      expect(mail.to).to eq([user.email])
    end
    
    it "should renders the sender email" do
      expect(mail.from).to eql(["noreply@fingertips.com"])
    end
 
    it "should have username" do
      expect(mail.body.encoded).to match(user.username)
    end
 
    it "should have activation url" do
      expect(mail.body.encoded).to match(/http:\/\/localhost:3000\/account_activate*+/)
    end
  end
end
