class PaymentsController < ApplicationController
    rescue_from Stripe::CardError, with: :catch_exception


    def create
        
    end
    
    
    def new
      # if !reservation.user.stripe_id.blank?
      #   customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
      #   charge = Stripe::Charge.create(
      #     :customer => customer.id,
      #     :amount => @book.price * 100,
      #     :description => @book.title,
      #     :currency => "myr",
         
      #   )
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :stripe_secret_key)
      @book = Book.find_by(id: params[:format])
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: 'Payment',
          description: @book.title,
          amount: 10 * 100,
          currency: 'myr',
          quantity: 1,
        }],
        success_url: cart_url,
        cancel_url:  cart_url,
      )
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
