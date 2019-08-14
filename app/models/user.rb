class User < ApplicationRecord
  serialize :cart, Array

  has_many :book
  has_many :rent

  has_many :reviews, through: :users

  # profile image
  has_one_attached :image


  # GEOCODER
  # geocoded_by :address
  # geocoded_by :address
  
  # search
  # searchkick word_middle: [:name, :username, :city, :zipcode, :country, :state]
  # FOR SEARCH KICK
  # def search_data
  #   {
  #   username: username,
  #   name: name,
  #   state: state,
  #   city: city,
  #   zipcode: zipcode
  #   }
  # end
  # FOR UPDATE
  # after_commit :reindex_user
  # def reindex_user
  #     User.reindex
  # end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook]
  
  after_commit :send_pending_devise_notifications

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_now
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # user.image = auth.info.image # assuming the user model has an image
      user.name = auth.info.name   # assuming the user model has a name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

    protected

    def send_devise_notification(notification, *args)
      # If the record is new or changed then delay the
      # delivery until the after_commit callback otherwise
      # send now because after_commit will not be called.
      if new_record? || changed?
        pending_devise_notifications << [notification, args]
      else
        render_and_send_devise_message(notification, *args)
      end
    end

    private

    def send_pending_devise_notifications
      pending_devise_notifications.each do |notification, args|
        render_and_send_devise_message(notification, *args)
      end

      # Empty the pending notifications array because the
      # after_commit hook can be called multiple times which
      # could cause multiple emails to be sent.
      pending_devise_notifications.clear
    end

    def pending_devise_notifications
      @pending_devise_notifications ||= []
    end

    def render_and_send_devise_message(notification, *args)
      message = devise_mailer.send(notification, self, *args)

      # Deliver later with Active Job's `deliver_later`
      if message.respond_to?(:deliver_later)
        message.deliver_later
      # Remove once we move to Rails 4.2+ only, as `deliver` is deprecated.
      elsif message.respond_to?(:deliver_now)
        message.deliver_now
      else
        message.deliver
      end
    end

end