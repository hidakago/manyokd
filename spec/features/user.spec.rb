require 'rails_helper'

# このRSpec.featureの右側に、「タスク管理機能」のように、テスト項目の名称を書きます（do ~ endでグループ化されています）
RSpec.feature "ユーザ登録機能とログイン機能のテスト", type: :feature do
  background do
    FactoryBot.create(:user)
    FactoryBot.create(:task_usertest)
    FactoryBot.create(:other_user)
    FactoryBot.create(:task_other_usertest)
    FactoryBot.create(:other_user2)
    FactoryBot.create(:other_user3)

    FactoryBot.create(:task_other_usertest2, name: 'task_name_01', description: 'test01testtest', deadline: '2019-10-05', status: "完了", priority: 1)
    FactoryBot.create(:task_other_usertest2, name: 'task_name_02', description: 'sample02sample', deadline: '2019-10-01', status: "未着手", priority: 2)

    FactoryBot.create(:task_other_usertest3, name: 'task_name_08', description: 'test08testtest', deadline: '2019-10-07', status: "未着手", priority: 1)
    FactoryBot.create(:task_other_usertest3, name: 'task_name_09', description: 'sample09sample', deadline: '2019-10-02', status: "着手中", priority: 0)
    FactoryBot.create(:task_other_usertest3, name: 'task_name_10', description: 'sample10sample', deadline: '2019-10-02', status: "着手中", priority: 0)
  end
  scenario "ユーザ登録のテスト" do

    visit new_user_path

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    # ログインできたら、ユーザー情報画面へ遷移
    visit user_path(1)
# save_and_open_page

    # ユーザー情報を表示しているかどうか確認
    expect(page).to have_content 'test'
    expect(page).to have_content 'test@mail.com'
  end

  scenario "ユーザ登録エラーのテスト1" do

    visit new_user_path

    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    expect(page).to have_content '名前を入力してください'
  end
  scenario "ユーザ登録エラーのテスト1" do

    visit new_user_path

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    expect(page).to have_content 'メールアドレスを入力してください'
  end
  scenario "ユーザ登録エラーのテスト3" do

    visit new_user_path

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: ''
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    expect(page).to have_content 'パスワードを入力してください'
  end
  scenario "ユーザ登録エラーのテスト4" do

    visit new_user_path

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: ''

    click_on '登録する'

    expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'

    # save_and_open_page
  end

