<template>
  <div>
    <div v-for="post in posts" :key="post.id" class="p-home__posts__item c-post">
      <div class="c-post--username">{{ post.user.name }}</div>
      <div class="c-post--content">{{ post.content }}</div>
    </div>
    <button v-if="showMoreEnabled" @click="showMore">Show more</button>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

const pagePer = 50

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
    // ref. https://apollo.vuejs.org/guide/apollo/pagination.html
    showMore() {
      this.page += 1
      this.$apollo.queries.posts.fetchMore({
        variables: {
          page: this.page,
          pagePer,
        },
        updateQuery: (previousResult, { fetchMoreResult }) => {
          return {
            posts: [...previousResult.posts, ...fetchMoreResult.posts],
          }
        },
      })
    },
  },
}
</script>
