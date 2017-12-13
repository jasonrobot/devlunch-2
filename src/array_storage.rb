class ArrayStorage
    @@users = Hash.new

    @@next_id = 0

    def self.next_user_id
        id = @@next_id
        @@next_id = id + 1
        return id
    end

    def self.store_user (user)
        @@users[user.id] = user
    end

    def self.load_user (id)
    end

    def self.load_all_users
        return @@users
    end
end