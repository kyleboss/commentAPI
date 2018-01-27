require "rails_helper"

RSpec.describe DoctorsSpecialtiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/doctors_specialties").to route_to("doctors_specialties#index")
    end


    it "routes to #show" do
      expect(:get => "/doctors_specialties/1").to route_to("doctors_specialties#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/doctors_specialties").to route_to("doctors_specialties#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/doctors_specialties/1").to route_to("doctors_specialties#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/doctors_specialties/1").to route_to("doctors_specialties#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/doctors_specialties/1").to route_to("doctors_specialties#destroy", :id => "1")
    end

  end
end
