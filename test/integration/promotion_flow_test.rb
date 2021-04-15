require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
    test 'can create a promotion' do
        login_user
        post '/promotions', params: { 
            promotion: { name: 'Natal', description: 'Promoção de natal', 
            code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
            expiration_date: '22/12/2033' } 
        }

        assert_redirected_to promotion_path(Promotion.last)
        # assert_response :found
        follow_redirect!
        # assert_response :success
        assert_select 'h3', 'Natal'
    end

    test 'cannot create a promotion without login' do
        post '/promotions', params: { 
            promotion: { name: 'Natal', description: 'Promoção de natal', 
            code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
            expiration_date: '22/12/2033' } 
        }

        assert_redirected_to new_user_session_path
    end

    test 'cannot generate coupons without login' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de natal', 
                                      code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
                                      expiration_date: '22/12/2033')

        post generate_coupons_promotion_path(promotion)

        assert_redirected_to new_user_session_path
    end

    test 'cannot update promotion without login' do
        # TODO: teste do update sem login
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de natal', 
            code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
            expiration_date: '22/12/2033')

            post '/promotions/id', params: { 
                promotion: { name: 'Queima', description: 'Queima de estoque', 
                code: 'QUEIMA20', discount_rate: 15, coupon_quantity: 5, 
                expiration_date: '22/12/2033' } 
            }
        # assert_redirected_to new_user_session_path
    end 

    test 'cannot destroy promotion without login' do
        # TODO: teste do destroy sem login
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de natal', 
            code: 'NATAL10', discount_rate: 15, coupon_quantity: 5, 
            expiration_date: '22/12/2033')
        
        get generate_coupons_promotion_path(promotion)

        assert_redirected_to new_user_session_path
    end

      # TODO: teste de login da aprovação

  test 'cannot approve if owner' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033', user: user)

    login_user(user)

    post approve_promotion_path(promotion)
    assert_redirected_to promotion_path(promotion)
    refute promotion.reload.approved?
    assert_equal 'Ação não permitida', flash[:alert]
  end
end