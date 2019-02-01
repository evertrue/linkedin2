module LinkedIn
  class EmailAddress < Base
    def self.find(id, *fields)
      find_by id: id, fields: Array[*fields]
    end

    def self.find_by(options)
      Profile.new client.profile( { fields: LinkedIn.r_liteprofile }.merge options)
    end
  end
end
