class TestJob < ApplicationJob
  queue_as :default

  def perform(user_name)
    sleep(5)
    flash[:notice] = "#{user_name}what the f!?"
    # Do something later
  end
end
