require_relative '../elevator.rb'

describe Elevator do
  describe '#initialize' do
    subject { Elevator.new(floor, num_floors) }

    let(:floor) { 2 }
    let(:num_floors) { 10 }

    it 'initializes with the proper number of floors' do
      expect(subject.instance_variable_get(:@requests).length).to eq(num_floors)
    end

    it 'initializes on the proper floor' do
      expect(subject.floor).to eq(floor)
    end
  end
end
