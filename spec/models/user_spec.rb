require File.dirname(__FILE__) + '/../spec_helper'
describe User, "firstly..." do

  before do
    Theme.make
  end

  #regressional test
  it "should automatically set theme_id when a new user is created" do
    @user = User.make
    @user.theme.name.should eql("Default Theme")
  end

end

describe User, "with users" do
  fixtures :themes, :users, :ranks, :groups

  before do
    setup_user_base
    @administrator = User.find_by_login("administrator")
    @registered_user = User.find_by_login("registered_user")

    @banned_noob = User.ensure("Banned Noob")
    @moderator = User.ensure("moderator")

    @god = Rank.make(:god)
  end

  it "should authenticate the user" do
    @administrator.authenticated?("godly").should be_true
    @administrator.authenticated?("mortal").should be_false
  end

  it "should remember a user" do
    @administrator.remember_token?.should be_true
  end

  it "should be able to remember a user" do
    @moderator.remember_token?.should be_nil
    @moderator.remember_me
    @moderator.remember_token?.should be_true
  end

  it "should be able to tell if the user is banned" do
    @administrator.banned?.should be_false
    @banned_noob.banned?.should be_true
  end

  it "should be able to authenticate a user" do
    User.authenticate("registered_user", "password").should_not be_nil
    User.authenticate("registered_user", "wrong password").should be_nil
    User.authenticate("non-existant", "password").should be_nil
  end

  it "should be able to find a rank for a user" do
    @administrator.rank.should eql("God")
  end

  it "should see that the user was recently online" do
    @registered_user.online?.should be_true
  end

end

describe User, "valid login names" do
  before do
    @user = User.make_unsaved
  end
  
  it "should not be able to contain commas" do
    @user.login = "radar,"
    @user.save.should be_false
    @user.login = "radar"
    @user.save.should be_true
  end
    
end