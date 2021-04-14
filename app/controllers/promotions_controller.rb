class PromotionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_promotion, only: [:show, :generate_coupons, :edit, :update, :destroy, :approve]
    
    def index
        @promotions = Promotion.all
    end

    def show
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = current_user.promotions.new(promotion_params)
        if @promotion.save
            redirect_to @promotion
        else
            render :new
        end
    end

    def generate_coupons
        @promotion.generate_coupons!
        redirect_to @promotion, notice: t('.success')
    end

    def edit
    end

    def update
        @promotion.update(promotion_params)
        redirect_to @promotion
    end

    def destroy
        @promotion.destroy
        redirect_to promotions_path, notice: 'Promoção apagada!'
    end

    def search
        @promotions = Promotion.search(params[:q])
        render :index
    end

    def approve
        PromotionApproval.create!(promotion: @promotion, user: current_user)
        redirect_to @promotion, notice: 'Promoção aprovada com sucesso'
    end

    private

        def promotion_params
            params
            .require(:promotion)
            .permit(:name, :description, :coupon_quantity, :expiration_date, :code, :discount_rate)
        end

        def set_promotion
            @promotion = Promotion.find(params[:id])
        end
end