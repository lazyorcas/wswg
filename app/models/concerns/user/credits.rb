module User::Credits
  extend ActiveSupport::Concern

  include Credits

  def has_credits?
    admin? || super
  end

  def add_credits!(*args)
    return if admin?
    super(*args)
  end

  def add_free_credits!
    return if admin?
    super
  end

  def use_credit!
    return if admin?
    super
  end
end
