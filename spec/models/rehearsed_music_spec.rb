require 'rails_helper'

RSpec.describe RehearsedMusic, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:practice_session) }
    it { is_expected.to belong_to(:music) }
  end
end
