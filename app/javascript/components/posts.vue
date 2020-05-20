<template>
  <div class='container'>
    <errors :errors='errors' />
    <warnings :warnings='warnings' />

    <post
      v-for='post in posts'
      :key='post.id'
      :item='post'
      class='media'
    />

    <infinite-loading
      ref='infiniteLoading'
      @infinite='infiniteHandler'
    />
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
        qOnlyFollowings: false,
      }),
    },
    queryField: {
      type: String,
      default: 'posts',
    },
  },
  data(): Object {
    return {
      page: 0,
      showMoreEnabled: true,
      errors: [],
      warnings: [],
    }
  },
  apollo: {
    posts: {
      query: gql`query posts ($contentOr: String, $contentAnd: String, $username: String, $createdAtAfter: String, $createdAtBefore: String, $onlyFollowings: Boolean, $page: Int!, $pagePer: Int!) {
        posts(contentOr: $contentOr, contentAnd: $contentAnd, username: $username, createdAtAfter: $createdAtAfter, createdAtBefore: $createdAtBefore, onlyFollowings: $onlyFollowings, page: $page, pagePer: $pagePer) {
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
      variables(): object {
        return {
          contentOr: this.query.qContentOr,
          contentAnd: this.query.qContentAnd,
          username: this.query.qUsername,
          createdAtAfter: this.query.qCreatedAtAfter,
          createdAtBefore: this.query.qCreatedAtBefore,
          onlyFollowings: this.query.qOnlyFollowings,
          page: 0,
          pagePer,
        }
      },
      // https://v4.apollo.vuejs.org/api/smart-query.html#options
      result({ data }): void {
        if (!data) return

        if (data.posts.length === 0) {
          this.warnings = ['Posts not found...']
        } else {
          this.warnings = []
        }
      },
      error(error): void {
        this.errors.push(error.toString())
      },
    },
  },
  created(): void {
    this.$apollo.queries.posts.refetch()
    this.$store.subscribe(async (mutation) => {
      if (mutation.type === 'postsUpdated' || mutation.type === 'relationshipUpdated') {
        await util.sleep(1500)
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
