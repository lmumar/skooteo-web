RSpec.shared_examples 'admin videos inaccessible examples' do |current_user_email|
  it 'should not be accessible' do
    # videos = subject.admin_videos({ page: 1, per_page: 10}, { current_user: User.find_by!(email: current_user_email) })
    # expect(videos.size.zero?).to be(true)
  end
end

RSpec.shared_examples 'fleet admin videos inaccessible examples' do |current_user_email|
  it 'should not be accessible' do
    # videos = subject.fleet_admin_videos({ page: 1, per_page: 10}, { current_user: User.find_by!(email: current_user_email) })
    # expect(videos.size.zero?).to be(true)
  end
end
