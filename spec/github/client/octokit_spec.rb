require 'rails_helper'

RSpec.describe GitHub::Client::Octokit do
  let(:octokit_client) { double(Octokit::Client) }
  let(:user) { stub_model(User, octokit_client: octokit_client) }
  let(:client) { described_class.new }

  describe '#create_deployment' do
    context 'when there are no previous deployments to the environment' do
      it 'creates the github deployment' do
        req = DeploymentRequest.new(
          repository: 'remind101/acme-inc',
          ref: 'master',
          environment: 'production'
        )

        github_deployment = double(
          'GitHub Deployment',
          id: 1,
          ref: 'master',
          environment: 'production',
          sha: '52bea69fa54a0ad7a4bdb305380ef43a'
        )
        expect(octokit_client).to receive(:create_deployment).with(
          'remind101/acme-inc',
          'master',
          environment: 'production',
          task: 'deploy',
          auto_merge: false
        ).and_return(github_deployment)
        expect(octokit_client).to receive(:deployments).with(
          'remind101/acme-inc',
          environment: 'production'
        ).and_return([])

        resp = client.create_deployment user, req
        expect(resp.deployment.id).to eq 1
        expect(resp.last_deployment).to be_nil
      end
    end

    context 'when there are previous deployments to the environment' do
      it 'creates the github deployment' do
        req = DeploymentRequest.new(
          repository: 'remind101/acme-inc',
          ref: 'master',
          environment: 'production'
        )

        last_github_deployment = double(
          'GitHub Deployment',
          id: 1,
          ref: 'master',
          environment: 'production',
          sha: 'ef892c97230add9a1250ec7e1d71b362'
        )
        github_deployment = double(
          'GitHub Deployment',
          id: 2,
          ref: 'master',
          environment: 'production',
          sha: '52bea69fa54a0ad7a4bdb305380ef43a'
        )
        expect(octokit_client).to receive(:create_deployment).with(
          'remind101/acme-inc',
          'master',
          environment: 'production',
          task: 'deploy',
          auto_merge: false
        ).and_return(github_deployment)
        expect(octokit_client).to receive(:deployments).with(
          'remind101/acme-inc',
          environment: 'production'
        ).and_return([last_github_deployment])

        resp = client.create_deployment user, req
        expect(resp.deployment.id).to eq 2
        expect(resp.last_deployment.id).to eq 1
      end
    end

    context 'when the commit has failing commit statuses' do
      it 'raises an exception' do
        req = DeploymentRequest.new(
          repository: 'remind101/acme-inc',
          ref: 'master',
          environment: 'production'
        )

        conflict = Octokit::Conflict.new(
          method: 'POST',
          status: 409,
          body: {
            errors: [{
              contexts: [
                { context: 'ci/circleci', state: 'success' },
                { context: 'container/docker', state: 'failure' }
              ],
              resource: 'Deployment',
              field: 'required_contexts',
              code: 'invalid'
            }]
          }
        )
        allow(octokit_client).to receive(:deployments).and_return([])
        expect(octokit_client).to receive(:create_deployment).and_raise(conflict)
        expect do
          begin
            client.create_deployment user, req
          rescue GitHub::RedCommitError => e
            expect(e.contexts).to eq [
              CommitStatusContext.new(context: 'ci/circleci', state: 'success'),
              CommitStatusContext.new(context: 'container/docker', state: 'failure')
            ]
            raise
          end
        end.to raise_error GitHub::RedCommitError
      end
    end
  end

  describe '#access?' do
    context 'when the user has access to the deployments of the repo' do
      it 'returns true' do
        expect(octokit_client).to receive(:deployments).with('remind101/acme-inc', sha: '1')
        expect(client.access? user, 'remind101/acme-inc').to be_truthy
      end
    end

    context 'when the user does not have access to the deployments of the repo' do
      it 'returns false' do
        expect(octokit_client).to receive(:deployments).with('remind101/acme-inc', sha: '1').and_raise(
          Octokit::NotFound.new
        )
        expect(client.access? user, 'remind101/acme-inc').to be_falsey
      end
    end
  end
end