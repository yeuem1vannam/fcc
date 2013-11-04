class TestResque
  @queue = :test_resque

  def self.perform
    puts "test resque"
  end
end
