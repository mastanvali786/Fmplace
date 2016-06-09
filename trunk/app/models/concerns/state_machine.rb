module StateMachine
  extend ActiveSupport::Concern
  module ClassMethods
    def act_like_state_machine
      has_many "#{name.underscore}_transitions".to_sym
      delegate :current_state, :trigger!, :transition_to!,
               to: :state_machine
    end
    def transition_class
      "#{name}Transition".constantize
    end
    def initial_state
      state_machine_klass.initial_state
    end

    def state_machine_klass
      "#{name}StateMachine".constantize
    end
  end

  def state_machine
    return @state_machine if @state_machine
    self.class.state_machine_klass.new(self, transition_class: self.class.transition_class)
  end
end