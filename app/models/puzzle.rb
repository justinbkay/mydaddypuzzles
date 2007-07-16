class Puzzle < ActiveRecord::Base
  has_many :configurations
  
  validates_presence_of :name, :description, :size
  validates_uniqueness_of :name
  
  def find_default_configuration
    if default_configuration
      return Configuration.find(default_configuration)
    else
      begin
        self.configurations.detect {|c| c.active?}
      rescue ActiveRecord::RecordNotFound
        return nil
      end
    end
  end
  
  def default_configurations
    configs = []
    self.configurations.each do |c|
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
