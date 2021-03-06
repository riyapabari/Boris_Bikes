require 'DockingStation'

describe DockingStation do
	
  it {is_expected.to respond_to :release_bike}

  it {is_expected.to respond_to(:dock).with(1).argument}

  it {is_expected.to respond_to (:bikes)}

  describe '#release_bike' do
    it 'releases a bike if bikes are available' do
      bike = Bike.new
      subject.dock(bike)
      expect(subject.release_bike).to eq bike
    end
    it 'raises an error if no bikes available' do
      expect{subject.release_bike}.to raise_error("No bikes available!")
    end
  end

  it 'releases working bikes' do
    bike = Bike.new
    subject.dock(bike)
    subject.release_bike
	  expect(bike).to be_working
	end
    
  describe '#dock(bike)' do
    it 'docks the bike when there is space available' do 
      bike = Bike.new
      expect(subject.dock(bike).last).to eq bike
    end
    it 'docks 20 bikes when capacity is set to default' do
      expect{DockingStation::DEFAULT_CAPACITY.times {subject.dock(Bike.new)}}.not_to raise_error
    end
    it 'raises an error when there is no space available when capacity is set to default' do
      DockingStation::DEFAULT_CAPACITY.times {subject.dock(Bike.new)}
      expect{subject.dock(Bike.new)}.to raise_error("No space available!")
    end
    it 'docks 50 bikes when capacity is set to 50' do
      station = DockingStation.new(50)
      expect{50.times {station.dock(Bike.new)}}.not_to raise_error
    end
    it 'raises an error at 51 bikes when capacity is set to 50' do
      station = DockingStation.new(50)
      50.times {station.dock(Bike.new)}
      expect{station.dock(Bike.new)}.to raise_error("No space available!")
    end
  end

  it 'returns docked bike' do 
  	bike = Bike.new
  	subject.dock(bike)
  	expect(subject.bikes.last).to eq bike
  end

  describe '#initialize' do
    it 'initialises with one argument' do
      expect{DockingStation.new(30)}.not_to raise_error
    end
    it 'initialises with default capacity' do
      expect(subject.capacity).to eq DockingStation::DEFAULT_CAPACITY
    end
  end

  describe 'releasing when there are some broken bikes' do
    it 'doesn\'t release latest bike when latest bike is broken' do
      station = DockingStation.new(1)
      bike = Bike.new
      bike.report_broken
      station.dock(bike)
      expect{station.release_bike}.to raise_error("Sorry, there are no working bikes available!")
    end

    it 'releases a bike when there are working bikes and the last one is broken' do
      station = DockingStation.new
      bike1 = Bike.new
      bike2 = Bike.new
      bike1.report_broken
      station.dock(bike2)
      station.dock(bike1)
      expect{station.release_bike}.not_to raise_error
    end

    it 'raises error already removed all working bikes' do
      station = DockingStation.new
      bike1 = Bike.new
      bike2 = Bike.new
      bike1.report_broken
      station.dock(bike2)
      station.dock(bike1)
      station.release_bike
      expect{station.release_bike}.to raise_error("Sorry, there are no working bikes available!")
    end

  end

end


