# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GlobalRegistry::Bindings::Workers::DeleteEntityWorker, :type => :job do
  context 'entity 22527d88-3cba-11e7-b876-129bd0521531' do
    context 'valid global_registry_id' do
      let!(:request) do
        stub_request(:delete, 'https://backend.global-registry.org/entities/22527d88-3cba-11e7-b876-129bd0521531')
          .to_return(status: 200)
      end

      it 'should delete the entity' do
        worker = GlobalRegistry::Bindings::Workers::DeleteEntityWorker.new
        worker.perform('22527d88-3cba-11e7-b876-129bd0521531')
        expect(request).to have_been_requested.once
      end
    end

    context 'unknown global_registry_id' do
      let!(:request) do
        stub_request(:delete, 'https://backend.global-registry.org/entities/22527d88-3cba-11e7-b876-129bd0521531')
          .to_return(status: 404)
      end

      it 'should delete the entity' do
        worker = GlobalRegistry::Bindings::Workers::DeleteEntityWorker.new
        worker.perform('22527d88-3cba-11e7-b876-129bd0521531')
        expect(request).to have_been_requested.once
      end
    end
  end

  describe 'configure' do
    context 'custom activejob queue' do
      include WithQueueDefinition

      it 'should contain global custom queue' do
        expect(GlobalRegistry::Bindings.activejob_options).to be_a(Hash).and eq({ queue: :default })
        expect{
          GlobalRegistry::Bindings::Workers::DeleteEntityWorker.perform_job({}, 'abcd')
        }.to have_enqueued_job.with{ |*queued_params|
          expect(queued_params).to eq(['abcd'])
        }
      end
    end
  end

end
