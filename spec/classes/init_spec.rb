require 'spec_helper'
describe 'shinken' do
  context 'with default values for all parameters' do
    it { should contain_class('shinken') }
  end
end
