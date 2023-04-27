class Api::V1::CompaniesController < ApiController
  before_action :set_company, only: %i[ show update destroy ]

  # GET /companies
  def index
    @companies = current_user.companies

    render json: @companies
  end

  # GET /companies/1
  def show
    render json: @company
  end

  # POST /companies
  def create
    # @company = Company.new(company_params)
     @company = current_user.companies.new(company_params)

    if @company.save
      render json: @company, status: :created, location: @company
    else
      render json: @company.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: @company.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    if @company.destroy
      render json: { data: "Company deleted successfully ", status: 'success' },
            status: :ok
    else
      render json: { data: "Sothing went wrong", status: 'failed' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = current_user.companies.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message, status: :unauthorized
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :established_year, :address, :user_id)
    end
end
