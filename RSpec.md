# RSpecの導入について

```
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
end
```

bundle installで導入

```
bundle exec rails g rspec:install
```

spec/rails_helperに追記
```
config.include FactoryBot::Syntax::Methods
```

config/application.rbに以下を追記
自動生成されるテストがrspec版になる
不要なテストファイルは生成しないように設定しておく。
```
    config.generators do |g|
      g.test_framework :rspec,
         fixtures: true, # フィクスチャを利用
         view_specs: false, # ビューはテストしない（フィーチャスペックを利用する。）
         helper_specs: false, # ヘルパーはテストしない
         routing_specs: false, # ルートはテストしない
         controller_specs: true, # コントローラはテストする
         request_specs: false # リクエストはテストしない
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
```