<template>
  <div class='container'>
    <div
      v-for='following in followings'
      :key='following.followingId'
    >
      {{ following.followingName }}
    </div>

    <infinite-loading
      ref='infiniteLoading'
      @infinite='infiniteHandler'
    />
  </div>
</template>

<script lang='ts'>
import gql from 'graphql-tag'

const pagePer: number = 20

export default {
  props: {
    query: {
      type: Object,
      default: (): Object => ({
      }),
    },
  },
  data(): Object {
    return {
      page: 0,
      errors: [],
      warnings: [],
    }
  },
  apollo: {
    followings: {
      query: gql`query followings ($followerId: ID, $followerName: String, $page: Int!, $pagePer: Int!) {
        followings(followerId: $followerId, followerName: $followerName, page: $page, pagePer: $pagePer) {
          followingId
          followingName
        }
      }`,
      // ref. Reactive parameters
      // https://apollo.vuejs.org/guide/apollo/queries.html#reactive-parameters
      variables(): Object {
        return {
          page: 0,
          pagePer,
        }
      },
      // https://v4.apollo.vuejs.org/api/smart-query.html#options
      result({ data }): void {
        if (!data) return
        if (data.followings.length === 0) {
          this.warnings = ['Followings not found...']
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
  },
  beforeUpdate(): void {
  },
  methods: {
    // ref.
    // https://apollo.vuejs.org/guide/apollo/pagination.html
    // https://peachscript.github.io/vue-infinite-loading/guide/start-with-hn.html
    infiniteHandler($state): void {
      this.page += 1
      this.$apollo.queries.followings.fetchMore({
        variables: {
          page: this.page,
          pagePer,
        },
        updateQuery: (previousResult, { fetchMoreResult }): Object => {
          this.changeInfiniteState($state, fetchMoreResult.followings.length)

          return { followings: [...previousResult.followings, ...fetchMoreResult.followings] }
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
