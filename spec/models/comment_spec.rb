require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { @comment }
  before(:each) { @comment = FactoryGirl.build :comment }
  
  it "should respond to" do
    expect(subject).to respond_to(:body)
    
    subject.save
    expect(subject).to respond_to(:user)
  end
  
  it "should not be valid without body" do
    expect(subject).to be_valid
    
    subject.body = ""
    expect(subject).not_to be_valid
  end
  
  it "should belong to a user" do
    expect(subject).to be_valid
    
    subject.user = nil
    expect(subject).not_to be_valid
  end
end
