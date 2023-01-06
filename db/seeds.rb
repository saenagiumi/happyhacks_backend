# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  [
    {
      name: "河野太郎",
      email: "sample@example.com"
    },
    {
      name: "奈良公園のシカ",
      email: "sample@example.com"
    },
    {
      name: "ひがしものメバチマグロ",
      email: "sample@example.com"
    },
    {
      name: "エンバペ",
      email: "sample@example.com"
    },
    {
      name: "一太郎スマイル",
      email: "sample@example.com"
    },
    {
      name: "醸し人九平次",
      email: "sample@example.com"
    },
    {
      name: "秋田太平山",
      email: "sample@example.com"
    },
    {
      name: "ロナウジーニョ",
      email: "sample@example.com"
    },
    {
      name: "デジタル田園都市",
      email: "sample@example.com"
    },
    {
      name: "あさがおを摘む人",
      email: "sample@example.com"
    },
  ]
)

Post.create!(
  [
    {
      title: "順番待ちが苦手",
      body: "業務の優先順位をつけることが苦手なんですがどうしたらいいでしょうか？本当に困ってます業務の優先順位をつけることが苦手なんですがどうしたらいいでしょうか？本当に困ってます業務の優先順位をつけることが苦手なんですがどうしたらいいでしょうか？本当に困ってます",
      user_id: 1
    },
    {
      title: "興味のないこと、面倒なことを先延ばしにすること",
      body: "スケジュール管理や片付けが苦手どうしたらいいでしょうか？本当に困ってます",
      user_id: 2
    },
    {
      title: "スケジュール管理や片付けが苦手",
      body: "注意力・集中力が長続きしないどうしたらいいでしょうか？本当に困ってます注意力・集中力が長続きしないどうしたらいいでしょうか？本当に困ってます注意力・集中力が長続きしないどうしたらいいでしょうか？本当に困ってます",
      user_id: 3
    },
    {
      title: "注意力・集中力が長続きしない",
      body: "鍵をなくす、落とす、忘れるどうしたらいいでしょうか？本当に困ってます",
      user_id: 4
    },
    {
      title: "約束を忘れてしまうことが多い",
      body: "人間関係の悩みによって、うつ病や不眠などの二次障害が伴いやすいどうしたらいいでしょうか？本当に困ってます",
      user_id: 5
    },
    {
      title: "鍵をなくす、落とす、忘れる",
      body: "出先で物を置き忘れていくことが多いどうしたらいいでしょうか？本当に困ってます出先で物を置き忘れていくことが多いどうしたらいいでしょうか？本当に困ってます出先で物を置き忘れていくことが多いどうしたらいいでしょうか？本当に困ってます出先で物を置き忘れていくことが多いどうしたらいいでしょうか？本当に困ってます",
      user_id: 6
    },
    {
      title: "体調がなかなか安定しない",
      body: "体調がなかなか安定しないどうしたらいいでしょうか？本当に困ってます",
      user_id: 7
    },
    {
      title: "人間関係の悩みによって、うつ病や不眠などの二次障害が伴いやすい",
      body: "話かけられているのに気が付かないどうしたらいいでしょうか？本当に困ってます",
      user_id: 8
    },
    {
      title: "ここには質問のタイトルが入ります。多少長くなることもあるでしょう",
      body: "興味のないこと、面倒なことを先延ばしにすることどうしたらいいでしょうか？本当に困ってます興味のないこと、面倒なことを先延ばしにすることどうしたらいいでしょうか？本当に困ってます興味のないこと、面倒なことを先延ばしにすることどうしたらいいでしょうか？本当に困ってます興味のないこと、面倒なことを先延ばしにすることどうしたらいいでしょうか？本当に困ってます",
      user_id: 9
    },
    {
      title: "作業中にほかのことに気を取られる",
      body: "感情が高ぶりやすく、イライラしがちどうしたらいいでしょうか？本当に困ってます",
      user_id: 10
    }
  ]
)