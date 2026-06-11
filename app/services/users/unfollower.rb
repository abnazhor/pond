module Users
  class Unfollower
    def initialize(actor:, target:)
      @actor = actor
      @target = target
    end

    def call
      Follow.find_by!(actor: @actor, target: @target).destroy!
    end
  end
end
