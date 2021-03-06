#encoding:utf-8
require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    expect(page).to have_title('About')
    click_link '联系我们'
    expect(page).to have_title('联系我们')
    #click_link 'Home'
    #click_link 'Sign up now!'
    #expect(page).to have_title('Sign up')
    click_link '主页'
    #这个挺厉害的，相当于模仿了用户的点击流程
    # click_link 'Find course now!'
    #expect(page).to # fill in
    #click_link 'sample app'
    #expect(page).to # fill in
  end


  subject { page }

  describe 'Home page' do
    before {visit root_path}
    it 'should have the h1 "Moyu"' do
      expect(page).to have_content('Moyu')
    end
    it {should have_title('Moyu')}
    it {should_not have_title('| Home')}

    describe "for signed-in users" do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryBot.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryBot.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe 'lesson counts' do
        let(:new_lesson) { FactoryBot.create(:course)}
        before do
          user.learn!(new_lesson)
          visit root_path
        end
        it { should have_link('1 lessons', href: lessons_user_path(user))}
      end

      describe 'recent homework' do
        let(:course) {FactoryBot.create(:course)}
        let(:ass) { FactoryBot.create(:assignment, course: course) }
        before do
          user.learn!(course)
          visit root_path
        end
        it "should render the course's assignments" do
          # course.assignments do |item|
          user.assignments_of_lessons.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.title)
          end
          # end
        end

      end

    end # for signed_in users

  end # home page

  describe 'Courses page' do
    before {visit courses_path}
    it {should have_content('Courses')}
    it {should have_title('Courses')}
  end

  describe 'About page' do
    before {visit about_path}
    it {should  have_content('About Us')}
    it {should have_title('About Us')}
  end

  describe 'Contact page' do
    before {visit contact_path}
    it {should have_content('联系我们')}
    it {should have_title('Moyu | 联系我们')}
  end

end
