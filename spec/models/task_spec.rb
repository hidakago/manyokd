require 'rails_helper'

RSpec.describe Task, type: :model do

  it "nameが空ならバリデーションが通らない" do
    task = Task.new(name: '', description: '失敗テスト', deadline: '2019-10-19', status: "完了")
    expect(task).not_to be_valid
  end

  it "nameに内容が記載されていればバリデーションが通る" do
    task = Task.new(name: 'テスト', description: '成功テスト', deadline: '2019-10-19', status: "着手中")
    expect(task).to be_valid
  end

  it "deadlineが'0000-00-00'ならバリデーションが通らない" do
    task = Task.new(name: 'テスト3', description: '失敗テスト', deadline: '0000-00-00', status: "未着手")
    expect(task).not_to be_valid
  end

  it "deadlineが'0000-00-00'でないならバリデーションが通る" do
    task = Task.new(name: 'テスト4', description: '成功テスト', deadline: '2019-10-19', status: "完了")
    expect(task).to be_valid
  end

  it "nameが空、かつdeadlineが'0000-00-00'ならバリデーションが通らない" do
    task = Task.new(name: '', description: '失敗テスト', deadline: '0000-00-00', status: "完了" )
    expect(task).not_to be_valid
  end

  it "nameとstatusを条件とした検索処理のテスト" do
    Task.create(name: 'test01', description: 'テスト01', deadline: '2019-10-01', status: "完了" )
    Task.create(name: 'test02', description: 'テスト02', deadline: '2019-10-02', status: "未着手" )
    Task.create(name: 'test03', description: 'テスト03', deadline: '2019-10-03', status: "完了" )
    Task.create(name: 'test04', description: 'テスト04', deadline: '2019-10-04', status: "着手中" )

    tasks = Task.search('test01', '完了')
    expect(tasks[0].description).to eq "テスト01"

    tasks = Task.search('', '未着手')
    expect(tasks[0].description).to eq "テスト02"

    tasks = Task.search('04', '着手中')
    expect(tasks[0].description).to eq "テスト04"

    tasks = Task.search('', '完了').order(name: "desc")
    expect(tasks.size).to eq 2
    expect(tasks[0].description).to eq "テスト03"
    expect(tasks[1].description).to eq "テスト01"
  end
end
