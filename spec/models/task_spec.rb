# frozen_string_literal: true

RSpec.describe Task, type: :model do
  let(:task) { FactoryBot.create(:task) }

  context 'validations' do
    it { expect(task).to validate_presence_of(:name) }
  end

  context 'relations' do
    it { expect(task).to belong_to(:project) }
  end

  context 'db_table' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end
end
