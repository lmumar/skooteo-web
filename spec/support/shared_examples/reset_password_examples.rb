RSpec.shared_examples 'password reset should fail' do |oldpass, newpass|
  it 'should not reset password' do
    service = subject.call(oldpass, newpass)
    expect { service.call }.to raise_error(Skooteo::PasswordResetFailed)
  end
end
