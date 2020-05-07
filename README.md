# g3y
- gummy
- https://g3y.herokuapp.com/

![g3y_login](https://user-images.githubusercontent.com/29456740/81251315-efef0a00-905d-11ea-8809-9aefc36f6b9a.gif)


## Summary

```shell
$ tree -L 2 # 一部略
.
├── Gemfile
├── Gemfile.lock
├── Procfile
├── README.md
├── Rakefile
├── app
│   ├── channels
│   ├── controllers
│   ├── graphql
│   ├── javascript
│   ├── jobs
│   ├── mailers
│   ├── models
│   ├── services
│   └── views
├── babel.config.js
├── bin
│   ├── rails
│   ├── rake
│   ├── setup
│   ├── webpack
│   └── webpack-dev-server
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── cable.yml
│   ├── credentials.yml.enc
│   ├── database.yml
│   ├── elasticsearch.yml
│   ├── environment.rb
│   ├── environments
│   ├── initializers
│   ├── locales
│   ├── puma.rb
│   ├── routes.rb
│   ├── spring.rb
│   ├── storage.yml
│   ├── webpack
│   └── webpacker.yml
├── config.ru
├── db
│   ├── dev
│   ├── migrate
│   ├── schema.rb
│   └── seeds.rb
├── lib
│   └── tasks
├── node_modules
├── package.json
├── postcss.config.js
├── public
│   ├── packs
│   └── robots.txt
├── spec
│   ├── factories
│   ├── graphql
│   ├── models
│   ├── rails_helper.rb
│   ├── requests
│   ├── services
│   └── spec_helper.rb
├── storage
├── tsconfig.json
└── yarn.lock

$ tree app/javascript
app/javascript
├── components
│   ├── app.vue
│   ├── home.vue
│   ├── login.vue
│   ├── posts.vue
│   └── signup.vue
├── packs
│   ├── application.scss
│   └── application.ts
└── src
    └── authUtil.ts
```

# Local
- [Install Elasticsearch first](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)

```shell
$ cd elasticsearch-7.6.2
$ bin/elasticsearch
```

```shell
$ bin/setup
$ rails s
$ bin/webpack-dev-server
```

# docker-compose
TODO
