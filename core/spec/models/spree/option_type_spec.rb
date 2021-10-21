require 'spec_helper'

describe Spree::OptionType, type: :model do
  it_behaves_like 'metadata'

  context 'touching' do
    it 'touches a product' do
      product_option_type = create(:product_option_type)
      option_type = product_option_type.option_type
      product = product_option_type.product
      product.update_column(:updated_at, 1.day.ago)
      option_type.touch
      expect(product.reload.updated_at).to be_within(3.seconds).of(Time.current)
    end
  end

  describe '#filter_param' do
    let!(:option_type) { create(:option_type, name: 'color', presentation: 'Color') }
    let!(:other_option_type) { create(:option_type, name: 'secondary color', presentation: 'Secondary Color') }
    let!(:some_option_type) { create(:option_type, name: 'option type', presentation: 'Some Option Type') }

    it 'returns filtered name param' do
      expect(option_type.filter_param).to eq('color')
      expect(other_option_type.filter_param).to eq('secondary-color')
      expect(some_option_type.filter_param).to eq('option-type')
    end
  end

  describe '#self.color' do
    let!(:option_type) { create(:option_type, name: 'color', presentation: 'Color') }

    it 'finds color option type' do
      Spree::OptionType.color.id == option_type.id
    end
  end
end
