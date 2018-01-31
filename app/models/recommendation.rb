# frozen_string_literal: true

# A Recommendation tells the user a doctor that the service recommends they check out. The two pieces of information
# most vital to a recommendation is a doctor's average rating and the distance away from a base doctor. A list of
# these recommendations will be provided to the user when they comment on a doctor.
#
# If your interested in the intricate deets: Recommendations are made by looking at the most recent ratings and the
# distance. The distance is normalized to a number 1-5 (5 being super close to the doctor, 1 being super far). So we
# have a rating and a distance, both with values of 1-5. We add the two to give us a "score". A score of 10 is perfect,
# thus we will serve that to the user before another doctor who has a score of 8.
class Recommendation
  attr_accessor :distance, :doctor
  def initialize(distance, doctor)
    @distance = distance
    @doctor = doctor
  end

  # Creates a list of recommendations for doctors the user might like. 20 max.
  def self.all_for(doctor)
    close_doctors = doctors_close_to(doctor)
    highly_rated_close_doctors = highly_rated_doctors(close_doctors)
    recommended_doctors = sort_doctors_by_score(doctor, highly_rated_close_doctors).first(20)
    recommended_doctors.map { |d| Recommendation.new(d.distance_to(doctor), d) }
  end

  # I chose to use as_json to serialize the data. I could've used a serializer (normally that is preferred IMO), but
  # this object is created strictly to be provided as a JSON, so I opted to go this route instead of making a
  # serializer.
  def as_json(_obj = {})
    {
      average_rating: @doctor.recent_average_rating,
      distance: @distance,
      doctor_name: @doctor.name,
      doctor_id: @doctor.id
    }
  end

  private_class_method

  # Find 100 closest doctors to a given doctor who is not the current doctor
  def self.doctors_close_to(doctor)
    Doctor.by_distance(origin: [doctor.latitude, doctor.longitude]).where.not(id: doctor.id).limit(100)
  end

  # Given a list of doctors, returns only those doctors whom lately have received positive ratings.
  def self.highly_rated_doctors(doctors)
    doctors.select { |d| d.recent_average_rating > 3 }
  end

  # Given a base doctor and a list of doctors, sorts the doctors based on relative & recommendable they are.
  def self.sort_doctors_by_score(doctor, doctors)
    return [] if doctors.empty?
    distances = doctors.map { |d| d.distance_to(doctor) }
    distance_bounds = { low: distances.min, high: distances.max}

    i = -1
    sorted_doctors = doctors.sort_by do |doctor|
      i += 1
      recommendability_score(distances[i], distance_bounds[:low], distance_bounds[:high], doctor.recent_average_rating)
    end
    sorted_doctors.reverse!
  end

  # Scores a doctor on her recommendability by rating (independent of the base-doctors rating, BTW) and how close the
  # doctors are to the base-doctor.
  #
  # The current implementation scores the doctors 0-10 (well, technically 1-9.. but you got me). The
  # rating + closeness score, each valuing 1-5, will give the total score.
  def self.recommendability_score(distance, min_distance, max_distance, rating)
    min_rating = 1
    max_rating = 5
    rating_range = max_rating - min_rating
    distance_range = max_distance - min_distance
    normalized_distance = min_rating + (distance - min_distance) * (rating_range.to_f / distance_range)
    closeness_score = (normalized_distance - 5).abs
    closeness_score + rating
  end
end
