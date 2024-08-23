
class NilClass

  # Error Im trying to solve..
  def html_safe
    'ε' # 🤷🏼‍♀️ empty
  end

  # https://stackoverflow.com/questions/9747086/can-i-monkey-patch-nilclass-to-return-nil-for-missing-methods
  # def method_missing(*_)
  #   nil
  # end
  # def respond_to_missing?(*_)
  #   true
  # end

end
