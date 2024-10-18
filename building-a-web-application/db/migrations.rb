require 'sequent/migrations/projectors'

VIEW_SCHEMA_VERSION = 3

class Migrations < Sequent::Migrations::Projectors
  def self.version
    VIEW_SCHEMA_VERSION
  end

  def self.versions
    {
      '1' => [
        PostProjector
      ],
      '2' => [ # Projectors that need to be rebuild:
        AuthorProjector
      ],
      '3' => [
        PostProjector
      ]
    }
  end
end
