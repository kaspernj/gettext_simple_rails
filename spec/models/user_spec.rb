require "spec_helper"

describe User do
  let!(:user){ create :user }
  let(:role){ create :role, user: user }

  it "#destroy" do
    role
    user.destroy
    user.errors.any?.should eq true
    user.errors[:base].should eq ["Cannot delete record because dependent roles exist"]
  end
end
