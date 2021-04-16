require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
    test 'show coupon' do
        user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 100,
                                      expiration_date: '22/12/2033', user: user)
        
        coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

        get "/api/v1/coupons/#{coupon.code}", as: :json

        assert_response :success
        assert_equal promotion.discount_rate.to_s, response.parsed_body['discount_rate']
    end

    test 'show coupon not found' do
        get '/api/v1/coupons/0', as: :json

        assert_response :not_found
    end

    test 'route invalid without json header' do
        assert_raises ActionController::RoutingError do
            get '/api/v1/coupons/0'
        end
    end

    test 'show coupon disabled' do
        user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 100,
                                      expiration_date: '22/12/2033', user: user)
        
        coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: :disabled)

        get "/api/v1/coupons/#{coupon.code}", as: :json

        assert_response :success
        assert_equal promotion.discount_rate.to_s, response.parsed_body['discount_rate']
    end
end