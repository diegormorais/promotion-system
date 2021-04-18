Fabricator(:coupon) do
    code { sequence(:code) }
    promotion
    status :active

    before_create do |coupon, transient|
        coupon.code = "#{coupon.promotion.code}-#{'%04d' % (coupon.code.to_i + 1)}"
    end
end