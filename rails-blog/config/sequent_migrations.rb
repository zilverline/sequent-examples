require 'sequent/migrations/projectors'
require_relative '../app/sequent/projectors/post_projector'

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
        PostProjector,
      ],
      '3' => [
        PostProjector,
      ],
    }
  end
end
