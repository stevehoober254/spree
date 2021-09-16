shared_examples_for 'metadata' do |factory: described_class.name.demodulize.underscore.to_sym|
  subject { FactoryBot.create(factory) }

  it { expect(subject.has_attribute?(:public_metadata)).to be_truthy }
  it { expect(subject.has_attribute?(:private_metadata)).to be_truthy }

  it { expect(subject.public_metadata.class).to eq(HashWithIndifferentAccess) }
  it { expect(subject.private_metadata.class).to eq(HashWithIndifferentAccess) }
end
