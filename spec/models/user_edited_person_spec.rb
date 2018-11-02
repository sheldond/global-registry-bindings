# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Namespaced::Person::UserEdited do
  include WithQueueDefinition

  describe '#pull_mdm_id_from_global_registry_async' do
    it 'should enqueue sidekiq job' do
      user_edited = build(:user_edited)
      expect do
        user_edited.pull_mdm_id_from_global_registry_async
      end.to(have_enqueued_job(GlobalRegistry::Bindings::Workers::PullNamespacedPersonMdmIdWorker)
      .with do |*queued_params|
        expect(queued_params).to eq ['Namespaced::Person::UserEdited', nil]
      end)
    end
  end
end
