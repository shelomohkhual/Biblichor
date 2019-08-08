class TestJob < ApplicationJob
  queue_as :default

  def perform(user_name)
    # Do something later
  end
end
