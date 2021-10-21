require 'spec_helper'

describe Spree::Api::V2::Platform::ProductSerializer do
  include_context 'API v2 serializers params'

  subject { described_class.new(product, params: serializer_params) }

  let!(:images) { create_list(:image, 2) }
  let(:product) do
    create(:product_in_stock,
           name: 'Test Product',
           price: 10.00,
           compare_at_price: 15.00,
           variants_including_master: [create(:variant, images: images), create(:variant)],
           option_types: create_list(:option_type, 2),
           product_properties: create_list(:product_property, 2),
           taxons: create_list(:taxon, 2),
           tax_category: create(:tax_category))
  end

  it { expect(subject.serializable_hash).to be_kind_of(Hash) }

  it do
    expect(subject.serializable_hash).to eq(
      {
        data: {
          id: product.id.to_s,
          type: :product,
          attributes: {
            name: product.name,
            description: product.description,
            available_on: product.available_on,
            deleted_at: product.deleted_at,
            slug: product.slug,
            meta_description: product.meta_description,
            meta_keywords: product.meta_keywords,
            created_at: product.created_at,
            updated_at: product.updated_at,
            promotionable: product.promotionable,
            meta_title: product.meta_title,
            discontinue_on: product.discontinue_on,
            purchasable: product.purchasable?,
            in_stock: product.in_stock?,
            backorderable: product.backorderable?,
            available: product.available?,
            currency: currency,
            price: BigDecimal(10),
            display_price: '$10.00',
            compare_at_price: BigDecimal(15),
            display_compare_at_price: '$15.00',
            public_metadata: {},
            private_metadata: {}
          },
          relationships: {
            tax_category: {
              data: {
                id: product.tax_category.id.to_s,
                type: :tax_category
              }
            },
            primary_variant: {
              data: {
                id: product.master.id.to_s,
                type: :variant
              }
            },
            default_variant: {
              data: {
                id: product.default_variant.id.to_s,
                type: :variant
              }
            },
            variants: {
              data: [
                {
                  id: product.variants.first.id.to_s,
                  type: :variant
                },
                {
                  id: product.variants.second.id.to_s,
                  type: :variant
                }
              ]
            },
            option_types: {
              data: [
                {
                  id: product.option_types.first.id.to_s,
                  type: :option_type
                },
                {
                  id: product.option_types.second.id.to_s,
                  type: :option_type
                }
              ]
            },
            product_properties: {
              data: [
                {
                  id: product.product_properties.first.id.to_s,
                  type: :product_property
                },
                {
                  id: product.product_properties.second.id.to_s,
                  type: :product_property
                }
              ]
            },
            taxons: {
              data: [
                {
                  id: product.taxons.first.id.to_s,
                  type: :taxon
                },
                {
                  id: product.taxons.second.id.to_s,
                  type: :taxon
                }
              ]
            },
            images: {
              data: [
                {
                  id: product.variant_images.first.id.to_s,
                  type: :image
                },
                {
                  id: product.variant_images.second.id.to_s,
                  type: :image
                }
              ]
            },
          }
        }
      }
    )
  end
end
