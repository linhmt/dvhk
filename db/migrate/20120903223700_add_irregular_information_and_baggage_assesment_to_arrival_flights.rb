class AddIrregularInformationAndBaggageAssesmentToArrivalFlights < ActiveRecord::Migration
  def change
    add_column :arrival_flights, :irregular_information, :text
    add_column :arrival_flights, :baggage_assessment, :boolean
  end
end
