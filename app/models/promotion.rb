class Promotion < ApplicationRecord
    belongs_to :user
    has_many :coupons, dependent: :destroy
    has_one :promotion_approval
    
    validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :name, :code, uniqueness: true
    SEARCHABLE_FIELDS = %w[name code description].freeze

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

    def self.search(query)
        where(
            SEARCHABLE_FIELDS
                .map { |field| "#{field} LIKE :query" }
                .join(' OR '),
                query: "%#{query}%")
            .limit(5)
    end

    def approved?
        promotion_approval.present?
    end
end
