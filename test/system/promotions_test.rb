require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    # fill_in 'Nome', with: ''
    # fill_in 'Descrição', with: ''
    # fill_in 'Código', with: ''
    # fill_in 'Desconto', with: ''
    # fill_in 'Quantidade de cupons', with: ''
    # fill_in 'Data de término', with: ''
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Nome', with: 'Natal'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    # Arrange
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    # Act
    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    # Assert
    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001'
    assert_text 'NATAL10-0002'
    assert_text 'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
  end

  test 'edit promotion' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    login_user
    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: 'Queima de Estoque'
    fill_in 'Descrição', with: 'Promoção de Queima de Estoque'
    fill_in 'Código', with: 'QUEIMA20'
    fill_in 'Desconto', with: '20'
    fill_in 'Quantidade de cupons', with: '50'
    fill_in 'Data de término', with: '16/01/2022'
    click_on 'Salvar'
    
    assert_current_path promotion_path(promotion)
    assert_text 'Queima de Estoque'
    assert_text 'Promoção de Queima de Estoque'
    assert_text 'QUEIMA20'
    assert_text '20,00%'
    assert_text '50'
    assert_text '16/01/2022'
    assert_link 'Voltar'
  end

  test 'delete promotion' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    accept_alert do
      click_on 'Apagar'      
    end
    assert_current_path promotions_path
    assert_text 'Promoção apagada!'
  end

  test 'search promotions by term and find results' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', coupon_quantity: 100,
                                    description: 'Promoção Natalina',
                                    code: 'NATAL11', discount_rate: 15,
                                    expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    login_user
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    refute_text cyber_monday.name
  end

  test 'user approves promotion' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    approver = login_user
    visit promotion_path(christmas)
    accept_confirm { click_on 'Aprovar' }
    
    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar cupons'
    refute_link 'Aprovar'
  end

  # TODO: não encontra nada
  # TODO: visit página sem estar logado



  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
    visit promotions_path
  
    assert_current_path new_user_session_path
  end

  test 'do view promotion details without login' do
    user = User.create!(email: 'john.doe@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033', user: user)

      visit promotion_path(promotion)

      assert_current_path new_user_session_path
  end

  test 'ca not create promotion without login ' do
    visit new_promotion_path

    assert_current_path new_user_session_path
  end
end