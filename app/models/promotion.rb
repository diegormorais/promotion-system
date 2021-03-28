class Promotion < ApplicationRecord
    has_many :coupons, dependent: :destroy
    
    validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :name, :code, uniqueness: true

    def generate_coupons!
        return unless coupons.empty?
        Coupon.transaction do
            (1..coupon_quantity).each do |number|
                coupons.create!(code: "#{code}-#{'%04d' % number}")
            end
        end
    end

    # TODO: fazer testes para esse método
    def coupons?
        coupons.any?
    end
end
