class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def routing_error
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end
end
