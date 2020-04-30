<template>
  <div>
    <div v-for="post in posts" :key="post.id" class="p-home__posts__item c-post">
      <div class="c-post__meta">
        <div class="c-post__meta--username">{{ post.user.name }}</div>
        <div class="c-post__meta--created-at">{{ post.createdAt }}</div>
      </div>
      <div class="c-post__content">{{ post.content }}</div>
    </div>

    <infinite-loading @infinite="infiniteHandler"></infinite-loading>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

const pagePer: number = 20

export default {
  data() {
    return {
      posts: '',
      page: 0,
      showMoreEnabled: true,
    }
  },
  apollo: {
    // TODO: 検索結果にもこのコンポーネントが使われる
    posts: {
      query: gql`query posts ($page: Int!, $pagePer: Int) {
        posts(page: $page, pagePer: $pagePer) {
          content
          createdAt
          user {
            id
            name
          }
        }
      }`,
      variables: {
        page: 0,
        pagePer,
      },
    },
  },
  methods: {
    // ref.
    // https://apollo.vuejs.org/guide/apollo/pagination.html
    // https://peachscript.github.io/vue-infinite-loading/guide/start-with-hn.html
    infiniteHandler($state): void {
      this.page += 1
      this.$apollo.queries.posts.fetchMore({
        variables: {
          page: this.page,
          pagePer,
        },
        updateQuery: (previousResult, { fetchMoreResult }): Object => {
          if (fetchMoreResult.posts.length > 0) {
            $state.loaded()
          } else {
            $state.complete()
          }
          return { posts: [...previousResult.posts, ...fetchMoreResult.posts] }
        },
      })
    },
  },
}
</script>
