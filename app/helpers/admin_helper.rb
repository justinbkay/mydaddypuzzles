module AdminHelper
  def is_default?(config)
    if config.puzzle.default_configuration == config.id
      return true
    else
      return false
    end
  end
end
