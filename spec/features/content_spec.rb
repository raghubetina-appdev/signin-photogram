require "rails_helper"

describe "/new_photo_form" do
  it "automatically associates photo with signed in user", points: 2 do
    user = User.new
    user.email = "alice@example.com"
    user.password = "password"
    user.username = "alice"
    user.save

    login_as(user, :scope => :user)

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"

    visit "/new_photo_form"

    fill_in "Image URL", with: test_image
    fill_in "Caption", with: test_caption

    click_on "Add photo"

    added_photo = Photo.where({ :owner_id => user.id, :image => test_image }).at(0)

    expect(added_photo).to_not be_nil
  end
end

describe "/photos/[ID] — Add comment form" do
  it "automatically associates comment with signed in user", points: 2 do
    user = User.new
    user.email = "alice@example.com"
    user.password = "password"
    user.username = "alice"
    user.save

    login_as(user, :scope => :user)

    test_image = "https://some.test/image-#{Time.now.to_i}.jpg"
    test_caption = "Some test caption #{Time.now.to_i}"
    test_comment = "Some new comment #{Time.now.to_i}"

    photo = Photo.new
    photo.image = test_image
    photo.caption = test_caption
    photo.owner_id = user.id
    photo.save

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    click_on "Add comment"

    added_comment = Comment.where({ :author_id => user.id, :photo_id => photo.id, :body => test_comment }).at(0)

    expect(added_comment).to_not be_nil
  end
end