# ログインしていないのにタスクのページに飛ぼうとした場合は、ログインページに遷移させましょう

  scenario "ログインしていないのにタスクのページに飛ぼうとした場合は、ログインページに遷移する確認テスト" do

    visit tasks_path

    # ログイン画面に遷移していればOK
    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'メールアドレス'
    expect(page).to have_content 'パスワード'

    # save_and_open_page
  end

  scenario "ログイン画面のテスト" do

    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    # ユーザー情報画面に遷移していればOK
    visit user_path(100)

    # # ユーザー情報を表示しているかどうか確認
    expect(page).to have_content 'sample'
    expect(page).to have_content 'sample@mail.com'
  end

  scenario "ログインしたら、自分が作成したタスクだけを表示しているかどうかのテスト" do

    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    # ユーザー情報画面に遷移
    visit user_path(100)

    # ユーザー情報を表示しているかどうか確認
    expect(page).to have_content 'sample'
    expect(page).to have_content 'sample@mail.com'

    # タスク一覧に遷移
    visit tasks_path

    # ユーザーが作成したタスクのみ表示しているかどうか確認
    expect(page).to have_content 'Factoryで作ったデフォルトのタイトル１'
    expect(page).to have_content 'Factoryで作ったデフォルトのコンテント１'
    expect(page).not_to have_content 'Factoryで作ったデフォルトのタイトル2'
    expect(page).not_to have_content 'Factoryで作ったデフォルトのコンテント2'
  end
  scenario "自分以外のユーザのマイページに行こうとしても、自分のマイページしか行けないどうかのテスト" do

    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    # ユーザー情報画面に遷移
    visit user_path(100)

    # ユーザー情報を表示しているかどうか確認
    expect(page).to have_content 'sample'
    expect(page).to have_content 'sample@mail.com'

    # 自分以外のユーザー情報画面に遷移しようとする
    visit user_path(90)

    # 自分以外のユーザー情報画面に遷移せずに、自分のユーザー情報のみ表示しているか確認
    expect(page).to have_content 'sample'
    expect(page).to have_content 'sample@mail.com'
    expect(page).not_to have_content 'other_sample_name'
    expect(page).not_to have_content 'other_sample@mail.com'

    # save_and_open_page
  end
  scenario "ログアウト機能のテスト" do

    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    # ユーザー情報画面に遷移
    visit user_path(100)

    # ユーザー情報を表示しているかどうか確認
    expect(page).to have_content 'sample'
    expect(page).to have_content 'sample@mail.com'

    # ここでログアウト実行
    click_link 'ログアウト'

    # ログイン画面に遷移しているはず

    # ログアウトした旨のメッセージ表示
    expect(page).to have_content 'ログアウトしました'

    # ログインしてないのにタスク一覧へ遷移しようとする
    visit tasks_path

    # ログイン画面に遷移していればOK
    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'メールアドレス'
    expect(page).to have_content 'パスワード'
    # save_and_open_page
  end
  scenario "ユーザ管理画面の表示テスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    user = all('.task_list')

    user_count = user.count

    expect(user_count).to eq 4
    expect(user[0]).to have_content 'sample_name'
    expect(user[1]).to have_content 'other_sample_name'
    expect(user[2]).to have_content 'other_sample_name2'
    expect(user[3]).to have_content 'other_sample_name3'
  end
  scenario "ユーザ登録画面の表示テスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ登録画面へ
    visit new_admin_user_path

    # ユーザ登録画面かどうか確認
    expect(page).to have_content 'ユーザー登録'

  end
  scenario "ユーザ登録画面の登録OKテスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ登録画面へ
    click_link 'ユーザー登録'

    # ユーザ登録画面かどうか確認
    expect(page).to have_content 'ユーザー登録'

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    user = all('.task_list')

    user_count = user.count

    expect(user_count).to eq 5
    expect(user[0]).to have_content 'sample_name'
    expect(user[1]).to have_content 'other_sample_name'
    expect(user[2]).to have_content 'other_sample_name2'
    expect(user[3]).to have_content 'other_sample_name3'
    expect(user[4]).to have_content 'test@mail.com'
# save_and_open_page
  end
  scenario "ユーザ登録画面の登録エラーテスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ登録画面へ
    click_link 'ユーザー登録'

    # ユーザ登録画面かどうか確認
    expect(page).to have_content 'ユーザー登録'

    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '登録する'

    expect(page).to have_content '名前を入力してください'
# save_and_open_page
  end
  scenario "ユーザ情報更新画面の表示テスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ更新画面へ
    visit edit_admin_user_path(100)

    # ユーザ登録画面かどうか確認
    expect(page).to have_content 'ユーザー情報更新'
  end
  scenario "ユーザ情報更新画面の入力OKテスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ更新画面へ
    visit edit_admin_user_path(100)

    fill_in '名前', with: 'test'
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '更新する'

    user = all('.task_list')

    user_count = user.count

    expect(user_count).to eq 4
    expect(user[0]).to have_content 'other_sample_name'
    expect(user[1]).to have_content 'other_sample_name2'
    expect(user[2]).to have_content 'other_sample_name3'
    expect(user[3]).to have_content 'test'
  end
  scenario "ユーザ情報更新画面の入力NGテスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ更新画面へ
    visit edit_admin_user_path(100)

    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: 'test@mail.com'
    fill_in 'パスワード', with: 'testtesttest'
    fill_in '確認用パスワード', with: 'testtesttest'

    click_on '更新する'

    expect(page).to have_content '名前を入力してください'
  end
  scenario "ユーザタスク情報画面の表示テスト" do
    visit new_session_path

    fill_in 'メールアドレス', with: 'sample@mail.com'
    fill_in 'パスワード', with: 'samplesample'

    click_on 'ログイン'

    #ユーザ管理画面へ
    visit admin_users_path

    #ユーザ更新画面へ
    visit admin_user_path(100)

    # ユーザ登録画面かどうか確認
    expect(page).to have_content 'ユーザータスク情報'

    user = all('.task_list')

    user_count = user.count

    expect(user_count).to eq 1
    expect(user[0]).to have_content 'Factoryで作ったデフォルトのタイトル１'
    expect(user[0]).to have_content 'Factoryで作ったデフォルトのコンテント１'
    expect(user[0]).to have_content '2019-10-02'
  end
end
