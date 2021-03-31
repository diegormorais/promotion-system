require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
    # TODO: o que acontece se tem mais de um cupom
    test 'disable a coupon' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                                    expiration_date: '22/12/2033')
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit promotion_path(promotion)
    click_on 'Desabilitar'

    assert_text "Cupom NATAL10-0001 desabilitado com sucesso"
    assert_text "NATAL10-0001 (Desabilitado)"
    assert_no_link 'Desabilitar'
    end
end