require 'rails_helper'

RSpec.describe Stakeholders::Individual, type: :model do
  let(:account) { create(:account) }

  describe 'name synchronization with first_name and last_name' do
    context 'when creating a new individual stakeholder' do
      it 'sets name from first_name and last_name' do
        individual = account.stakeholders.build(
          type: 'Stakeholders::Individual',
          first_name: 'John',
          last_name: 'Doe',
          stakeholder_type: 'customer'
        )

        individual.save!

        expect(individual.name).to eq('John Doe')
      end
    end

    context 'when updating an existing individual stakeholder' do
      let!(:individual) do
        account.stakeholders.create!(
          type: 'Stakeholders::Individual',
          first_name: 'John',
          last_name: 'Doe',
          stakeholder_type: 'customer'
        )
      end

      it 'updates name when first_name changes' do
        individual.update!(first_name: 'Jane')

        expect(individual.reload.name).to eq('Jane Doe')
      end

      it 'updates name when last_name changes' do
        individual.update!(last_name: 'Smith')

        expect(individual.reload.name).to eq('John Smith')
      end

      it 'updates name when both first_name and last_name change' do
        individual.update!(first_name: 'Jane', last_name: 'Smith')

        expect(individual.reload.name).to eq('Jane Smith')
      end
    end

    context 'when updating other attributes' do
      let!(:individual) do
        account.stakeholders.create!(
          type: 'Stakeholders::Individual',
          first_name: 'John',
          last_name: 'Doe',
          stakeholder_type: 'customer'
        )
      end

      it 'still synchronizes name when updating email' do
        individual.update!(email: 'john.doe@example.com')

        expect(individual.reload.name).to eq('John Doe')
      end

      it 'still synchronizes name when updating job_title' do
        individual.update!(job_title: 'Manager')

        expect(individual.reload.name).to eq('John Doe')
      end
    end

    context 'edge cases' do
      it 'handles names with special characters' do
        individual = account.stakeholders.build(
          type: 'Stakeholders::Individual',
          first_name: "Jean-Luc",
          last_name: "O'Connor",
          stakeholder_type: 'customer'
        )

        individual.save!

        expect(individual.name).to eq("Jean-Luc O'Connor")
      end

      it 'handles unicode characters' do
        individual = account.stakeholders.build(
          type: 'Stakeholders::Individual',
          first_name: "José",
          last_name: "Müller",
          stakeholder_type: 'customer'
        )

        individual.save!

        expect(individual.name).to eq("José Müller")
      end

      it 'handles very long names' do
        long_first_name = 'A' * 40  # Reduced to fit within validation limits
        long_last_name = 'B' * 40

        individual = account.stakeholders.build(
          type: 'Stakeholders::Individual',
          first_name: long_first_name,
          last_name: long_last_name,
          stakeholder_type: 'customer'
        )

        individual.save!

        expect(individual.name).to eq("#{long_first_name} #{long_last_name}")
      end
    end
  end

  describe 'full_name method' do
    let(:individual) do
      account.stakeholders.build(
        type: 'Stakeholders::Individual',
        first_name: 'John',
        last_name: 'Doe',
        stakeholder_type: 'customer'
      )
    end

    it 'returns the concatenated first and last name' do
      expect(individual.full_name).to eq('John Doe')
    end

    it 'handles missing first_name' do
      individual.first_name = nil
      expect(individual.full_name).to eq('Doe')
    end

    it 'handles missing last_name' do
      individual.last_name = nil
      expect(individual.full_name).to eq('John')
    end

    it 'strips whitespace correctly' do
      individual.first_name = '  John  '
      individual.last_name = '  Doe  '
      # The full_name method uses strip on the concatenated result
      expect(individual.full_name).to eq('John     Doe')
    end
  end
end
