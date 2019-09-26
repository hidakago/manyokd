### README

**モデル情報**
※各モデルの"id"カラムに関しては記述を除外

1. User  

|モデル名 |日本語名|  
|--------|-------|  
|User    |ユーザー|  


|カラム名        |key|データ型|説明        |  
|---------------|---|------|------------|  
|name    　　　　|   |string|ユーザー名    |  
|email   　　　　|   |string|メールアドレス|  
|password_digest|   |string|パスワード   |  
|admin_allowed  |   |boolean|管理者権限の有無|
2. Task  

|モデル名 |日本語名|  
|--------|-------|  
|Task    |タスク  |  


|カラム名    |key|データ型  |説明          |  
|-----------|---|--------|--------------|  
|name       |   |string  |タスク名       |  
|description|   |text    |タスクの説明    |  
|deadline   |   |string  |タスクの期限日  |  
|status     |   |string  |タスクの状態   |  
|priority   |   |integer |タスクの優先順位|  
|user_id    |FK |integer |モデルUserのidを参照する外部キー|  


3. Label  

|モデル名 |日本語名|  
|--------|-------|  
|Label   |ラベル  |  


|カラム名 |key|データ型|説明        |  
|--------|---|------|------------|  
|name    |   |string|ラベル名     |  


4. Labeling  

|モデル名 |日本語名|  
|--------|-------|  
|Labeling|タスクとラベルの関連付けモデル  |  


|カラム名 |key|データ型|説明        |  
|--------|---|------|------------|  
|task_id |FK |integer|モデルTaskのidを参照する外部キー|  
|label_id|FK |integer|モデルLabelのidを参照する外部キー |  

UserモデルとTaskモデルは1対多の関係  
TaskモデルとLabelモデルは多対多の関係であるため、Labelingモデルを介して関連づける。  

**デプロイ手順**

1. アセットプリコンパイル実行
2. git add
3. git commit
4. Herokuにログインする
5. heroku create
6. git push heroku master
7. heroku run rails db:migrate
8. heroku open
