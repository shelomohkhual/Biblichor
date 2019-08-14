class PaymentsController < ApplicationController
    rescue_from Stripe::CardError, with: :catch_exception


    def create
        byebug
        session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            line_items: [{
              name: 'T-shirt',
              description: 'Comfortable cotton t-shirt',
              images: ['https://example.com/t-shirt.png'],
              amount: 500,
              currency: 'myr',
              quantity: 1,
            }],
            success_url: 'https://example.com/success',
            cancel_url: 'https://example.com/cancel',
          )
    end
    
    
    def new
        # byebug
        @book = Book.find_by(id: params[:format])
    end

    # def create
    # StripeChargesServices.new(payments_params, current_user).call
    # redirect_to new_charge_path
    # end

    private

    def payments_params
    params.permit(:stripeEmail, :stripeToken, :order_id)
    end

    def catch_exception(exception)
    flash[:error] = exception.message
    end

end
