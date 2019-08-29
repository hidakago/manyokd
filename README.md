### README

**モデル情報**

1. User : ユーザー  
  カラム名(key)：データ型("id"カラムは記述を除外) : 説明  
  name : string : ユーザー名  
  email : string : メールアドレス  
  password : string : パスワード  


2. Task : タスク  
  カラム名(英語)：データ型("id"カラムは記述を除外)   
  name : string : タスク名  
  description : text : タスクの説明  
  deadline : datetime : タスクの期限日  
  priority : integer : タスクの優先順位  
  status : integer : タスクの状態  
  user_id(FK) : integer : モデルUserのidを参照する外部キー  


3. Label : ラベル  
  カラム名(英語)：データ型("id"カラムは記述を除外)   
  name : string : ラベル名  


4. Relation : タスクとラベルの関連付けモデル
  カラム名(英語)：データ型("id"カラムは記述を除外)
  task_id(FK) : integer : モデルTaskのidを参照する外部キー
  label_id(FK) : integer : モデルLabelのidを参照する外部キー

UserモデルとTaskモデルは1対多の関係
TaskモデルとLabelモデルは多対多の関係であるため、Relationモデルを介して関連づける。
