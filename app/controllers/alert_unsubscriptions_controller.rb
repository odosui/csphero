# Turns one kind of alert email off for the website the signed token names.
# Mail providers call `create` directly for one-click unsubscribe (RFC 8058),
# so the token in the URL is the only credential.
class AlertUnsubscriptionsController < ApplicationController
  skip_forgery_protection only: :create
  before_action :set_subscription

  def show
  end

  def create
    @subscription.unsubscribe
  end

  private

  def set_subscription
    @subscription = Alerts::Subscription.find(params[:kind], params[:token])
    render :invalid, status: :not_found if @subscription.nil?
  end
end
