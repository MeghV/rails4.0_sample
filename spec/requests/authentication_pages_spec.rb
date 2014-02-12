require 'spec_helper'

describe "Authentication" do
  
  subject { page }

  describe "signin" do
  	before { visit signin_path }

  	let(:signin) { "Sign in" }
    let(:user) { FactoryGirl.create(:user) }

  	describe "with invalid information" do
  		before { click_button signin }

  		it { should have_title('Sign in') }
  		it { should have_selector('div.alert.alert-danger')}
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before do
  			fill_in "Email", 	with: user.email.upcase
  			fill_in "Password", with: user.password
  			click_button signin
  		end

  		it { should have_title(user.name) }
  		it { should have_link('Profile',	 href: user_path(user)) }
  		it { should have_link('Sign out',	 href: signout_path) }
  		it { should_not have_link('Sign in', href: signin_path)}
  	end

    describe "after visiting another page" do
      before { click_link "Home" }
      it { should_not have_selector('div.alert.alert-danger') }
    end

    describe "after saving the user" do
      before { click_button signin }
      let(:user) { User.find_by(email: "meghhv@gmail.com") }

      it { should have_link('Sign out') }
      it { should have_title(user.name) }
      it { should have_selector('div.alert.alert-success', text: 'Welcome') }
    end

    describe "followed by signout" do
      before { click_link "Sign out" }
      it { should have_link('Sign in') }
    end
  end
end
