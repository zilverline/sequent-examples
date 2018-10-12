class UsernamesCreated < Sequent::Event

end

class UsernameAdded < Sequent::Event
  attrs username: String
end
