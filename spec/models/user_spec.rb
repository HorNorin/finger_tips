require 'rails_helper'

RSpec.describe User, type: :model do
  subject { @user }
  
  before(:each) do
    @user = FactoryGirl.build :user
    expect(@user).to be_valid
  end
  
  it "should has attributes" do
    expect(subject).to respond_to(:email)
    expect(subject).to respond_to(:username)
    expect(subject).to respond_to(:password_hash)
  end
  
  describe "activation_token" do
    it "should be generated when account not activated" do
      subject.save
      expect(subject.activation_token).not_to be_nil
    end
    
    it "should not be generated when account is activated" do
      subject.account_activated = true
      subject.save
      expect(subject.activation_token).to be_nil
    end
  end
  
  context "validation" do
    describe "username" do
      it "should not be empty" do
        subject.username = ""
        expect(subject).not_to be_valid
      end
      
      it "should be at least 5 characters long" do
        subject.username = "1234"
        expect(subject).not_to be_valid
      end
      
      it "should not be over 25 characters long" do
        subject.username = "a" * 30
        expect(subject).not_to be_valid
      end
      
      it "should be unique" do
        subject.username = "norin"
        other_user = FactoryGirl.create :user, username: "norin"
        expect(subject).not_to be_valid
        
        subject.username = "user1"
        expect(subject).to be_valid
      end
    end
    
    describe "email" do
      it "should not be empty" do
        subject.email = ""
        expect(subject).not_to be_valid
      end
      
      it "should be in correct format" do
        INCORRECT_EMAILS = %w(
          norin@example
          @norin@example
          @norin@example.com  
        )

        INCORRECT_EMAILS.each do |incorrect_email|
          subject.email = incorrect_email
          expect(subject).not_to be_valid
        end
        
        CORRECT_EMAIL = %w(
          norin@example.com
          norin.user@example.com
        )

        CORRECT_EMAIL.each do |correct_email|
          subject.email = correct_email
          expect(subject).to be_valid
        end
      end
    end
    
    describe "password" do
      it "should be at least 6 characters long" do
        subject.password = "12345"
        subject.password_confirmation = "12345"
        expect(subject).not_to be_valid
        
        subject.password = "123456"
        subject.password_confirmation = "123456"
        expect(subject).to be_valid
      end
      
      it "should not be empty when user first created" do
        subject.password = ""
        subject.save
        expect(subject).not_to be_valid
        expect(subject.password_hash).to be_nil
        
        subject.password = "secret"
        subject.password_confirmation = "secret"
        subject.save
        expect(subject.password_hash).not_to be_nil
        
        subject.password = ""
        subject.save
        expect(subject).to be_valid
      end
      
      it "should match password_confirmation" do
        subject.password = "secret"
        subject.password_confirmation = "secret111"
        expect(subject).not_to be_valid
        
        subject.password_confirmation = "secret"
        expect(subject).to be_valid
      end
    end
  end
  
  describe "password_hash" do
    it "should be encrypted when password is present" do
      expect(subject.password_hash).to be_nil
      
      subject.password = "secret"
      subject.save
      expect(subject.password_hash).not_to be_nil
      expect(subject.send(:encrypt, subject.password))
                    .to eq(subject.password_hash)
      
      subject.password = ""
      subject.save
      expect(subject.send(:encrypt, subject.password))
                    .not_to eq(subject.password_hash)
    end
  end
end
