require 'sequent/migrations/projectors'

VIEW_SCHEMA_VERSION = 2

class Migrations < Sequent::Migrations::Projectors
  def self.version
    VIEW_SCHEMA_VERSION
  end

  def self.versions
    {
      '1' => [
        PostProjector
      ],
      '2' => [
        AuthorProjector
      ]
    }
  end
end
