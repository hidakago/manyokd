FactoryBot.define do
  factory :user do
    name { 'sample_name' }
    email { 'sample@mail.com' }
    password { 'samplesample' }
    password_confirmation { 'samplesample' }
    id { 100 }
  end
  factory :other_user, class: User  do
    name { 'other_sample_name' }
    email { 'other_sample@mail.com' }
    password { 'osampleosample' }
    password_confirmation { 'osampleosample' }
    id { 90 }
  end
  factory :task_usertest, class: Task do
    name { 'Factoryで作ったデフォルトのタイトル１' }
    description { 'Factoryで作ったデフォルトのコンテント１' }
    deadline { '2019-10-02' }
    status { '完了' }
    priority { 0 }
    user_id  { 100 }
  end
  factory :task_other_usertest, class: Task do
    name { 'Factoryで作ったデフォルトのタイトル2' }
    description { 'Factoryで作ったデフォルトのコンテント2' }
    deadline { '2019-10-03' }
    status { '完了' }
    priority { 1 }
    user_id  { 90 }
  end
end
