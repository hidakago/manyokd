require 'rails_helper'

RSpec.describe Task, type: :model do

  it "nameが空ならバリデーションが通らない" do
    task = Task.new(name: '', description: '失敗テスト', deadline: '2019-10-19')
    expect(task).not_to be_valid
  end

  it "nameに内容が記載されていればバリデーションが通る" do
    task = Task.new(name: 'テスト', description: '成功テスト', deadline: '2019-10-19')
    expect(task).to be_valid
  end

  it "deadlineが'0000-00-00'ならバリデーションが通らない" do
    task = Task.new(name: 'テスト3', description: '失敗テスト', deadline: '0000-00-00')
    expect(task).not_to be_valid
  end

  it "deadlineが'0000-00-00'でないならバリデーションが通る" do
    task = Task.new(name: 'テスト4', description: '成功テスト', deadline: '2019-10-19')
    expect(task).to be_valid
  end

  it "nameが空、かつdeadlineが'0000-00-00'ならバリデーションが通らない" do
    task = Task.new(name: '', description: '失敗テスト', deadline: '0000-00-00')
    expect(task).not_to be_valid
  end

end
