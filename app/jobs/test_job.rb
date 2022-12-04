class TestJob < ActiveJob::Base
  queue_as :default

  # TestJob.set(wait: 1.week).perform_later()
  def perform(*args)
    # Do something later
  end
end
