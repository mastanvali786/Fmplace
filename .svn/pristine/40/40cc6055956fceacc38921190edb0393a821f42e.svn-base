class ProjectStateMachine
  include Statesman::Machine

  def initial_state
    :opened
  end

  state :opened, initial: true
  state :closed
  state :awarded
  state :completed
  state :archived

  event :award do
    transition from: :opened, to: :awarded
  end

  event :close do
    transition from: :opened, to: :closed
  end

  event :reopen do
    transition from: :closed, to: :opened
  end

  event :complete do
    transition from: :awarded, to: :completed
  end

  event :decline do
    transition from: :awarded, to: :opened
  end

  event :archive do
    transition from: :completed, to: :archived
  end
end