# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:login_user)
    FactoryBot.create(:first_order_task, deadline: '2019-10-02', status: "完了", priority: 0, user_id: 100)
    FactoryBot.create(:task, name: 'task_name_01', description: 'test01testtest', deadline: '2019-10-05', status: "完了", priority: 1, user_id: 100)
    FactoryBot.create(:task, name: 'task_name_02', description: 'sample02sample', deadline: '2019-10-01', status: "未着手", priority: 2, user_id: 100)
    FactoryBot.create(:task, name: 'task_name_08', description: 'test08testtest', deadline: '2019-10-07', status: "未着手", priority: 1, user_id: 100)
    FactoryBot.create(:task, name: 'task_name_09', description: 'sample09sample', deadline: '2019-10-02', status: "着手中", priority: 0, user_id: 100)
    FactoryBot.create(:second_task, deadline: '2019-10-02', status: "未着手", priority: 1, user_id: 100)
    FactoryBot.create(:last_order_task, deadline: '2019-10-06', status: "着手中", priority: 2, user_id: 100)

    #ログイン実行
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

  end
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテスト" do
    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path

    task = all('.task_list')

    task_count = task.count

    # visitした（到着した）expect(page)に（タスク一覧ページに）「test01testtest」「sample02sample」という文字列が
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
    expect(page).to have_content 'test01testtest'
    expect(page).to have_content 'sample02sample'
    expect(page).to have_content '高'
    expect(page).to have_content '中'
    expect(page).to have_content '低'

    expect(task[0]).to have_content '低'
    expect(task[task_count - 1]).to have_content '中'

    # visitした（到着した）expect(page)に（タスク一覧ページに）「testtesttest」「samplesample」という文字列が
    # have_contentされていない（含まれていない）ということをexpectする（確認・期待する）テストを書いている
    expect(page).not_to have_content 'testtesttest'
    expect(page).not_to have_content 'samplesample'
    expect(page).not_to have_content '松'
    expect(page).not_to have_content '竹'
    expect(page).not_to have_content '梅'

    expect(task[0]).not_to have_content '梅'
    expect(task[task_count - 1]).not_to have_content '松'
  end

  scenario "タスク作成のテスト", js: true do
    # new_task_pathにvisitする（タスク登録ページに遷移する）
    # 1.ここにnew_task_pathにvisitする処理を書く
    visit new_task_path

    # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
    # タスクのタイトルと内容をそれぞれfill_in（入力）する
    # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
    # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
    fill_in 'タスク名', with: 'テスト用のタスク名です'
    fill_in 'タスク説明', with: 'Rspecのテストコードを作成すること'
    # 「終了期限」内容をセット
    page.execute_script("$('#datepicker').val('2019-10-08')")
    # 「進捗状況」内容をセット
    select '完了', from: '進捗状況'

    select '高', from: '優先順位'

    # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
    # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
    click_on '登録する'

    # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
    # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
    # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    visit tasks_path

    expect(page).not_to have_content 'テスト用のタスク名です'
    expect(page).not_to have_content 'Rspecのテストコードを作成すること'
    expect(page).not_to have_content '2019-10-08'
    expect(page).to have_content 'task_name_08'
    expect(page).to have_content 'test08testtest'
  end

  scenario "タスク詳細のテスト" do
    # 「任意のタスク詳細画面に遷移したら、該当タスクの内容が表示されたページに遷移する」ことをテストで証明しましょう。
    task = Task.create!(name: 'task_name_06', description: 'test06testtest', deadline: '2019-10-02', status: "着手中", priority: 1)

    visit task_path(task.id)

    expect(page).to have_content 'task_name_06'
    expect(page).to have_content 'test06testtest'
    expect(page).to have_content '2019-10-02'
    expect(page).to have_content '着手中'
    expect(page).to have_content '中'

    expect(page).not_to have_content 'task_name_07'
    expect(page).not_to have_content 'test07testtest'
    expect(page).not_to have_content '2019-10-03'
    expect(page).not_to have_content '完了'
    expect(page).not_to have_content '竹'
  end

  scenario "タスクが作成日時の降順に並んでいるかのテスト" do

    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path

    # この時点でのタスクのリストを取得。
    # この時点では作成日時が一番古いタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番古いタスクであることを証明
    expect(task_0).to have_content "最初に作成したタスク名first_order_task_name"
    # リストの一番先頭の行が、作成日時が一番新しいタスクでないことを証明
    expect(task_0).not_to have_content "最後に作成したタスク名last_order_task_name"

    # "作成日時で降順"リンクをクリックする
    click_link 'order_change'

    # この時点でのタスクのリストを取得。
    # この時点では作成日時が一番新しいタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    expect(task_0).to have_content "最後に作成したタスク名last_order_task_name"
    expect(task_0).not_to have_content "最初に作成したタスク名first_order_task_name"

    # "作成日時で昇順"リンクをクリックする
    click_link 'order_change'

    # この時点でのタスクのリストを取得。
    # この時点では作成日時が一番古いタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番古いタスクであることを証明
    expect(task_0).to have_content "最初に作成したタスク名first_order_task_name"
    # リストの一番先頭の行が、作成日時が一番新しいタスクでないことを証明
    expect(task_0).not_to have_content "最後に作成したタスク名last_order_task_name"
     # save_and_open_page
  end

  scenario "タスクが終了期限の降順に並んでいるかのテスト" do

    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path

    # この時点でのタスクのリストを取得。
    # この時点では作成日時が一番古いタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番古いタスクであることを証明
    expect(task_0).to have_content "最初に作成したタスク名first_order_task_name"
    # リストの一番先頭の行が、作成日時が一番新しいタスクでないことを証明
    expect(task_0).not_to have_content "最後に作成したタスク名last_order_task_name"

    # "終了期限で降順"リンクをクリックする
    click_link 'order_change_deadline'

    # この時点でのタスクのリストを取得。
    # この時点では終了期限が一番新しいタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    # リストの一番先頭の行が、終了期限が一番新しいタスクであることを証明
    expect(task_0).to have_content "2019-10-07"
    # リストの一番先頭の行が、終了期限が一番古いタスクでないことを証明
    expect(task_0).not_to have_content "2019-10-01"

    # "作成日時で降順"リンクをクリックする
    click_link 'order_change'

    # この時点でのタスクのリストを取得。
    # この時点では作成日時が一番古いタスクが一番先頭になっているはず
    task = all('.task_list')

    # リストの一番先頭の行を取得
    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番新しいタスクであることを証明
    expect(task_0).to have_content "最後に作成したタスク名last_order_task_name"
    # リストの一番先頭の行が、作成日時が一番古いタスクでないことを証明
    expect(task_0).not_to have_content "最初に作成したタスク名first_order_task_name"

    # save_and_open_page
  end

  scenario "タスクをタスク名＋進捗状況を指定して検索できるかのテスト" do

    visit tasks_path

    task = all('.task_list')

    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番古いタスクであることを証明
    expect(task_0).to have_content "最初に作成したタスク名first_order_task_name"
    # リストの一番先頭の行が、作成日時が一番新しいタスクでないことを証明
    expect(task_0).not_to have_content "最後に作成したタスク名last_order_task_name"

    # 検索用のタスク名に文字を指定
    fill_in 'search_task_name', with: 'task_name'

    # 検索用の進捗状況を指定
    select '未着手', from: '進捗状況'

    click_on 'search_task'

    tasks = all('.task_list')

    task_count = tasks.count
    expect(task_count).to eq 2

    expect(tasks[0]).to have_content "sample02sample"
    expect(tasks[1]).to have_content "test08testtest"
  end

  scenario "タスクを進捗状況を指定して検索できるかのテスト" do

    visit tasks_path

    task = all('.task_list')

    task_0 = task[0]

    # リストの一番先頭の行が、作成日時が一番古いタスクであることを証明
    expect(task_0).to have_content "最初に作成したタスク名first_order_task_name"
    # リストの一番先頭の行が、作成日時が一番新しいタスクでないことを証明
    expect(task_0).not_to have_content "最後に作成したタスク名last_order_task_name"

    # 検索用のタスク名に文字を指定しない
    fill_in 'search_task_name', with: ''

    # 検索用の進捗状況を指定
    select '完了', from: '進捗状況'

    click_on 'search_task'

    tasks = all('.task_list')

    task_count = tasks.count
    expect(task_count).to eq 2

    expect(tasks[0]).to have_content "最初に作成したタスク詳細first_order_task_description"
    expect(tasks[1]).to have_content "test01testtest"
    # save_and_open_page
  end
break
  scenario "優先順位で高い順にソートして表示できるかのテスト" do
    visit tasks_path

    task = all('.task_list')

    task_0 = task[0]

    expect(task_0).to have_content "低"

    expect(task_0).not_to have_content "高"

    click_link 'order_change_priority'

    task = all('.task_list')

    task_0 = task[0]

    expect(task_0).to have_content "高"

    expect(task_0).not_to have_content "低"

    click_link 'order_change_priority'

    task = all('.task_list')

    task_0 = task[0]

    expect(task_0).to have_content "高"

    expect(task_0).not_to have_content "低"
  end
end
