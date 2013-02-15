class Puzzle < ActiveRecord::Base
  has_many :puzzle_configs
  has_many :prizes

  validates_presence_of :name, :description, :size
  validates_uniqueness_of :name
  scope :active, lambda { where(:active => true) }

  def find_default_configuration
    if default_configuration
      return PuzzleConfig.find(default_configuration)
    else
      begin
        self.puzzle_configs.detect {|c| c.active?}
      rescue ActiveRecord::RecordNotFound
        return nil
      end
    end
  end

  def default_configurations
    configs = []
    self.puzzle_configs.each do |c|
      if c.active?
        configs.push(c)
      end
    end
    return configs
  end

  def to_s
    name
  end

end
