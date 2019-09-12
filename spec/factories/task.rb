FactoryBot.define do

  # 作成するテストデータの名前を「task」とします
  # （実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを自動で作成します）
  factory :task do
    name { 'Factoryで作ったデフォルトのタイトル１' }
    description { 'Factoryで作ったデフォルトのコンテント１' }
  end

  # 作成するテストデータの名前を「second_task」とします
  # （存在しないクラス名の名前をつける場合、オプションで「このクラスのテストデータにしてください」と指定します）
  factory :second_task, class: Task do
    name { 'Factoryで作ったデフォルトのタイトル２' }
    description { 'Factoryで作ったデフォルトのコンテント２' }
  end

  factory :first_order_task, class: Task do
    name { '最初に作成したタスク名first_order_task_name' }
    description { '最初に作成したタスク詳細first_order_task_description' }
  end

  factory :last_order_task, class: Task do
    name { '最後に作成したタスク名last_order_task_name' }
    description { '最後に作成したタスク詳細last_order_task_description' }
  end
end
