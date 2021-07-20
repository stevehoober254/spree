module Spree
  module UserReporting
    def display_lifetime_value(store = nil)
      store ||= Store.default
      Spree::Money.new(lifetime_value(store), currency: store.default_currency)
    end

    def lifetime_value(store = nil)
      store ||= Store.default
      store.orders.complete.sum(:total)
    end

    def display_average_order_value(store = nil)
      store ||= Store.default
      Spree::Money.new(average_order_value(store), currency: store.default_currency)
    end

    def average_order_value(store = nil)
      store ||= Store.default
      store.orders.complete.average(:total).to_f
    end

    def order_count(store = nil)
      store ||= Store.default
      store.orders.complete.size.to_f
    end
  end
end
