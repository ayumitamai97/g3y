<template>
  <div class='container'>
    <errors v-bind:errors='this.errors'></errors>
    <warnings v-bind:warnings='this.warnings'></warnings>

    <post
     v-for='post in posts' class='media' v-bind:key='post.id' v-bind:item='post'
    ></post>

    <infinite-loading @infinite='infiniteHandler' ref='infiniteLoading'></infinite-loading>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'
import util from '../src/util.ts'
import Post from './post.vue'
import Errors from './errors.vue'
import Warnings from './warnings.vue'

const pagePer: number = 20

export default {
  components: { Post, Errors, Warnings },
  data(): Object {
    return {
      page: 0,
      showMoreEnabled: true,
      errors: [],
      warnings: [],
    }
  },
  props: {
    query: {
      type: Object,
      default: (): Object => ({
        qContentOr: '',
        qContentAnd: '',
        qUsername: '',
        qKeyword: '',
        qCreatedAtAfter: '',
        qCreatedAtBefore: '',
      }),
    },
    queryField: {
      type: String,
      default: 'posts',
    },
  },
  apollo: {
    posts: {
      query: gql`query posts ($contentOr: String, $contentAnd: String, $username: String, $createdAtAfter: String, $createdAtBefore: String, $page: Int!, $pagePer: Int!) {
        posts(contentOr: $contentOr, contentAnd: $contentAnd, username: $username, createdAtAfter: $createdAtAfter, createdAtBefore: $createdAtBefore, page: $page, pagePer: $pagePer) {
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
      variables(): Object {
        return {
          contentOr: this.query.qContentOr,
          contentAnd: this.query.qContentAnd,
          username: this.query.qUsername,
          createdAtAfter: this.query.qCreatedAtAfter,
          createdAtBefore: this.query.qCreatedAtBefore,
          page: 0,
          pagePer,
        }
      },
      // https://v4.apollo.vuejs.org/api/smart-query.html#options
      result({ data }): void {
        if (!data.posts) { return }
        if (data.posts.length === 0) {
          this.warnings = ['Posts not found...']
        } else {
          this.warnings = []
        }
      },
      error(error) {
        this.errors.push(error.toString())
      },
    },
  },
  created(): void {
    this.$store.subscribe(async (mutation) => {
      if (mutation.type === 'postsUpdated') {
        await util.sleep(1000)
        this.$apollo.queries.posts.refetch()
      }
    })
  },
  beforeUpdate(): void {
    this.errors = this.errors.filter((v, i, a) => a.indexOf(v) === i)
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
          this.changeInfiniteState($state, fetchMoreResult.posts.length)

          return { posts: [...previousResult.posts, ...fetchMoreResult.posts] }
        },
      })
    },
    changeInfiniteState(state, length): void {
      if (length > 0) {
        state.loaded()
      } else {
        state.complete()
      }
    },
  },
}
</script>
