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
  factory :other_user2, class: User  do
    name { 'other_sample_name2' }
    email { 'other_sample2@mail.com' }
    password { 'osampleosample2' }
    password_confirmation { 'osampleosample2' }
    id { 80 }
  end
  factory :other_user3, class: User  do
    name { 'other_sample_name3' }
    email { 'other_sample3@mail.com' }
    password { 'osampleosample3' }
    password_confirmation { 'osampleosample3' }
    id { 70 }
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
  factory :task_other_usertest2, class: Task do
    name { 'Factoryで作ったデフォルトのタイトル3' }
    description { 'Factoryで作ったデフォルトのコンテント3' }
    deadline { '2019-10-03' }
    status { '完了' }
    priority { 1 }
    user_id  { 80 }
  end
  factory :task_other_usertest3, class: Task do
    name { 'Factoryで作ったデフォルトのタイトル4' }
    description { 'Factoryで作ったデフォルトのコンテント4' }
    deadline { '2019-10-03' }
    status { '完了' }
    priority { 1 }
    user_id  { 70 }
  end
end
