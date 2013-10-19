module SimpleParser
  class StateMachine
    class NoStateError < StandardError; end

    class << self
      def transitions
        @transitions ||= []
      end

      def before_transition(name, states, options={})
        transitions << [name, Array(states), options]
      end
    end

    def state
      raise NoStateError unless @state
      @state
    end

    def transition(new_state)
      self.class.transitions.each do |callback, callback_states, options|
        if callback_states.include?(new_state)
          if !options[:from] || options[:from].include?(state)
            self.send("#{callback}".to_sym)
          end
        end
      end

      @state = new_state
    end

  end
end