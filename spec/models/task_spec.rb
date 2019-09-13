require 'rails_helper'

RSpec.describe Task, type: :model do

  it "nameが空ならバリデーションが通らない" do
    task = Task.new(name: '', description: '失敗テスト')
    expect(task).not_to be_valid
  end

  it "nameに内容が記載されていればバリデーションが通る" do
    task = Task.new(name: 'テスト', description: '成功テスト')
    expect(task).to be_valid
  end
end
