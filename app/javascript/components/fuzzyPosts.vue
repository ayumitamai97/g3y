<template>
  <div class='container'>
    <div class='notification is-danger' v-if='errors.length > 0'>
      <button class='delete' @click='closeError'></button>
      <div v-for='error in errors' :key='error'>
        <p>{{ error }}</p>
      </div>
    </div>
    <div class='notification is-warning' v-if='warnings.length > 0'>
      <button class='delete' @click='closeWarning'></button>
      <div v-for='warning in warnings' :key='warning'>
        <p>{{ warning }}</p>
      </div>
    </div>

    <article v-for="post in fuzzyPosts" :key="post.id" class='media'>
      <figure class='media-left'>image<br>image</figure>
      <div class='media-content'>
        <div>
          <span class='has-text-weight-bold'>{{ post.user.name }}</span>
          <span class='is-size-7'>{{ post.createdAt }}</span>
        </div>
        <div class='is-size-6 wb-all'>{{ post.content }}</div>
      </div>
    </article>

    <infinite-loading @infinite='infiniteHandler' ref='infiniteLoading'></infinite-loading>
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'
import util from '../src/util.ts'

const pagePer: number = 20

export default {
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
    fuzzyPosts: {
      query: gql`query fuzzyPosts ($keyword: String, $page: Int!, $pagePer: Int!) {
        fuzzyPosts(keyword: $keyword, page: $page, pagePer: $pagePer) {
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
          keyword: this.query.qKeyword,
          page: 0,
          pagePer,
        }
      },
      // https://v4.apollo.vuejs.org/api/smart-query.html#options
      result({ data }): void {
        if (data.fuzzyPosts.length === 0) {
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
    this.closeError = util.closeError.bind(this)
    this.closeWarning = util.closeWarning.bind(this)
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
        updateQuery: (previousResult, { fetchMoreResult }): Object => {
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
