VIEW_SCHEMA_VERSION = 3

class SequentMigrations < Sequent::Migrations::Projectors
  def self.version
    VIEW_SCHEMA_VERSION
  end

  def self.versions
    {
      '1' => [

      ],
      '2' => [
        Projectors::PostProjector,
      ],
      '3' => [
        Projectors::PostProjector,
      ],
    }
  end
end
