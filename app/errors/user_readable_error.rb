class UserReadableError < StandardError
  def initialize(message)
    super(message)
  end
end
