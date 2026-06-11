module Users
  class Follower
    def initialize(actor:, target:)
      @actor = actor
      @target = target
    end

    def call
      Follow.create!(actor: @actor, target: @target)
    end
  end
end
