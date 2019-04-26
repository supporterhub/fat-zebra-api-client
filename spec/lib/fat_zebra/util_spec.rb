require 'spec_helper'

describe FatZebra::Util do

  describe '#compact' do
    it { expect(FatZebra::Util.compact(test: nil, other: 'test')).to eq(other: 'test') }
  end

  describe '#camelize' do
    it { expect(FatZebra::Util.camelize('model')).to eq("Model") }
    it { expect(FatZebra::Util.camelize('my_model')).to eq("MyModel") }
  end

  describe '#underscore' do
    it { expect(FatZebra::Util.underscore('Model')).to eq("model") }
    it { expect(FatZebra::Util.underscore('MyModel')).to eq("my_model") }
  end

  describe '#format_dates_in_hash' do
    let (:date)      { Date.new     2050, 2, 3 }
    let (:date_time) { DateTime.new 2060, 2, 3,  1, 0, 0, "+11:00" }
    let (:time)      { Time.new     2070, 2, 3, 23, 0, 0, "-11:00" }

    it {
      expect(
        FatZebra::Util.format_dates_in_hash(
          date:      date,
          date_time: date_time,
          time:      time,
          untouched: "test",
          nil:       nil
        )
      ).to eq(
        date:      "2050/02/03",
        date_time: "2060/02/03",
        time:      "2070/02/03",
        untouched: "test",
        nil: nil
      )
    }
  end

end
