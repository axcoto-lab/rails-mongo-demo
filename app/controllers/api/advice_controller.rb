class Api::AdviceController < Api::BaseController
  DEFAULT_DIAMETER = 10

  def show
    creteria = {
      diameter: params[:diameter] || DEFAULT_DIAMETER,
      lat: params[:lat],
      long: params[:long],
      user_id: params[:userId],
      skin_type: params[:skinType]
    }

    if validate(creteria)
      render json: {error: "Missing params: lat, long, user_id or skin_type"}, status: 422
      return
    end

    @advice = Advice.find(creteria)
    if @advice.present?
      render json: @advice
    else
      render json: {error: "No advice found"}, status: 404
    end
  end

  private

  def validate(input)
    !(input[:lat].nil?  || input[:long].nil? || input[:user].nil? || input[:skin_type].nil?)
  end

end
