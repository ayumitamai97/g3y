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
import Util from '../src/util.ts'

const pagePer: number = 20

export default {
  data() {
    return {
      posts: '',
      page: 0,
      showMoreEnabled: true,
    }
  },
  props: {
    query: { type: Object }
  },
  apollo: {
    posts: {
      query: gql`query posts ($contentOr: String, $contentAnd: String, $username: String, $page: Int!, $pagePer: Int!) {
        posts(contentOr: $contentOr, contentAnd: $contentAnd, username: $username, page: $page, pagePer: $pagePer) {
          content
          createdAt
          user {
            id
            name
          }
        }
      }`,
      // ref. Reactive parameters
      // https://apollo.vuejs.org/guide/apollo/queries.html#reactive-parameters
      variables() {
        return {
          contentOr: this.query.qContentOr,
          contentAnd: this.query.qContentAnd,
          username: this.query.qUsername,
          page: 0,
          pagePer,
        }
      },
    },

  },
  created() {
    this.$store.subscribe(async (mutation) => {
      if (mutation.type === 'postsUpdated') {
        await Util.sleep(1000)
        this.$apollo.queries.posts.refetch()
      }
    })
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
