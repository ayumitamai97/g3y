<template>
  <div class='container'>
    <article v-for="post in posts" :key="post.id" class='media'>
      <figure class='media-left'>image<br>image</figure>
      <div class='media-content'>
        <div>
          <span class='has-text-weight-bold'>{{ post.user.name }}</span>
          <span class='is-size-7'>{{ post.createdAt }}</span>
        </div>
        <div class='is-size-6'>{{ post.content }}</div>
      </div>
    </article>

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
      query: gql`query posts ($page: Int!, $pagePer: Int!) {
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
  created() {
    // this.$store.subscribe((mutation, state) => {
    //     console.log(state)
    //     console.log(mutation.payload)
    //     })
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
