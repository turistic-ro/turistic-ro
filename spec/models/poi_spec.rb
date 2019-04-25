require 'rails_helper'

RSpec.describe POI, type: :model do
  subject { described_class.new }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'triggers update_shape on save' do
    expect(subject).to receive(:enqueue_update_shape_job)
    subject.save
  end

  describe '#enqueue_update_shape_job' do
    it 'calls POIUpdateShapeJob' do
      expect(POIUpdateShapeJob).to receive(:perform_later)
      subject.send(:enqueue_update_shape_job)
    end
  end
end