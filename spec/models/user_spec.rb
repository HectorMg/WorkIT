require 'rails_helper'

RSpec.describe User, type: :model do

  let :user do
    User.new( name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar" )
  end

  it "should be valid" do
    expect(user).to be_valid
  end

  it "should have a name" do
    user.name = "    "
    expect(user).not_to be_valid
  end

  it "should have an email address" do
    user.email = "   "
    expect(user).not_to be_valid
  end

  it "name should not be too long" do
    user.name = "a" * 51
    expect(user).not_to be_valid
  end

  it "email should not be too long" do
    user.name = "a" * 244 + "@example.com"
    expect(user).not_to be_valid
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[ user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn ]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[ user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com ]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it "email address should be unique" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it "email address should be saved in lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(mixed_case_email.downcase == user.reload.email).to eql(true)
  end

  it "password should be present (nonblank)" do
    user.password = user.password_confirmation = " " * 6
    expect(user).not_to be_valid
  end

  it "password should have a minimum length" do
    user.password = user.password_confirmation = "a" * 5
    expect(user).not_to be_valid
  end
end
