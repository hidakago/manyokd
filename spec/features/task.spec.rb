# このrequireで、Capybaraなどの、Feature Specに必要な機能を使用可能な状態にしています
require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "タスク管理機能", type: :feature do
  # scenario（itのalias）の中に、確認したい各項目のテストの処理を書きます。
  scenario "タスク一覧のテストOKパターン" do
    # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
    Task.create!(name: 'task_name_01', description: 'test01testtest')
    Task.create!(name: 'test_name_02', description: 'sample02sample')

    # tasks_pathにvisitする（タスク一覧ページに遷移する）
    visit tasks_path

    # visitした（到着した）expect(page)に（タスク一覧ページに）「test01testtest」「sample02sample」という文字列が
    # have_contentされているか？（含まれているか？）ということをexpectする（確認・期待する）テストを書いている
    expect(page).to have_content 'test01testtest'
    expect(page).to have_content 'sample02sample'
    # visitした（到着した）expect(page)に（タスク一覧ページに）「testtesttest」「samplesample」という文字列が
    # have_contentされていない（含まれていない）ということをexpectする（確認・期待する）テストを書いている
    expect(page).not_to have_content 'testtesttest'
    expect(page).not_to have_content 'samplesample'

  end

  scenario "タスク作成のテスト" do
    # new_task_pathにvisitする（タスク登録ページに遷移する）
    # 1.ここにnew_task_pathにvisitする処理を書く
    visit new_task_path

    # 「タスク名」というラベル名の入力欄と、「タスク詳細」というラベル名の入力欄に
    # タスクのタイトルと内容をそれぞれfill_in（入力）する
    # 2.ここに「タスク名」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
    # 3.ここに「タスク詳細」というラベル名の入力欄に内容をfill_in（入力）する処理を書く
    fill_in 'タスク名', with: 'テスト用のタスク名です'
    fill_in '詳細', with: 'Rspecのテストコードを作成すること'

    # 「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）
    # 4.「登録する」というvalue（表記文字）のあるボタンをclick_onする（クリックする）する処理を書く
    click_on 'Create Task'

    # clickで登録されたはずの情報が、タスク詳細ページに表示されているかを確認する
    # （タスクが登録されたらタスク詳細画面に遷移されるという前提）
    # 5.タスク詳細ページに、テストコードで作成したはずのデータ（記述）がhave_contentされているか（含まれているか）を確認（期待）するコードを書く
    visit tasks_path

    expect(page).to have_content 'テスト用のタスク名です'
    expect(page).to have_content 'Rspecのテストコードを作成すること'
    expect(page).not_to have_content '本番用のタスク名です'

  end

  scenario "タスク詳細のテスト" do
    # 「任意のタスク詳細画面に遷移したら、該当タスクの内容が表示されたページに遷移する」ことをテストで証明しましょう。
    task = Task.create!(name: 'task_name_06', description: 'test06testtest')

    visit task_path(task.id)

    save_and_open_page

    expect(page).to have_content 'task_name_06'
    expect(page).to have_content 'test06testtest'

    expect(page).not_to have_content 'task_name_07'
    expect(page).not_to have_content 'test07testtest'
  end
end
