require "test_helper"

class SignupBotProtectionTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.reload_routes_unless_loaded
  end

  def signup_params(email, extra = {})
    {
      user: { email:, password: "password123", password_confirmation: "password123", accept_terms: "1" },
      form_token: SignupFormTimer.issue
    }.merge(extra)
  end

  test "the signup form includes the bot traps" do
    get new_user_registration_path

    assert_select "input[name=form_token]"
    assert_select "input[name=company_website]"
  end

  test "a human who takes their time can sign up" do
    params = signup_params("human@example.com")

    travel 5.seconds do
      assert_difference -> { User.count }, 1 do
        post user_registration_path, params:
      end
    end
  end

  test "a filled honeypot is silently dropped" do
    params = signup_params("bot@example.com", company_website: "http://spam.example")

    travel 5.seconds do
      assert_no_difference -> { User.count } do
        post user_registration_path, params:
      end
    end

    assert_redirected_to new_user_session_path
    assert_emails 0
  end

  test "a form submitted too fast is silently dropped" do
    assert_no_difference -> { User.count } do
      post user_registration_path, params: signup_params("fast@example.com")
    end

    assert_redirected_to new_user_session_path
  end

  test "a missing or forged token is silently dropped" do
    travel 5.seconds do
      assert_no_difference -> { User.count } do
        post user_registration_path, params: signup_params("forged@example.com", form_token: "nope")
      end
    end
  end
end
