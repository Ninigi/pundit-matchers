require 'rspec/core'

module Pundit
  module Matchers
    RSpec::Matchers.define :forbid_action do |action, *args|
      match do |policy|
        if args.any?
          !policy.public_send("#{action}?", *args)
        else
          !policy.public_send("#{action}?")
        end
      end

      failure_message do |policy|
        "#{policy.class} does not forbid #{action} on #{policy.record} for " \
          "#{policy.user.inspect}."
      end

      failure_message_when_negated do |policy|
        "#{policy.class} does not permit #{action} on #{policy.record} for " \
          "#{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_actions do |actions|
    match do |policy|
      return false if actions.count < 2
      actions.each do |action|
        return false if policy.public_send("#{action}?")
      end
      true
    end

    zero_actions_failure_message = 'At least two actions must be ' \
      'specified when using the forbid_actions matcher.'

    one_action_failure_message = 'More than one action must be specified ' \
      'when using the forbid_actions matcher. To test a single action, use ' \
      'forbid_action instead.'

    failure_message do |policy|
      case actions.count
      when 0
        zero_actions_failure_message
      when 1
        one_action_failure_message
      else
        "#{policy.class} does not forbid #{actions} on #{policy.record} " \
          "for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      case actions.count
      when 0
        zero_actions_failure_message
      when 1
        one_action_failure_message
      else
        "#{policy.class} does not permit #{actions} on #{policy.record} " \
          "for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_edit_and_update_actions do
    match do |policy|
      !policy.edit? && !policy.update?
    end

    failure_message do |policy|
      "#{policy.class} does not forbid the edit or update action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not permit the edit or update action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :forbid_mass_assignment_of do |attribute|
    match do |policy|
      if defined? @action
        !policy.send("permitted_attributes_for_#{@action}").include? attribute
      else
        !policy.permitted_attributes.include? attribute
      end
    end

    chain :for_action do |action|
      @action = action
    end

    failure_message do |policy|
      if defined? @action
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if defined? @action
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :forbid_new_and_create_actions do
    match do |policy|
      !policy.new? && !policy.create?
    end

    failure_message do |policy|
      "#{policy.class} does not forbid the new or create action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not permit the new or create action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_action do |action, *args|
    match do |policy|
      if args.any?
        policy.public_send("#{action}?", *args)
      else
        policy.public_send("#{action}?")
      end
    end

    failure_message do |policy|
      "#{policy.class} does not permit #{action} on #{policy.record} for " \
        "#{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid #{action} on #{policy.record} for " \
        "#{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_actions do |actions|
    match do |policy|
      return false if actions.count < 2
      actions.each do |action|
        return false unless policy.public_send("#{action}?")
      end
      true
    end

    zero_actions_failure_message = 'At least two actions must be ' \
      'specified when using the permit_actions matcher.'

    one_action_failure_message = 'More than one action must be specified ' \
      'when using the permit_actions matcher. To test a single action, use ' \
      'permit_action instead.'

    failure_message do |policy|
      case actions.count
      when 0
        zero_actions_failure_message
      when 1
        one_action_failure_message
      else
        "#{policy.class} does not permit #{actions} on #{policy.record} " \
          "for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      case actions.count
      when 0
        zero_actions_failure_message
      when 1
        one_action_failure_message
      else
        "#{policy.class} does not forbid #{actions} on #{policy.record} " \
          "for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_edit_and_update_actions do
    match do |policy|
      policy.edit? && policy.update?
    end

    failure_message do |policy|
      "#{policy.class} does not permit the edit or update action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid the edit or update action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end
  end

  RSpec::Matchers.define :permit_mass_assignment_of do |attribute|
    match do |policy|
      if defined? @action
        policy.send("permitted_attributes_for_#{@action}").include? attribute
      else
        policy.permitted_attributes.include? attribute
      end
    end

    chain :for_action do |action|
      @action = action
    end

    failure_message do |policy|
      if defined? @action
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not permit the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end

    failure_message_when_negated do |policy|
      if defined? @action
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute, when authorising the #{@action} action, " \
          "for #{policy.user.inspect}."
      else
        "#{policy.class} does not forbid the mass assignment of the " \
          "#{attribute} attribute for #{policy.user.inspect}."
      end
    end
  end

  RSpec::Matchers.define :permit_new_and_create_actions do
    match do |policy|
      policy.new? && policy.create?
    end

    failure_message do |policy|
      "#{policy.class} does not permit the new or create action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end

    failure_message_when_negated do |policy|
      "#{policy.class} does not forbid the new or create action on " \
        "#{policy.record} for #{policy.user.inspect}."
    end
  end
end

if defined?(Pundit)
  RSpec.configure do |config|
    config.include Pundit::Matchers
  end
end
