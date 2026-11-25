require "test_helper"

class SignupWithoutConfirmationTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.reload_routes_unless_loaded
  end

  def sign_up(email)
    params = {
      user: { email:, password: "password123", password_confirmation: "password123", accept_terms: "1" },
      form_token: SignupFormTimer.issue
    }

    travel(5.seconds) { post user_registration_path, params: }
  end

  test "a new user lands in the dashboard without confirming the email" do
    sign_up("new@example.com")

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "the confirmation email is still sent" do
    assert_emails(1) { sign_up("new@example.com") }
  end

  test "an unconfirmed user can sign in again later" do
    sign_up("new@example.com")
    delete destroy_user_session_path

    post user_session_path, params: { user: { email: "new@example.com", password: "password123" } }
    get "/api/users/me"

    assert_response :success
  end
end
