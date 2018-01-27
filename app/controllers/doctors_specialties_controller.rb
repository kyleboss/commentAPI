class DoctorsSpecialtiesController < ApplicationController
  before_action :set_doctors_specialty, only: [:show, :update, :destroy]

  # GET /doctors_specialties
  def index
    @doctors_specialties = DoctorsSpecialty.all

    render json: @doctors_specialties
  end

  # GET /doctors_specialties/1
  def show
    render json: @doctors_specialty
  end

  # POST /doctors_specialties
  def create
    @doctors_specialty = DoctorsSpecialty.new(doctors_specialty_params)

    if @doctors_specialty.save
      render json: @doctors_specialty, status: :created, location: @doctors_specialty
    else
      render json: @doctors_specialty.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doctors_specialties/1
  def update
    if @doctors_specialty.update(doctors_specialty_params)
      render json: @doctors_specialty
    else
      render json: @doctors_specialty.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doctors_specialties/1
  def destroy
    @doctors_specialty.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctors_specialty
      @doctors_specialty = DoctorsSpecialty.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def doctors_specialty_params
      params.require(:doctors_specialty).permit(:doctor_id, :specialty_id)
    end
end
