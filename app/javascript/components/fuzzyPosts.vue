<template>
  <div class='container'>
    <errors :errors='errors' />
    <warnings :warnings='warnings' />

    <post
      v-for='post in fuzzyPosts'
      :key='post.id'
      class='media'
      :item='post'
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
      default: (): object => ({
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
  data(): object {
    return {
      page: 0,
      showMoreEnabled: true,
      errors: [],
      warnings: [],
    }
  },
  apollo: {
    fuzzyPosts: {
      query: gql`query fuzzyPosts ($keywords: String!, $page: Int!, $pagePer: Int!) {
        fuzzyPosts(keywords: $keywords, page: $page, pagePer: $pagePer) {
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
          keywords: this.query.qKeyword,
          page: 0,
          pagePer,
        }
      },
      // https://v4.apollo.vuejs.org/api/smart-query.html#options
      result({ data }): void {
        if (!data) return
        if (data.fuzzyPosts.length === 0) {
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
    this.$apollo.queries.fuzzyPosts.refetch()
    this.$store.subscribe(async (mutation) => {
      if (mutation.type === 'postsUpdated' || mutation.type === 'relationshipUpdated') {
        await util.sleep(1000)
        this.$apollo.queries.fuzzyPosts.refetch()
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
      this.$apollo.queries.fuzzyPosts.fetchMore({
        variables: {
          page: this.page,
          pagePer,
        },
        updateQuery: (previousResult, { fetchMoreResult }): object => {
          this.changeInfiniteState($state, fetchMoreResult.fuzzyPosts.length)

          return { fuzzyPosts: [...previousResult.fuzzyPosts, ...fetchMoreResult.fuzzyPosts] }
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
