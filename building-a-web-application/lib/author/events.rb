class AuthorCreated < Sequent::Event

end

class AuthorNameSet < Sequent::Event
  attrs name: String
end

class AuthorEmailSet < Sequent::Event
  attrs email: String
end
