require 'spec_helper'

describe 'Platform API v2 Taxons API' do
  include_context 'Platform API v2'

  let(:taxonomy) { create(:taxonomy, store: store) }
  let(:store_2) { create(:store) }
  let(:bearer_token) { { 'Authorization' => valid_authorization } }

  describe 'taxons#index' do
    let!(:taxon) { create(:taxon, name: 'T-Shirts', taxonomy: taxonomy) }
    let!(:taxon_2) { create(:taxon, name: 'Pants', taxonomy: taxonomy) }
    let!(:taxon_3) { create(:taxon, name: 'T-Shirts', taxonomy: create(:taxonomy, store: store_2)) }

    context 'filtering' do
      before { get "/api/v2/platform/taxons?filter[name_i_cont]=shirt", headers: bearer_token }

      it 'returns taxons with matching name' do
        expect(json_response['data'].count).to eq 1
        expect(json_response['data'].first).to have_id(taxon.id.to_s)
        expect(json_response['data'].first).to have_relationships(:taxonomy, :parent, :children, :image)
      end
    end

    context 'sorting' do
      before { get "/api/v2/platform/taxons?sort=name", headers: bearer_token }

      it 'returns taxons sorted by name' do
        expect(json_response['data'].count).to eq taxonomy.taxons.count
        expect(json_response['data'].first).to have_id(taxon_2.id.to_s)
      end
    end
  end

  describe 'taxons#show' do
    let!(:taxon) { create(:taxon, name: 'T-Shirts', taxonomy: taxonomy) }

    context 'with valid id' do
      before { get "/api/v2/platform/taxons/#{taxon.id}", headers: bearer_token }

      it 'returns taxon' do
        expect(json_response['data']).to have_id(taxon.id.to_s)
        expect(json_response['data']).to have_relationships(:taxonomy, :parent, :children, :image, :products)
      end
    end

    context 'with taxon image data' do
      shared_examples 'returns taxon image data' do
        it 'returns taxon image data' do
          expect(json_response['included'].count).to eq(1)
          expect(json_response['included'].first['type']).to eq('taxon_image')
        end
      end

      let!(:image) { create(:taxon_image, viewable: taxon) }
      let(:image_json_data) { json_response['included'].first['attributes'] }

      before { get "/api/v2/storefront/taxons/#{taxon.id}?include=image#{taxon_image_transformation_params}", headers: bearer_token }

      context 'when no image transformation params are passed' do
        let(:taxon_image_transformation_params) { '' }

        it_behaves_like 'returns 200 HTTP status'
        it_behaves_like 'returns taxon image data'

        it 'returns taxon image' do
          expect(image_json_data['transformed_url']).to be_nil
        end
      end

      context 'when taxon image json returned' do
        let(:taxon_image_transformation_params) { '&taxon_image_transformation[size]=100x50&taxon_image_transformation[quality]=50' }

        it_behaves_like 'returns 200 HTTP status'
        it_behaves_like 'returns taxon image data'

        it 'returns taxon image' do
          expect(image_json_data['transformed_url']).not_to be_nil
        end
      end
    end
  end
end
