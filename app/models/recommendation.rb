# frozen_string_literal: true

# A Recommendation tells the user a doctor that the service recommends they check out. The three pieces of information
# most vital to a recommendation is a doctor's average rating, the share and the distance away from a base doctor. A list of
# these recommendations will be provided to the user when they comment on a doctor.
#
# If your interested in the intricate deets: Recommendations are made by looking at the most recent ratings, the number
# of shared specialties, the groups the doctors are in, and the distance between the doctors. The distance is normalized
# to a number 1-5 (5 being super close to the doctor, 1 being super far). So we have a rating, a distance and the number
# of shared specialties (up to 5), and if the doctors are in the same group (5 points if they are, 0 otherwise), all of
# which have values between 1-5. We add the three numbers to give us a "score". A score of 20 is perfect, while a score
# of 0 means it is pretty unlikely to be relevant to the user.
class Recommendation
  attr_accessor :distance, :doctor
  def initialize(distance, doctor)
    @distance = distance
    @doctor = doctor
  end

  # Creates a list of recommendations for doctors the user might like. 20 max.
  def self.all_for(doctor)
    relevant_close_doctors = relevant_doctors_close_to(doctor)
    recommended_doctors = sort_doctors_by_score(doctor, relevant_close_doctors).first(20)
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

  # Find 100 closest doctors to a given doctor who is not the current doctor, but in the same group.
  def self.relevant_doctors_close_to(doctor)
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
    sorted_doctors = doctors.sort_by do |rec_doc|
      i += 1
      recommendability_score(distances[i], distance_bounds[:low], distance_bounds[:high], rec_doc, doctor)
    end
    sorted_doctors.reverse!
  end

  # Scores a doctor on her recommendability by rating (independent of the base-doctors rating, BTW) and how close the
  # doctors are to the base-doctor.
  #
  # The current implementation scores the doctors 0-20.
  # The average rating + closeness score + specialty score + group score, each valuing 1-5, will give the total score.
  def self.recommendability_score(distance, min_distance, max_distance, recommended_doctor, base_doctor)
    rating_score = recommended_doctor.recent_average_rating
    closeness_score = closeness_score(distance, max_distance, min_distance)
    shared_specialty_score = num_shared_specialties(recommended_doctor, base_doctor)
    group_score = recommended_doctor.group == base_doctor.group ? 5 : 0
    closeness_score + rating_score + shared_specialty_score + group_score
  end

  # Calculature the number of shared specialties in between two doctors, up to 5.
  def self.num_shared_specialties(doctor1, doctor2)
    [(doctor1.specialties & doctor2.specialties).count, 5].min
  end

  # Normalizes the distance to be somewhere between 1 through 5.
  def self.closeness_score(distance, max_distance, min_distance)
    min_rating = 1
    max_rating = 5
    rating_range = max_rating - min_rating
    distance_range = max_distance - min_distance
    normalized_distance = min_rating + (distance - min_distance) * (rating_range.to_f / distance_range)
    (normalized_distance - 5).abs
  end
end
