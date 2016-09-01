class Api::BaseController < ApplicationController
  # This is API
  skip_before_action :verify_authenticity_token
end

