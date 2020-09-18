require "rails_helper"

RSpec.describe Project, type: :model do
  let(:project) { FactoryBot.create(:project) }

  context 'validations' do
    it { expect(project).to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'relations' do
    it { expect(project).to belong_to(:user) }
  end

  context 'db_table' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end
end